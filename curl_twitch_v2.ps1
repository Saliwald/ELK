Function Get-StreamGame{ 
    $curl = curl.exe --insecure --silent https://api.twitch.tv/kraken/streams
    $data = $curl | ConvertFrom-Json

    $games = $data.streams.game | Sort-Object -Unique
    $games = $games | ? {$_}
    foreach($games in $games){
        $var = $data.streams | where {$_.game -eq $games}
        $totalviewers = ($var.viewers | Measure-Object -sum).sum
        Write-Host "$games;$totalviewers"
    }
}

Function Get-Streamers{
    $curl = curl.exe --insecure --silent https://api.twitch.tv/kraken/streams
    $data = $curl | ConvertFrom-Json

    $s = $data.streams._links.count
    $s = $s - 1
    $i = 0
    while($i -le $s){
        
        $streamer = $data.streams | where {$_._links.self -eq $data.streams._links.self[$i]}
        $name = $streamer.channel.name
        $game = $streamer.channel.game
        $viewers = $streamer.viewers
        $followers = $streamer.channel.followers

        write-host "$name;$game;$viewers;$followers"
        $i++
    }
}

Get-StreamGame
Get-Streamers