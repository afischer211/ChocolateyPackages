﻿Uninstall-ChocolateyEnvironmentVariable 'JAVA_HOME' 'Machine'
rm -r 'C:\Program Files\Liberica\jdk-12.0.1'

$pathToUnInstall = 'C:\Program Files\Liberica\jdk-12.0.1\bin'
$pathType = 'Machine'

if ($env:PATH.ToLower().Contains($pathToUnInstall.ToLower()))
{
	$statementTerminator = ";"
	Write-Host "PATH environment variable contains $pathToUnInstall. Removing..."
	$actualPath = [System.Collections.ArrayList](Get-EnvironmentVariable -Name 'Path' -Scope $pathType).split($statementTerminator)

	$actualPath.Remove($pathToUnInstall)	
	$newPath =  $actualPath -Join $statementTerminator

	if ($pathType -eq [System.EnvironmentVariableTarget]::Machine) {
		if (Test-ProcessAdminRights) {
			Set-EnvironmentVariable -Name 'Path' -Value $newPath -Scope $pathType
		} else {
			$psArgs = "UnInstall-ChocolateyPath -pathToUnInstall `'$originalPathToUnInstall`' -pathType `'$pathType`'"
			Start-ChocolateyProcessAsAdmin "$psArgs"
		}
	} else {
		Set-EnvironmentVariable -Name 'Path' -Value $newPath -Scope $pathType
	}
}

