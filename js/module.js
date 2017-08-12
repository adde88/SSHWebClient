registerController('SSHWebClient_Controller', ['$api', '$scope', '$rootScope', '$interval', '$timeout', function($api, $scope, $rootScope, $interval, $timeout) {
	$scope.title = 'Loading...';
	$scope.version = 'Loading...';

  $scope.refreshInfo = (function() {
		$api.request({
            module: 'SSHWebClient',
            action: 'refreshInfo'
        }, function(response) {
						$scope.title = response.title;
						$scope.version = 'v'+response.version;
        })
    });

		$scope.refreshInfo();

}]);

registerController('SSHWebClient_ControlsController', ['$api', '$scope', '$rootScope', '$interval', '$timeout', function($api, $scope, $rootScope, $interval, $timeout) {
	$scope.install = 'Loading...';
	$scope.installLabel = 'default';
	$scope.processing = false;
	$scope.ipaddress = 'null...';

	$scope.device = '';
	$scope.sdAvailable = false;

	$rootScope.status = {
		installed : false,
	};

    $scope.refreshStatus = (function() {
		$api.request({
            module: 'SSHWebClient',
            action: 'refreshStatus'
        }, function(response) {
			$rootScope.status.installed = response.installed;
			$scope.device = response.device;
			$scope.sdAvailable = response.sdAvailable;
			if(response.processing) $scope.processing = true;
			$scope.install = response.install;
			$scope.installLabel = response.installLabel;
        })
    });

    $scope.handleDependencies = (function(param) {
        if(!$rootScope.status.installed)
			$scope.install = 'Installing...';
		else
			$scope.install = 'Removing...';

		$api.request({
            module: 'SSHWebClient',
            action: 'handleDependencies',
			destination: param
        }, function(response){
            if (response.success === true) {
				$scope.installLabel = 'warning';
				$scope.processing = true;

                $scope.handleDependenciesInterval = $interval(function(){
                    $api.request({
                        module: 'SSHWebClient',
                        action: 'handleDependenciesStatus'
                    }, function(response) {
                        if (response.success === true){
                            $scope.processing = false;
							$scope.refreshStatus();
                            $interval.cancel($scope.handleDependenciesInterval);
                        }
                    });
                }, 5000);
            }
        });
    });

	$scope.refreshStatus();

}]);

registerController('SSHWebClient_InterfaceController', ['$api', '$scope', '$rootScope', '$interval', function($api, $scope, $rootScope, $interval) {
	$scope.device = '';
	$scope.ipaddress = '172.16.42.1';
	
    $scope.getIpaddress = (function() {
		$api.request({
            module: 'SSHWebClient',
            action: 'getIpaddress'
        }, function(response) {
			$scope.ipaddress = response.ipaddress;
        })
    });
	
	$scope.getIpaddress();

}]);