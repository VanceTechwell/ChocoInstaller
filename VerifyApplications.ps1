# Define a function to download and verify the applications
function Verify-Download {
    param (
        [string]$url,
        [string]$installerPath
    )

    try {
        # Download the installer
        Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop

        # Check if the installer file exists and has a valid size
        if (Test-Path -Path $installerPath -PathType Leaf -ErrorAction Stop) {
            $fileInfo = Get-Item -Path $installerPath
            if ($fileInfo.Length -gt 0) {
                Write-Output "Download verified: $installerPath"
            } else {
                Write-Output "Downloaded file is empty: $installerPath"
            }
        } else {
            Write-Output "Download failed: $installerPath does not exist."
        }
    }
    catch {
        Write-Output "Failed to download from $url. Error: $_"
    }
}

# Define a function to download and install applications
function Install-Application {
    param (
        [string]$url,
        [string]$installerPath
    )
    
    # Download the installer
    Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop
    
    # Install the application
    Start-Process -FilePath $installerPath -ArgumentList '/S' -NoNewWindow -Wait
    
    # Remove the installer after installation
    Remove-Item -Path $installerPath
}

# List of applications to install
$applications = @(
    @{Name = 'VLC'; Url = 'https://ziply.mm.fcix.net/videolan-ftp/vlc/3.0.21/win64/vlc-3.0.21-win64.exe'; Installer = 'C:\Temp\VLCInstaller.exe'}
    @{Name = 'WinRAR'; Url = 'https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe'; Installer = 'C:\Temp\WinRARInstaller.exe'}
    @{Name = 'GoogleChrome'; Url = 'https://www.google.com/chrome/next-steps.html?statcb=0&installdataindex=empty&defaultbrowser=0#' ; Installer = 'C:\Temp\GoogleChromeInstaller.exe'}
    @{Name = 'Firefox'; Url = 'https://www.mozilla.org/firefox/download/thanks/' ; Installer = 'C:\Temp\FirefoxInstaller.exe'}
    @{Name = 'Docker-Desktop'; Url = 'https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-win-amd64' ; Installer = 'C:\Temp\DockerDesktopInstaller.exe'}
    @{Name = 'Python'; Url = 'https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe' ; Installer = 'C:\Temp\PythonInstaller.exe'}
    


)

# Create the Temp directory if it doesn't exist
if (-Not (Test-Path -Path 'C:\Temp')) {
    New-Item -ItemType Directory -Path 'C:\Temp'
}

# Verify the download for each application
foreach ($app in $applications) {
    Write-Output "Verifying download for $($app.Name)..."
    Verify-Download -url $app.Url -installerPath $app.Installer
}

# Ask the user for confirmation before proceeding with the installation
$confirmation = Read-Host "Do you want to proceed with the installation? (y/n)"
if ($confirmation -eq 'y') {
    # Install each application
    foreach ($app in $applications) {
        Write-Output "Installing $($app.Name)..."
        Install-Application -url $app.Url -installerPath $app.Installer
    }
    Write-Output "All applications have been installed."
} else {
    Write-Output "Installation aborted by the user."
}

