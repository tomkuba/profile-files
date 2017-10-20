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
# Persistent History

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

Start-SshAgent

# shorcut to CopyLastCommandToClipboard
function CopyLastCommandToClipboard {(Get-History)[-1].CommandLine | clip}
Set-Alias cc -value CopyLastCommandToClipboard

# shortcut to parent folder
Set-Alias .. -value cd..

# motd
write-host ":: Hello tomio, your favourite commands are: cc, ..                           ::"
write-host ":: feel free to add more commands anytime                                     ::"


#function prompt
#{
#    "PS" + " [$(Get-Date -format T)] " + $(get-location)+">"
#}

$GitPromptSettings.DefaultPromptPrefix = '[$(Get-Date -format T)] '

Import-Module posh-git
