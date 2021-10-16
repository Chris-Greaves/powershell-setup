[CmdletBinding()]
param (
    # Skip Installing Terminal-Icons
    [Parameter()]
    [switch]
    $skipTerminalIcons,
    # Skip Installing PSReadLine
    [Parameter()]
    [switch]
    $skipPSReadLine,
    # Skip Installing Oh My Posh
    [Parameter()]
    [switch]
    $skipOhMyPosh,
    # Skip Installing Nerd Font
    [Parameter()]
    [switch]
    $skipNerdFont
)

if (!$skipTerminalIcons) {
    echo "Installing Icons"
    Install-Module -Name Terminal-Icons -Repository PSGallery   
}

if (!$skipPSReadLine) {
    echo "Installing PSReadLine"
    Install-Module PSReadLine -AllowPrerelease -AllowClobber -Force
}

if (!$skipOhMyPosh) {
    echo "Installing Oh My Posh"
    winget install JanDeDobbeleer.OhMyPosh
}

if (!$skipNerdFont) {
    echo "Installing Nerd fonts"
    $dloadLink = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"
    $tempFolder = "$env:temp\PowerShell-Setup"
    $tempFontZip = "$tempFolder\fonts.zip"

    md -Force "$tempFolder\fonts"

    echo "Downloading fonts"
    Invoke-WebRequest -Uri $dloadLink -OutFile $tempFontZip
    Expand-Archive -Path $tempFontZip -DestinationPath "$tempFolder\fonts"

    echo "Installing each ttf font"
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in gci "$tempFolder\fonts\*.ttf")
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            echo $fileName
            dir $file | %{ $fonts.CopyHere($_.fullname) }
        }
    }
    cp "$tempFolder\fonts\*.ttf" C:\windows\fonts\
}

echo "Copying PowerShell profile"
Copy-Item ".\Microsoft.PowerShell_profile.ps1" -Destination $profile

echo "Copying Oh My Posh theme"
Copy-Item ".\blueier.omp.json" -Destination $HOME