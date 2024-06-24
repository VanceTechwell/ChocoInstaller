# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install it first."
    exit 1
}

# List of software to verify
$packages = @(
    "zoom"
)

# Initialize lists to track successful and failed verifications
$successfulVerifications = @()
$failedVerifications = @()

# Verify each package
foreach ($package in $packages) {
    Write-Host "Verifying installation of $package..."
    try {
        $verifyResult = choco list --local-only | Select-String -Pattern $package
        if ($verifyResult) {
            $successfulVerifications += $package
        } else {
            $failedVerifications += $package
        }
    } catch {
        $failedVerifications += $package
    }
}

# Log the results
Write-Host "Verification completed!"
Write-Host "`nPackages successfully verified:"
if ($successfulVerifications.Count -eq 0) {
    Write-Host "None"
} else {
    $successfulVerifications | ForEach-Object { Write-Host $_ }
}

Write-Host "`nPackages that failed verification:"
if ($failedVerifications.Count -eq 0) {
    Write-Host "None"
} else {
    $failedVerifications | ForEach-Object { Write-Host $_ }
}
