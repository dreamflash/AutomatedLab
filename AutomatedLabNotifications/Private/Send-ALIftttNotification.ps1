function Send-ALIftttNotification
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Activity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    $lab = Get-Lab -ErrorAction SilentlyContinue

    $key = (Get-LabConfigurationItem -Name NotificationProviders).Ifttt.Key
    $eventName = (Get-LabConfigurationItem -Name NotificationProviders).Ifttt.EventName

    $messageBody = @{
        value1 = $lab.Name + " on " + $lab.DefaultVirtualizationEngine
        value2 = $Activity
        value3 = $Message
    }

    try 
    {
        $request = Invoke-WebRequest -Method Post -Uri https://maker.ifttt.com/trigger/$($eventName)/with/key/$($key) -ContentType "application/json" -Body ($messageBody | ConvertTo-Json -Compress) -ErrorAction Stop
        
        if (-not $request.StatusCode -eq 200)
        {
            Write-Verbose -Message "Notification to IFTTT could not be sent with event $eventName. Status code was $($request.StatusCode)"
        }
    }
    catch 
    {
        Write-Verbose -Message "Notification to IFTTT could not be sent with event $eventName."
    }    
}
