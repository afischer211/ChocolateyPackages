﻿Uninstall-ChocolateyEnvironmentVariable 'JAVA_HOME' 'Machine'
rm -r 'C:\Program Files\AdoptOpenJDK\jdk-11.0.4+11'

$pathToUnInstall = 'C:\Program Files\AdoptOpenJDK\jdk-11.0.4+11\bin'
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

$AdoptOpenJDKDirectory = 'C:\Program Files\AdoptOpenJDK'
If ((Get-ChildItem -Force $AdoptOpenJDKDirectory) -eq $Null) {
    rmdir $AdoptOpenJDKDirectory 
}