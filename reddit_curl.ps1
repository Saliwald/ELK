Function Get-Stats ($sub){
$url = "https://www.reddit.com/r/$sub/about.json"
$Path = "C:\temp\data\reddit_curl.txt"
$header = "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:48.0) Gecko/20100101 Firefox/48.0"

$sidebardata = curl.exe --silent --header $header -k $url
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

$sub = "sysadmin"
$i = 0
While($i -lt 999){
    Get-Stats $sub | Out-File "C:\temp\data\reddit_curl.log" -Append utf8
    Start-Sleep 30
    $i++
}
Write-Host "Run complete - $i updates"
