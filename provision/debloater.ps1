# Win11Debloat see:
# https://github.com/Raphire/Win11Debloat/wiki/Command%E2%80%90line-Interface#parameters
# https://github.com/Raphire/Win11Debloat/wiki/Automation
# 
# -Silent to ensure the script runs without requiring any user input, 
# -CreateRestorePoint ensures a restore point is created before execution, 
# -RemoveApps removes the default selection of apps, and 
# -DisableTelemetry disables telemetry.

& ([scriptblock]::Create((irm "https://debloat.raphi.re/"))) -Silent -RemoveApps -DisableTelemetry

