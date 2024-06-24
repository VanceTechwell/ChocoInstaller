# Define a function to download and install applications
function Install-Application {
    param (
        [string]$url,
        [string]$installerPath
    )
    
    # Download the installer
    Invoke-WebRequest -Uri $url -OutFile $installerPath
    
    # Install the application
    Start-Process -FilePath $installerPath -ArgumentList '/S' -NoNewWindow -Wait
    
    # Remove the installer after installation
    Remove-Item -Path $installerPath
}

# List of applications to install
$applications = @(
    @{Name = 'VLC'; Url = 'https://ziply.mm.fcix.net/videolan-ftp/vlc/3.0.21/win64/vlc-3.0.21-win64.exe'; Installer = 'C:\Temp\VLCInstaller.exe'}
)

# Create the Temp directory if it doesn't exist
if (-Not (Test-Path -Path 'C:\Temp')) {
    New-Item -ItemType Directory -Path 'C:\Temp'
}

# Install each application
foreach ($app in $applications) {
    Write-Output "Installing $($app.Name)..."
    Install-Application -url $app.Url -installerPath $app.Installer
}

Write-Output "All applications have been installed."
