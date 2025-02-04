[CmdletBinding()]
param (
    # Skip Installing Winget and Packages
    [Parameter()]
    [switch]
    $skipWingetInstall,
    # Skip Installing Chocolately
    [Parameter()]
    [switch]
    $skipChocolatelyInstall,
    # Skip Installing Powershell Core
    [Parameter()]
    [switch]
    $skipPowershellCore,
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
    $skipNerdFont,
    # Skip Installing GGH
    [Parameter()]
    [switch]
    $skipGGH
)

if (!$skipWingetInstall) {
    Invoke-Expression -Command $PSScriptRoot/winget_install.ps1
}

if (!$skipChocolatelyInstall) {
    Invoke-Expression -Command $PSScriptRoot/chocolately_install.ps1
}

if (!$skipPowershellCore) {
    winget install --id Microsoft.Powershell --source winget
}

if (!$skipTerminalIcons) {
    Write-Output "Installing Icons"
    Install-Module -Name Terminal-Icons -Repository PSGallery
}

if (!$skipPSReadLine) {
    if($PSVersionTable.PSEdition -ne "Core") {
        Write-Output "Installing PowerShellGet"
        Install-Module -Name PowerShellGet -Force
    }
    Write-Output "Installing PSReadLine"
    Install-Module PSReadLine -AllowPrerelease -AllowClobber -Force
}

if (!$skipOhMyPosh) {
    Write-Output "Installing Oh My Posh"
    winget install JanDeDobbeleer.OhMyPosh
}

if (!$skipNerdFont) {
    Write-Output "Installing Nerd fonts"
    $dloadLink = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"
    $tempFolder = "$env:temp\PowerShell-Setup"
    $tempFontZip = "$tempFolder\fonts.zip"

    mkdir -Force "$tempFolder\fonts"

    Write-Output "Downloading fonts"
    Invoke-WebRequest -Uri $dloadLink -OutFile $tempFontZip
    Expand-Archive -Path $tempFontZip -DestinationPath "$tempFolder\fonts"

    Write-Output "Installing each ttf font"
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in Get-ChildItem "$tempFolder\fonts\*.ttf")
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            Write-Output $fileName
            Get-ChildItem $file | ForEach-Object { $fonts.CopyHere($_.fullname) }
        }
    }
    Copy-Item "$tempFolder\fonts\*.ttf" C:\windows\fonts\
}

if (!$skipGGH) {
    Write-Output "Installing GGH"
    powershell -c "irm https://raw.githubusercontent.com/byawitz/ggh/master/install/windows.ps1 | iex"
}

Write-Output "Copying PowerShell profile"
Copy-Item ".\Microsoft.PowerShell_profile.ps1" -Destination $profile

Write-Output "Copying Oh My Posh theme"
Copy-Item ".\blueier.omp.json" -Destination $HOME