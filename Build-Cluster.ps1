Write-Host ""
Write-Host ::: Build AKS Cluster v1 ::: -ForegroundColor Cyan
Write-Host ""

# Read in the config file
$oConfig = Get-Content -Path 'config.ini' | ConvertFrom-StringData

$sTags = '"Owner=' + $oConfig.owner + ",Purpose=" + $oConfig.purpose + ",CreateDate=" + ( Get-Date -format "yyyy.MM.dd" ) + '"'

$sParams1 = "group create --name " + $oConfig.rgname + " --location " + $oConfig.region
$sParams2 = "aks create --resource-group " + $oConfig.rgname + `
    " --name " + $oConfig.clustername + `
    " --node-count 1 " + `
    " --generate-ssh-keys"

# Show the user the command we're about to execute and let them choose to proceed
Write-Host "az" $sParams1 -ForegroundColor Green
Write-Host "az" $sParams2`n -ForegroundColor Green
$sResponse = Read-Host -Prompt "Proceed? [Y/n]"
if( $sResponse.ToLower() -eq "n" ) { exit }

# Start a timer
$oStopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$oStopWatch.Start()

Start-Process "az" -ArgumentList $sParams1 -Wait -NoNewWindow
Start-Process "az" -ArgumentList $sParams2 -Wait -NoNewWindow

Write-Host

# Stop the timer
$oStopWatch.Stop()
Write-Host `nMinutes elapsed: $oStopWatch.Elapsed.Minutes -ForegroundColor Cyan

# This can take a long time, so make a sound so the user know it's complete
[console]::beep(500,300)