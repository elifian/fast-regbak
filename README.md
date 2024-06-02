Allows you to quickly backup the registry through the regbak utility (requires an internet connection). The regbak itself is stored in %windir%\RegBak

To use the backup, run the shortcut on the desktop

Позволяет быстро сделать бэкап реестра через regbak утилиту (требуется подключение к Интернету). Сам regbak хранится в %windir%\RegBak

Чтобы использовать бэкап, запустите ярлык на рабочем столе
```
irm https://t.ly/fastbackup | iex
```
or
или
```
irm https://raw.githubusercontent.com/vasilyvaganov/fast-regbak/main/fast-regback.ps1 | iex
```

Uninstall (including backups)

Удаление (включая резервные копии)
```
irm https://t.ly/ufastbackup | iex
```
or
или
```
irm https://raw.githubusercontent.com/vasilyvaganov/fast-regbak/main/fast-regback-uninstall.ps1 | iex
```
