$subs = @("sysadmin","starcitizen","wow")


$accesstoken = curl.exe --silent -X POST -d 'grant_type=password&username=saliwald&password=docentdod3' --user 'M1e6pBz6JlhPsA:aQr70XjtcUp3QDYpuI_Wqoz90cs' --insecure https://ssl.reddit.com/api/v1/access_token
$token0 -match '"access_token": "[A-Za-z0-9_-]+"'
$token1 = $Matches[0]
$token1 -match ': "[A-Za-z0-9_-]+"'
$token2 = $Matches[0]
$token2 -match '[A-Za-z0-9_-]+'
$token = $Matches[0]$token

Function Get-Stats ($sub){
$url = "https://oauth.reddit.com/api/v1/me"
$Path = "C:\temp\data\reddit_curl.txt"
$header = "Authorization: bearer $token" 
$user = "application/test-logger v0.1 by saliwald"

$sidebardata = curl.exe -D "C:\temp\data\header.txt" -H "Authorization: bearer k6rzXMHPDw4jfjN6GuDhwT-H948" -A $user -k https://oauth.reddit.com/api/v1/me
$Timestamp = Get-Date -format s
$Timestamp = $Timestamp + ".000Z"

If ($sidebardata -match '"accounts_active": [0-9]+'){
    $var = $Matches[0]
    If ($var -match "[0-9]+"){
        $CurrU = $Matches[0]
        }
    else{
        $CurrU = "No user data collected"
    }
    }
If ($sidebardata -match '"subscribers": [0-9]+'){
    $var = $Matches[0]
    If ($var -match "[0-9]+"){
        $CurrS = $Matches[0]
    }
    else{
        $CurrS = "No subscriber data collected"
    }
}
Return "$sub;$CurrU;$CurrS"
}

$i = 0
While($i -lt 999){
    foreach ($sub in $subs){
        Get-Stats $sub | Out-File "C:\temp\data\reddit_curl.log" -Append utf8
    }
    $i++
    write-host $i
    Start-Sleep 30
}
Write-Host "Run complete - $i updates"