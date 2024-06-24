# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install it first."
    exit 1
}

# List of software to uninstall
$packages = @(
    "zoom"
)

# Initialize lists to track successful and failed uninstallations
$successfulUninstallations = @()
$failedUninstallations = @()

# Uninstall each package
foreach ($package in $packages) {
    Write-Host "Uninstalling $package..."
    try {
        $result = choco uninstall $package -y
        if ($result -match "uninstalled") {
            $successfulUninstallations += $package
        } else {
            $failedUninstallations += $package
        }
    } catch {
        $failedUninstallations += $package
    }
}

# Log the results
Write-Host "Uninstallation completed!"
Write-Host "`nPackages successfully uninstalled:"
if ($successfulUninstallations.Count -eq 0) {
    Write-Host "None"
} else {
    $successfulUninstallations | ForEach-Object { Write-Host $_ }
}

Write-Host "`nPackages that failed to uninstall:"
if ($failedUninstallations.Count -eq 0) {
    Write-Host "None"
} else {
    $failedUninstallations | ForEach-Object { Write-Host $_ }
}
