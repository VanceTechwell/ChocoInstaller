# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install it first."
    exit 1
}

# List of software to install
$packages = @(
    "flashplayerplugin"
)

# Initialize lists to track successful and failed installations
$successfulInstallations = @()
$failedInstallations = @()

# Install each package
foreach ($package in $packages) {
    Write-Host "Installing $package..."
    try {
        $result = choco install $package -y
        if ($result -match "installed 1/1" -or $result -match "Chocolatey installed") {
            $successfulInstallations += $package
        } else {
            $failedInstallations += $package
        }
    } catch {
        $failedInstallations += $package
    }
}

# Log the results
Write-Host "Installation completed!"
Write-Host "`nPackages successfully installed:"
if ($successfulInstallations.Count -eq 0) {
    Write-Host "None"
} else {
    $successfulInstallations | ForEach-Object { Write-Host $_ }
}

Write-Host "`nPackages that failed to install:"
if ($failedInstallations.Count -eq 0) {
    Write-Host "None"
} else {
    $failedInstallations | ForEach-Object { Write-Host $_ }
}
