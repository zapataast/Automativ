$hosts = 'C:\Windows\System32\drivers\etc\hosts'

    $is_blocked = Get-Content -Path $hosts |
    Select-String -Pattern ([regex]::Escape("facebook.com"))

    If(-not $is_blocked) {
       Add-Content -Path $hosts -Value "127.0.0.1 facebook.com"
    }
