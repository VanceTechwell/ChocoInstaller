# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install it first."
    exit 1
}

# List of software to install
$packages = @(
    "googlechrome",
    "flashplayerplugin"
)

# Initialize lists to track successful and failed simulations
$successfulSimulations = @()
$failedSimulations = @()

# Simulate the installation of each package
foreach ($package in $packages) {
    Write-Host "Simulating installation of $package..."
    try {
        $result = choco install $package --what-if
        if ($result -match "Chocolatey would have used the following repositories") {
            $successfulSimulations += $package
        } else {
            $failedSimulations += $package
        }
    } catch {
        $failedSimulations += $package
    }
}

# Log the results
Write-Host "Simulation completed successfully!"
Write-Host "`nPackages successfully simulated:"
if ($successfulSimulations.Count -eq 0) {
    Write-Host "None"
} else {
    $successfulSimulations | ForEach-Object { Write-Host $_ }
}

Write-Host "`nPackages that failed simulation:"
if ($failedSimulations.Count -eq 0) {
    Write-Host "None"
} else {
    $failedSimulations | ForEach-Object { Write-Host $_ }
}
