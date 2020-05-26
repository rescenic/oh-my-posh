#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    #check the last command state and indicate if failed
    $promtSymbolColor = $sl.Colors.PromptSymbolColor
    If ($lastCommandFailed) {
        $promtSymbolColor = $sl.Colors.WithForegroundColor
    }

    # Writes the postfixes to the prompt
    $prompt += Write-Prompt -Object (
        [char]::ConvertFromUtf32(0x276F)) -ForegroundColor  $sl.Colors.GitNoLocalChangesAndAheadColor
    $prompt += Write-Prompt -Object (
        [char]::ConvertFromUtf32(0x276F) +"  ") -ForegroundColor $promtSymbolColor 

    # Writes the drive portion
    $drive = $sl.PromptSymbols.HomeSymbol
    if ($pwd.Path -ne $HOME) {
        $drive = "$(Split-Path -path $pwd -Leaf)"
    }
    $prompt += Write-Prompt -Object $drive -ForegroundColor $sl.Colors.DriveForegroundColor

    $status = Get-VCSStatus
    if ($status) {
        $prompt += Write-Prompt -Object " git:(" -ForegroundColor $sl.Colors.PromptHighlightColor
        $prompt += Write-Prompt -Object "$($status.Branch)" -ForegroundColor $sl.Colors.WithForegroundColor
        $prompt += Write-Prompt -Object ")" -ForegroundColor $sl.Colors.PromptHighlightColor
        if ($status.Working.Length -gt 0) {
            $prompt += Write-Prompt -Object (" " + $sl.PromptSymbols.GitDirtyIndicator) -ForegroundColor $sl.Colors.GitDefaultColor
        }
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }
    $prompt += Set-Newline
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor $sl.Colors.PromptBackgroundColor
    
    $prompt += '  '
    $prompt
}

function Get-TimeSinceLastCommit {
    return (git log --pretty=format:'%cr' -1)
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.PromptIndicator = '👁'
$sl.PromptSymbols.HomeSymbol = '🏠'
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.DriveForegroundColor = [ConsoleColor]::Cyan
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
$sl.PromptSymbols.GitDirtyIndicator ='📌'
$sl.Colors.GitDefaultColor = [ConsoleColor]::Yellow
