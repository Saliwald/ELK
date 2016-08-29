$subs = @("wow","transmogrification","wowui","wowcomics","wowguilds","wowstreams","lookingforgroup","wowraf","wownewbieraids","woweconomy","wowgoldmaking")

Function Get-Token{
$accesstoken = curl.exe --silent -X POST --header "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:48.0) Gecko/20100101 Firefox/48.0" -d 'grant_type=password&username=saliwald&password=docentdod3' --user 'M1e6pBz6JlhPsA:aQr70XjtcUp3QDYpuI_Wqoz90cs' --insecure https://ssl.reddit.com/api/v1/access_token
$accesstoken -match '"access_token": "[A-Za-z0-9_-]+"'
$token1 = $Matches[0]
$token1 -match ': "[A-Za-z0-9_-]+"'
$token2 = $Matches[0]
$token2 -match '[A-Za-z0-9_-]+'
$token = $Matches[0]
return $token
}

Function Get-Stats ($sub){
$url = "https://oauth.reddit.com/r/$sub/about.json"
$Path = "C:\temp\data\reddit_curl.txt"
$header = "Authorization: bearer $token" 
$user = "application/test-logger v0.1 by saliwald"

$sidebardata = curl.exe --silent -k -D "C:\temp\data\header.txt" -H $header -A $user $url
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
Return "$sub;$CurrU;$CurrS;$Timestamp"
}

$r = 0
$c = 0

While ($true){
    
    $token = Get-Token
    $token = $token[3]
    $i = 0
    $r++

    While($i -lt 1){
        foreach ($sub in $subs){

            $data = Get-Stats $sub

            If ($data[$sub.Length + 1] -eq ";"){
                $i = 2
                write-host "Resetting at $p!"
                $p = 0
                break
            }
            else{
                $data | Out-File "C:\temp\data\reddit_curl.log" -Append utf8
            }
        }
        $p++
        $c++
        write-host $p
        Start-Sleep 60
    }
    Write-Host "$r token updates, $c total runs"
}

