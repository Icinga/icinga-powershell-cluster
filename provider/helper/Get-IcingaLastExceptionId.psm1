function Get-IcingaLastExceptionId()
{
    if ([string]::IsNullOrEmpty($Error)) {
        return '';
    }

    [string]$ExceptionId = ([string]($Error.FullyQualifiedErrorId)).Split(',')[0].Split(' ')[1];
    $Error.Clear();

    return $ExceptionId;
}
