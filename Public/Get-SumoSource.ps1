function Get-SumoSource {
    [cmdletbinding(DefaultParameterSetName="SourceId")]
    Param
    (
      [parameter(Mandatory=$true)]
      [string]
      $CollectorId,
      [parameter(Mandatory=$false)]
      [string]
      $SourceId,
      [Parameter(Mandatory=$false)]
      [switch]
      $DownloadSourceConfig,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Location = $Script:PSSumoLogic.Location,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $AccessId = $Script:PSSumoLogic.AccessId,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $AccessKey = $Script:PSSumoLogic.AccessKey
    )
    $headers = @{
        Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $AccessId,$AccessKey))))"
    }
    $URI = "https://api.$($Location).sumologic.com/api/v1/collectors/$($CollectorId)/sources"
    if ($SourceId){
        $URI = "$($URI)/$($SourceId)"
        $Prop = "source"
    }
    else {
        $Prop = "sources"
    }
    if ($DownloadSourceConfig) {
        $URI = "$($URI)?download=true"
    }
    try {
        $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $headers -ContentType "application/json" -ErrorAction Stop
        if (!$DownloadSourceConfig) {
            $response = $response | Select-Object -ExpandProperty $Prop
        }
    }
    catch {
        $_
        return
    }
    return $response
}