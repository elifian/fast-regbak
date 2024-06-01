# Установка переменных
$zipUrl = "https://www.acelogix.com/downloads/regbak.zip"
$zipPath = "$env:TEMP\regbak.zip"
$extractPath = "$env:TEMP\regbak"
$destPath = "$env:windir\RegBak"
$backupPath = "$destPath\<date>\<time>"

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

# Запуск RegBak.exe или RegBak64.exe с указанными аргументами
Start-Process -FilePath "$destPath\$exeFile" -ArgumentList "/dir:`"$backupPath`" /reg:[su] /silent /desc:`"Backup`"" -Wait

# Очистка временных файлов
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force
