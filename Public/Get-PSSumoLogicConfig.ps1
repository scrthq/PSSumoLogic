Function Get-PSSumoLogicConfig {
    [cmdletbinding(DefaultParameterSetName = 'source')]
    param(
        [parameter(ParameterSetName='source')]
        [ValidateSet("PSSumoLogic","PSSumoLogic.xml")]
        $Source = "PSSumoLogic",
        [parameter(ParameterSetName='path')]
        [parameter(ParameterSetName='source')]
        $Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml"
    )
    if($PSCmdlet.ParameterSetName -eq 'source' -and $Source -eq "PSSumoLogic" -and -not $PSBoundParameters.ContainsKey('Path')) {
        $Script:PSSumoLogic
    }
    else {
        function Decrypt {
            param($String)
            if($String -is [System.Security.SecureString]) {
                [System.Runtime.InteropServices.marshal]::PtrToStringAuto(
                    [System.Runtime.InteropServices.marshal]::SecureStringToBSTR(
                        $string))
            }
        }
        Import-Clixml -Path $Path | Select-Object -Property @{N='Location';E={Decrypt $_.Location}},@{N='AccessId';E={Decrypt $_.AccessId}},@{N='AccessKey';E={Decrypt $_.AccessKey}}
    }
}