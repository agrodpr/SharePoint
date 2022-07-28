Set-SPLogLevel -TraceSeverity VerboseEx

New-splogfile

Reproduce the issue

New-splogfile

Clear-Sploglevel

iisreset

Merge-SPLogFile -Path "C:\AccessError.log" -correlation 02b350a0-79b0-303a-f36e-d4283641a0f7