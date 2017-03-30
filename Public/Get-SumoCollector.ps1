function Get-SumoCollector {
    Param
    (
      [parameter(Mandatory=$false)]
      [string]
      $CollectorId,
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
    $URI = "https://api.$($Location).sumologic.com/api/v1/collectors"
    if ($CollectorId){
        $URI = "$($URI)/$($CollectorId)"
        $Prop = "collector"
    }
    else {
        $Prop = "collectors"
    }
    try {
        $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $headers -ContentType "application/json" -ErrorAction Stop | Select-Object -ExpandProperty $Prop
    }
    catch {
        $_
        return
    }
    return $response
}