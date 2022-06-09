
$current_date = Get-Date;
$last_day = [DateTime]::DaysInMonth($current_date.Year, $current_date.Month)
$last_day_date = $current_date.AddDays($last_day-$current_date.Day)
for ($i = 1; $i -lt 8; $i++) {
    Write-Output $last_day_date.DayOfWeek;

    if($last_day_date.DayOfWeek -eq 'Monday'){
        $dargiin_odor = $last_day_date.Day;
        break;
    }
    $last_day_date = $last_day_date.AddDays(-1);
}
Write-Output $dargiin_odor;