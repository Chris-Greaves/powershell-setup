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
    $skipOhMyPosh
)

if (!$skipTerminalIcons) {
    Install-Module -Name Terminal-Icons -Repository PSGallery   
}

if (!$skipPSReadLine) {
    Install-Module PSReadLine -AllowPrerelease -AllowClobber -Force
}

if (!$skipOhMyPosh) {
    winget install JanDeDobbeleer.OhMyPosh
}

Copy-Item ".\Microsoft.PowerShell_profile.ps1" -Destination $profile

Copy-Item ".\blueier.omp.json" -Destination $HOME