$var = curl.exe --insecure https://api.twitch.tv/kraken/streams
$data = $var | ConvertFrom-Json

$lists = @("World of Warcraft","Dota 2")

Function Get-Stream($game){
    $var = $data.streams | where {$_.game -eq $game}

    $totalviewers = ($var.viewers | Measure-Object -sum).sum

return "$game;$totalviewers"
}

foreach($list in $lists){
    Get-Stream $list
}