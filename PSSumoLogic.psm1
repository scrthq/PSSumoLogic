#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$ModuleRoot = $PSScriptRoot

#Dot source the files
Foreach($import in @($Public + $Private))
    {
    Try
        {
        . $import.fullname
        }
    Catch
        {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

#Create / Read config
if(-not (Test-Path -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml" -ErrorAction SilentlyContinue))
    {
    Try
        {
        Write-Warning "Did not find config file $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml, attempting to create"
        [pscustomobject]@{
            AccessId = $null
            AccessKey = $null
            } | Export-Clixml -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml" -Force -ErrorAction Stop
        }
    Catch
        {
        Write-Warning "Failed to create config file $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml: $_"
        }
    }

#Initialize the config variable
Try
    {
    #Import the config
    if ($PSSumoLogic){Remove-Variable PSSumoLogic -ErrorAction SilentlyContinue}
    $PSSumoLogic = Get-PSSumoLogicConfig -Source "PSSumoLogic.xml" -ErrorAction Stop

    }
Catch
    {   
    Write-Warning "Error importing PSSumoLogic config: $_"
    }
    
Export-ModuleMember -Function $Public.Basename