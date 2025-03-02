Add-Type -AssemblyName System.Windows.Forms

# Erstellen des Form-Fensters
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Impero Killer v1"
$Form.WindowState = 'Minimized'   
$Form.ShowInTaskbar = $true       
$Form.FormBorderStyle = 'None'    
$Form.Opacity = 0    

# Suchen des Executables
$searchPath = "C:\"
$exeName = "Impero Killer.exe"
$exePath = "" 
$exeFile = Get-ChildItem -Path $searchPath -Recurse -Filter $exeName -ErrorAction SilentlyContinue | Select-Object -First 1
if ($exeFile) { 
    $exePath = $exeFile.FullName 
    try { 
        $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath) 
        $Form.Icon = $icon 
    } catch { 
        $Form.Icon = [System.Drawing.SystemIcons]::Information  
    } 
} else {
    $Form.Icon = [System.Drawing.SystemIcons]::Information 
}

$global:stopFlag = $false

# SystemTray Icon erstellen
$trayIcon = New-Object System.Windows.Forms.NotifyIcon
$trayIcon.Icon = $Form.Icon
$trayIcon.Visible = $false # Zuerst unsichtbar
$trayIcon.Text = "Impero Killer"

# Kontextmenü für das Tray-Icon
$contextMenu = New-Object System.Windows.Forms.ContextMenu
$exitMenuItem = New-Object System.Windows.Forms.MenuItem "Beenden"
$contextMenu.MenuItems.Add($exitMenuItem)

# Wenn "Beenden" im Tray-Menü gewählt wird, wird das Skript beendet
$exitMenuItem.Add_Click({
    $global:stopFlag = $true
    $trayIcon.Visible = $false
    [System.Windows.Forms.Application]::Exit()
})

$trayIcon.ContextMenu = $contextMenu

# Ereignis, wenn das Fenster aktiviert wird (wenn der Benutzer darauf klickt)
$Form.Add_Activated({
    if (-not $global:stopFlag) {
        # Dialog anzeigen, wenn das Fenster wieder aktiviert wird
        $result = [System.Windows.Forms.MessageBox]::Show("Impero aktivieren?", "Beenden", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            $global:stopFlag = $true
            [System.Windows.Forms.Application]::Exit()
        } elseif ($result -eq [System.Windows.Forms.DialogResult]::No) {
            # Minimieren des Fensters und weitermachen
            $Form.WindowState = 'Minimized'
        } elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
            $Form.Hide()  # Versteckt das Fenster
            $trayIcon.Visible = $true
            $Form.ShowInTaskbar = $false
        }
    }
})

Start-Job -ScriptBlock{
    while (-not $global:stopFlag) {
        $process = Get-Process -Name "backdropclient" -ErrorAction SilentlyContinue
        if ($process) {
            Stop-Process -Name "backdropclient" -Force
        }
        Start-Sleep -Seconds 1
    }
} | Out-Null

[System.Windows.Forms.Application]::Run($Form)
