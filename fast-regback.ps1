# Установка переменных
$zipUrl = "https://www.acelogix.com/downloads/regbak.zip"
$zipPath = "$env:TEMP\regbak.zip"
$extractPath = "$env:TEMP\regbak"
$destPath = "$env:windir\RegBak"
$backupPath = "$destPath\<date>\<time>"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "RegBak.lnk")

# Определение версии файла для распаковки и запуска в зависимости от разрядности ОС
if ([Environment]::Is64BitOperatingSystem) {
    $exeFile = "RegBak64.exe"
} else {
    $exeFile = "RegBak.exe"
}

# Создание директории назначения, если она не существует
if (-Not (Test-Path -Path $destPath)) {
    New-Item -Path $destPath -ItemType Directory -Force
}

# Загрузка .zip архива
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Распаковка архива
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Перенос файла в директорию назначения
Move-Item -Path "$extractPath\$exeFile" -Destination "$destPath\$exeFile" -Force

# Переименование файла, если он был RegBak64.exe
if ($exeFile -eq "RegBak64.exe") {
    Rename-Item -Path "$destPath\RegBak64.exe" -NewName "RegBak.exe" -Force
}

# Запуск RegBak.exe с указанными аргументами
Start-Process -FilePath "$destPath\RegBak.exe" -ArgumentList "/dir:`"$backupPath`" /reg:[su] /silent /desc:`"Backup`"" -Wait

# Создание ярлыка на рабочем столе
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($desktopPath)
$shortcut.TargetPath = "$destPath\RegBak.exe"
$shortcut.IconLocation = "$destPath\RegBak.exe, 0"
$shortcut.Save()

# Очистка временных файлов
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force
