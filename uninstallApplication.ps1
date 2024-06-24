# Define a function to uninstall applications
function Uninstall-Application {
    param (
        [string]$appName
    )

    $app = Get-CimInstance -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$appName%'" -ErrorAction SilentlyContinue
    if ($app) {
        Write-Output "Uninstalling $appName..."
        $app | Invoke-CimMethod -MethodName Uninstall | Out-Null
        Write-Output "$appName has been uninstalled."
    } else {
        Write-Output "$appName is not installed on this system."
    }
}

# List of applications to uninstall
$applications = @(
    'VLC'
)

# Uninstall each application
foreach ($appName in $applications) {
    Uninstall-Application -appName $appName
}

Write-Output "All specified applications have been uninstalled."
