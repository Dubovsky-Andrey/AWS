function Connect-SSH {
    param (
        [string]$keyPairPath = "C:\kpaws1.pem",
        [string]$ipAddress,
        [string]$userName = "ec2-user"
    )

    if (Test-Path -Path $keyPairPath -PathType Leaf) {
        ssh -i $keyPairPath "$userName@$ipAddress"
    } else {
        Write-Host "Keypair file not found at $keyPairPath"
    }
}