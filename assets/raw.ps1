Add-Type -AssemblyName System.Windows.Forms
$title = ""
$popupMessage = ""

$trayIcon = New-Object System.Windows.Forms.NotifyIcon
$trayIcon.Icon = [System.Drawing.SystemIcons]::Information
$trayIcon.Visible = $true
$contextMenu = New-Object System.Windows.Forms.ContextMenu
$exitMenuItem = New-Object System.Windows.Forms.MenuItem ""
$contextMenu.MenuItems.Add($exitMenuItem)
$exitMenuItem.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("", "", [System.Windows.Forms.MessageBoxButtons]::OK)
    $trayIcon.Visible = $false
    $global:stopFlag = $true
    $global:job | Stop-Job
    [System.Windows.Forms.Application]::Exit()
})

$trayIcon.ContextMenu = $contextMenu

function Show-Icon {
    [System.Windows.Forms.Application]::Run()
}

$global:job = Start-Job -ScriptBlock { 
    Show-Icon
} | Out-Null
$global:stopFlag = $false
while (-not $global:stopFlag) {
    $process = Get-Process -Name "backdropclient" -ErrorAction SilentlyContinue
    if ($process) {
        Stop-Process -Name "backdropclient" -Force
    }
    Start-Sleep -Milliseconds 500
}
Exit

