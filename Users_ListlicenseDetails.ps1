# Get Users List of license Details

$Token = Get-Content .\Token.txt

# Replace 'C:\path\to\your\file.csv' with the actual path to your CSV file
$csvFile = ".\Output\01\Users.csv"

# Import the CSV file
$users = Import-Csv -Path $csvFile

# Iterate through each row in the CSV and extract the userPrincipalName
$GetUsersUPN = foreach ($user in $users) {
    $userPrincipalName = $user.userPrincipalName
    $userPrincipalName
}

#endregion
foreach ($GetUserUPN in $GetUsersUPN) {
    #region generic variables

    $BaseApi = 'https://graph.microsoft.com'
    $ApiVersion = 'v1.0'
    $Endpoint = "/users/$GetUserUPN/licenseDetails"

    $Uri = "{0}/{1}{2}" -f $BaseApi, $ApiVersion, $Endpoint

    $Headers = @{
        'Authorization' = 'Bearer ' + $Token
        'Content-Type'  = 'application/json'
    }

    $RequestProperties = @{
        Uri     = $Uri
        Method  = 'GET'
        Headers = $Headers
    }
    #endregion

    #region Invoke-WebRequest
    $DataWR = Invoke-RestMethod @RequestProperties
    Write-Host "$GetUserUPN" -BackgroundColor Cyan -ForegroundColor Black
    Write-Output "--------------------------------------"
    Write-Output $GetUserUPN
    Write-Output "--------------------------------------"
    Write-Output " "
    $DataWR.value.servicePlans | Sort-Object appliesTo
    
}

