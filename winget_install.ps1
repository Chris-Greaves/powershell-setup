# Install Winget, if not already installed
if (!(Get-Command -Name winget)) {
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted | Out-Null
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-installer/releases/latest/download/winget.exe', 'C:\Windows\Temp\winget.exe')
    Start-Process -FilePath 'C:\Windows\Temp\winget.exe' -ArgumentList '--install' --Wait
}

# List of packages to install
$packages = @(
    "dotPDN.PaintDotNet",
    "Nushell.Nushell",
    "Eugeny.Tabby",
    "Microsoft.PowerToys",
    "Obsidian.Obsidian",
    "Postman.Postman",
    "Notepad++.Notepad++"
)

foreach ($package in $packages) {
    winget install --accept-source-agreement --silent --quiet $package
}
