Set-MpPreference -DisableRealtimeMonitoring $false # Windows defender TURN OFF
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False  # FireWALL TURN OFF
