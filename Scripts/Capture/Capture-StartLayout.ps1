$Path = "c:\temp"

$PolicySource = "C:\Windows\System32\GroupPolicy"
$SecurityInfFile = "C:\Windows\System32\GroupPolicy\security.inf"
$StartLayoutFile = "C:\Windows\System32\GroupPolicy\layout.xml"

secedit /export /cfg $SecurityInfFile

Export-StartLayout -Path $StartLayoutFile

xcopy $PolicySource\*.* $Path\*.* /s /d /h /r /y