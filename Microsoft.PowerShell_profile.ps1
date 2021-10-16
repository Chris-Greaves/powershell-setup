# Import Terminal-Icons
Import-Module -Name Terminal-Icons

# PSReadLine
Import-Module PSReadLine

## PSReadLine History
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle ListView

oh-my-posh --init --shell pwsh --config ~\blueier.omp.json | Invoke-Expression
