Write-Host "Programm aktiviert"
Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Impero Killer v1"
$Form.WindowState = 'Minimized'   
$Form.ShowInTaskbar = $true       
$Form.FormBorderStyle = 'None'    
$Form.Opacity = 0    

$searchPath = "C:\"
$exeName = "Impero Killer.exe"
$exePath = "" 
$exeFile = Get-ChildItem -Path $searchPath -Recurse -Filter $exeName -ErrorAction SilentlyContinue | Select-Object -First 1 # Wenn eine .exe-Datei gefunden wurde 
if ($exeFile) { 
$exePath = $exeFile.FullName 
try { 
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath) 
$Form.Icon = $icon 
} 
catch { 
$Form.Icon = [System.Drawing.SystemIcons]::Information  
} 
} 
else {
$Form.Icon = [System.Drawing.SystemIcons]::Information 
}


$global:stopFlag = $false
$Form.Add_FormClosed({
   $global:stopFlag = $true
   Write-Host "Programm beendet"
   [System.Windows.Forms.Application]::Exit()
})
Start-Job -ScriptBlock{
while (-not $global:stopFlag) {
    $process = Get-Process -Name "backdropclient" -ErrorAction SilentlyContinue
    if ($process) {
        Stop-Process -Name "backdropclient" -Force
       # Write-Host "Impero beendet"
    }
    Start-Sleep -Seconds 1
}


} | Out-Null


[System.Windows.Forms.Application]::Run($Form)


