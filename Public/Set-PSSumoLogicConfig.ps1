function Set-PSSumoLogicConfig {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$false)]
        [ValidateSet("US1","US2","EU","AU")]
        [string]
        $Location,
        [parameter(Mandatory=$false)]
        [string]
        $AccessId,
        [parameter(Mandatory=$false)]
        [string]
        $AccessKey,
        [parameter(Mandatory=$false)]
        [string]
        $Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-PSSumoLogic.xml"
    )
    Switch ($PSBoundParameters.Keys) {
        'Location'{$Script:PSSumoLogic.Location = $Location}
        'AccessId'{$Script:PSSumoLogic.AccessId = $AccessId}
        'AccessKey'{$Script:PSSumoLogic.AccessKey = $AccessKey}
    }
    Function Encrypt {
        param([string]$string)
        if($String -notlike '') {
            ConvertTo-SecureString -String $string -AsPlainText -Force
        }
    }
    $Script:PSSumoLogic | Select-Object -Property @{N='Location';E={Encrypt $_.Location}},@{N='AccessId';E={Encrypt $_.AccessId}},@{N='AccessKey';E={Encrypt $_.AccessKey}} | Export-Clixml -Path $Path -Force
}