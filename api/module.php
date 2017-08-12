<?php namespace pineapple;
putenv('LD_LIBRARY_PATH='.getenv('LD_LIBRARY_PATH').':/sd/lib:/sd/usr/lib');
putenv('PATH='.getenv('PATH').':/sd/usr/bin:/sd/usr/sbin');

class SSHWebClient extends Module
{
	public function route()
	{
		switch ($this->request->action) {
			case 'refreshInfo':
				$this->refreshInfo();
				break;
			case 'refreshStatus':
                $this->refreshStatus();
                break;
            case 'handleDependencies':
                $this->handleDependencies();
                break;
            case 'handleDependenciesStatus':
                $this->handleDependenciesStatus();
                break;
			case 'getIpaddress':
                $this->getIpaddress();
                break;
			case 'getDevice':
                $this->getDevice();
                break;
        }
    }

	protected function checkDependency($dependencyName)
	{
		return ((exec("which {$dependencyName}") == '' ? false : true) && ($this->uciGet("sshwebclient.module.installed")));
	}

	protected function getDevice()
	{
		return trim(exec("cat /proc/cpuinfo | grep machine | awk -F: '{print $2}'"));
	}

	protected function refreshInfo()
	{
		$moduleInfo = @json_decode(file_get_contents("/pineapple/modules/SSHWebClient/module.info"));
		$this->response = array('title' => $moduleInfo->title, 'version' => $moduleInfo->version);
	}

	private function handleDependencies()
    {
		if(!$this->checkDependency("shellinaboxd"))
		{
			$this->execBackground("/pineapple/modules/SSHWebClient/scripts/dependencies.sh install ".$this->request->destination);
			$this->response = array('success' => true);
		}
		else
		{
	        $this->execBackground("/pineapple/modules/SSHWebClient/scripts/dependencies.sh remove");
	        $this->response = array('success' => true);
		}
	}

    private function handleDependenciesStatus()
    {
        if (!file_exists('/tmp/SSHWebClient.progress'))
		{
            $this->response = array('success' => true);
        }
		else
		{
            $this->response = array('success' => false);
        }
    }
	
    private function getIpaddress()
    {
		$kake = trim(exec("ifconfig br-lan 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'"));
		$this->response = array('ipaddress' => $kake);
    }

    private function refreshStatus()
    {
	    if (!file_exists('/tmp/SSHWebClient.progress'))
		{
			if(!$this->checkDependency("shellinaboxd"))
			{
				$installed = false;
				$install = "Not installed";
				$installLabel = "danger";
				$processing = false;
			}
			else
			{
				$installed = true;
				$install = "Installed";
				$installLabel = "success";
				$processing = false;
			}
	    }
		else
		{
			$installed = false;
			$install = "Installing...";
			$installLabel = "warning";
			$processing = true;
		}

			$device = $this->getDevice();
			$sdAvailable = $this->isSDAvailable();

			$this->response = array("device" => $device, "sdAvailable" => $sdAvailable, "installed" => $installed, "install" => $install, "installLabel" => $installLabel, "processing" => $processing);
	}

}
