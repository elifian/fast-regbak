$destPath = "$env:windir\RegBak"
if (Test-Path -Path $destPath) {
        Remove-Item -Path $destPath -Recurse -Force
        Write-Output "Directory removed."
}