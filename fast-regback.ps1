# Установка переменных
$zipUrl = "https://www.acelogix.com/downloads/regbak.zip"
$zipPath = "$env:TEMP\regbak.zip"
$extractPath = "$env:TEMP\regbak"
$destPath = "$env:windir\RegBak"
$backupPath = "$destPath\<date>\<time>"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "RegBak.lnk")
$regBakExePath = "$destPath\RegBak.exe"

# Создание директории назначения, если она не существует
if (-Not (Test-Path -Path $destPath)) {
    New-Item -Path $destPath -ItemType Directory -Force
}

# Проверка существования RegBak.exe
if (-Not (Test-Path -Path $regBakExePath)) {
    # Определение версии файла для распаковки и запуска в зависимости от разрядности ОС
    if ([Environment]::Is64BitOperatingSystem) {
        $exeFile = "RegBak64.exe"
    } else {
        $exeFile = "RegBak.exe"
    }

    # Загрузка .zip архива
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

    # Распаковка архива
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    # Перенос файла в директорию назначения
    Move-Item -Path "$extractPath\$exeFile" -Destination "$destPath\$exeFile" -Force

    # Переименование файла, если он был RegBak64.exe и если RegBak.exe не существует
    if ($exeFile -eq "RegBak64.exe" -and -Not (Test-Path -Path "$regBakExePath")) {
        Rename-Item -Path "$destPath\RegBak64.exe" -NewName "RegBak.exe" -Force
    }

    # Очистка временных файлов
    Remove-Item -Path $zipPath -Force
    Remove-Item -Path $extractPath -Recurse -Force
}

# Запуск RegBak.exe с указанными аргументами
Start-Process -FilePath "$regBakExePath" -ArgumentList "/dir:`"$backupPath`" /reg:[su] /silent /desc:`"Backup`"" -Wait

# Запуск меню RegBak
Start-Process -FilePath "$regBakExePath"

# Проверка существования regbak-desktop.ini
if (-Not (Test-Path -Path $destPath\regbak-desktop.ini)) {
    # Создание ярлыка на рабочем столе
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($desktopPath)
    $shortcut.TargetPath = "$regBakExePath"
    $shortcut.IconLocation = "$regBakExePath, 0"
    $shortcut.Save()
    New-Item -Path $destPath -Name "regbak-desktop.ini" -ItemType "file"
    }
