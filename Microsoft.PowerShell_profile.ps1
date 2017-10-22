Import-Module posh-git
Start-SshAgent

# Linux like autocomplete on Tab
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
    Set-PSReadlineKeyHandler -Key Tab -Function Complete
}

# Persistent History
$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Insert double quotes
Set-PSReadlineKeyHandler -Chord 'Oem7','Shift+Oem7' `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadline]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadline]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadline]::SetCursorPosition($cursor - 1)
    }
}

# CopyLastCommandToClipboard + shortcut
function CopyLastCommandToClipboard {(Get-History)[-1].CommandLine | clip}
Set-Alias cc -value CopyLastCommandToClipboard

# Shortcut to parent folder
Set-Alias .. -value cd..

# Welcome message
write-host ":: Hello tomio, your favourite commands are: cc, ..                           ::"
write-host ":: feel free to add more commands anytime                                     ::"

# Prompt example: [14:38:41] C:\Users\tomkuba>
$GitPromptSettings.DefaultPromptPrefix = '[$(Get-Date -format T)] '