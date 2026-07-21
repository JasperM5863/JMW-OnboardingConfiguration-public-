# JMW Laptop or Desktop Onboarding Config - script that has EVERYTHING, I stole this xaml from a college project I did lol
# Note: This is the public release version, the orignal script had sensative information. It's been refactored to have domain controller dependencies replaced by internet-based downloads (Winget)

Add-Type -AssemblyName PresentationFramework

# 
# Block 1: LOAD XAML GUI (the UI layout)
# 
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Laptop/Desktop Onboarding Config" Height="750" Width="900" WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="200"/>
        </Grid.RowDefinitions>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="6*"/>
            <ColumnDefinition Width="4*"/>
        </Grid.ColumnDefinitions>

        <Border Grid.Row="0" Grid.ColumnSpan="2" Background="#FFEB9C" BorderBrush="#FFC000" BorderThickness="1" Padding="10" Margin="0,0,0,10">
            <TextBlock Text="NOTE: Make sure you ran PowerShell as an administrator prior to opening this, otherwise it won't work!" 
                       Foreground="#9C5700" FontWeight="Bold" TextAlignment="Center" FontSize="14"/>
        </Border>

        <ScrollViewer Grid.Row="1" Grid.Column="0" VerticalScrollBarVisibility="Auto" Margin="0,0,10,0">
            <StackPanel>
                <TextBlock Text="Customize" FontWeight="Bold" FontSize="18" Margin="0,0,0,10" Foreground="#005A9C"/>

                <GroupBox Margin="0,0,0,10">
                    <GroupBox.Header>
                        <TextBlock Text="Install Applications" FontWeight="Bold"/>
                    </GroupBox.Header>
                    <StackPanel Margin="5">
                        <CheckBox x:Name="chkChrome" Content="Google Chrome" Margin="0,2"/>
                        <CheckBox x:Name="chkDrive" Content="Google Drive" Margin="0,2"/>
                        <CheckBox x:Name="chkAdobe" Content="Adobe Acrobat Reader" Margin="0,2"/>
                        
                        <Grid Margin="0,2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <CheckBox x:Name="chkBluebeam" Content="Bluebeam Revu" VerticalAlignment="Center"/>
                            <ComboBox x:Name="cmbBluebeamSource" Grid.Column="1" Margin="10,0,0,0" Width="120" HorizontalAlignment="Left">
                                <!-- <ComboBoxItem Content="Domain Controller"/> -->
                                <ComboBoxItem Content="Web (Latest)" IsSelected="True"/>
                            </ComboBox>
                        </Grid>

                        <Grid Margin="0,2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <CheckBox x:Name="chkVista" Content="Viewpoint Vista" VerticalAlignment="Center"/>
                        </Grid>
                    </StackPanel>
                </GroupBox>

                <GroupBox Margin="0,0,0,10">
                    <GroupBox.Header>
                        <TextBlock Text="Install Prerequisites" FontWeight="Bold"/>
                    </GroupBox.Header>
                    <StackPanel Margin="5">
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                            <TextBlock Text="Source for all Pre-reqs: " VerticalAlignment="Center"/>
                            <ComboBox x:Name="cmbPrereqSource" Width="150">
                                <!-- <ComboBoxItem Content="Domain Controller"/> -->
                                <ComboBoxItem Content="Web (Latest)" IsSelected="True"/>
                            </ComboBox>
                        </StackPanel>
                        <CheckBox x:Name="chkVC" Content="VC++ Redistributable (14.42.34433)" Margin="0,2" ToolTip="Required for Bluebeam Revu &amp; Vista ODBC"/>
                        <CheckBox x:Name="chkODBC" Content="Microsoft ODBC Driver for SQL Server" Margin="0,2" ToolTip="Required for Viewpoint Vista"/>
                        <CheckBox x:Name="chkNet" Content=".NET Framework 4.8" Margin="0,2" ToolTip="Required for Viewpoint Vista"/>
                        <CheckBox x:Name="chkCrystal" Content="SAP Crystal Reports" Margin="0,2" ToolTip="Required for Viewpoint Vista"/>
                    </StackPanel>
                </GroupBox>

                <GroupBox Margin="0,0,0,10">
                    <GroupBox.Header>
                        <TextBlock Text="OS &amp; Office Tweaks" FontWeight="Bold"/>
                    </GroupBox.Header>
                    <StackPanel Margin="5">
                        <CheckBox x:Name="chkDebloat" Content="Run Windows 11 Debloater" Margin="0,2"/>
                        <CheckBox x:Name="chkOffice" Content="Clean and Install Office LTSC 2024" Margin="0,2"/>
                    </StackPanel>
                </GroupBox>

                <GroupBox Margin="0,0,0,10">
                    <GroupBox.Header>
                        <TextBlock Text="Windows Updates/Patches" FontWeight="Bold"/>
                    </GroupBox.Header>
                    <StackPanel Margin="5">
                        <RadioButton x:Name="radUpdateDefault" Content="Default (No modifications)" IsChecked="True" Margin="0,2"/>
                        <RadioButton x:Name="radUpdateDelay" Content="Delay Updates (Features: 365 days | Security: 4 days | No Drivers)" Margin="0,2"/>
                    </StackPanel>
                </GroupBox>

                <GroupBox Margin="0,0,0,10">
                    <GroupBox.Header>
                        <TextBlock Text="Rename PC (REQUIRES RESTART)" FontWeight="Bold"/>
                    </GroupBox.Header>
                    <StackPanel Margin="5">
                        <CheckBox x:Name="chkRename" Content="Apply Naming Convention (First/Middle Initial + Last Name + PC)" Margin="0,0,0,5"/>
                        
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                            <TextBlock Text="First: " VerticalAlignment="Center"/>
                            <TextBox x:Name="txtFirstName" Width="80" Margin="0,0,10,0"/>
                            
                            <TextBlock Text="Middle: " VerticalAlignment="Center"/>
                            <TextBox x:Name="txtMiddleName" Width="80" Margin="0,0,10,0"/>
                            
                            <TextBlock Text="Last: " VerticalAlignment="Center"/>
                            <TextBox x:Name="txtLastName" Width="80"/>
                        </StackPanel>
                        
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="PC-Name Preview: " VerticalAlignment="Center" Foreground="Gray" FontStyle="Italic"/>
                            <TextBlock x:Name="txtPreviewPCName" Text="WAITING FOR INPUT..." FontWeight="Bold" Foreground="#005A9C" VerticalAlignment="Center" FontSize="14"/>
                        </StackPanel>
                    </StackPanel>
                </GroupBox>
                <Button x:Name="btnRunCustom" Content="Run Custom Selection" Height="35" Margin="0,10,0,0" Background="#005A9C" Foreground="White" FontWeight="Bold"/>
            </StackPanel>
        </ScrollViewer>

        <Border Grid.Row="1" Grid.Column="1" BorderBrush="LightGray" BorderThickness="1,0,0,0" Padding="10,0,0,0">
            <StackPanel>
                <TextBlock Text="Preset" FontWeight="Bold" FontSize="18" Margin="0,0,0,10" Foreground="#005A9C"/>
                <TextBlock Text="Runs all items in the Customize column automatically. Defaults to Web (Latest) for files." TextWrapping="Wrap" Margin="0,0,0,20" FontStyle="Italic"/>
                
                <Button x:Name="btnRunPreset" Content="Run Onboarding Process Preset" Height="60" Background="#28a745" Foreground="White" FontWeight="Bold" FontSize="14"/>
                
                <TextBlock Text="Sleep settings are automatically turned off during execution then back on after execution." TextWrapping="Wrap" Margin="0,20,0,0" Foreground="Gray"/>
            </StackPanel>
        </Border>

        <GroupBox Grid.Row="2" Grid.ColumnSpan="2" Margin="0,10,0,0">
            <GroupBox.Header>
                <TextBlock Text="Execution Log &amp; Progress" FontWeight="Bold"/>
            </GroupBox.Header>
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                
                <ProgressBar x:Name="pbStatus" Grid.Row="0" Height="20" Margin="5" Minimum="0" Maximum="100" Value="0"/>
                
                <TextBox x:Name="txtLog" Grid.Row="1" Margin="5" IsReadOnly="True" VerticalScrollBarVisibility="Auto" Background="Black" Foreground="#00FF00" FontFamily="Consolas" TextWrapping="Wrap"/>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# 
# Block 2: MAP UI ELEMENTS TO POWERSHELL VARIABLES
# 

# find the specific elements by their x:Name in the XAML
$txtLog         = $Window.FindName("txtLog")
$pbStatus       = $Window.FindName("pbStatus")
$txtFirstName   = $Window.FindName("txtFirstName")
$txtLastName    = $Window.FindName("txtLastName")
$txtMiddleName    = $Window.FindName("txtMiddleName")
$txtPreviewPCName = $Window.FindName("txtPreviewPCName")
$btnRunCustom   = $Window.FindName("btnRunCustom")
$btnRunPreset   = $Window.FindName("btnRunPreset")

# apps + prereq
$chkChrome      = $Window.FindName("chkChrome")
$chkVista       = $Window.FindName("chkVista")
$cmbVistaSource = $Window.FindName("cmbVistaSource")
$chkDrive       = $Window.FindName("chkDrive")
$chkAdobe       = $Window.FindName("chkAdobe")
$cmbPrereqSource= $Window.FindName("cmbPrereqSource")
$chkODBC        = $Window.FindName("chkODBC")
$chkNet         = $Window.FindName("chkNet")
$chkCrystal     = $Window.FindName("chkCrystal")
$chkVC          = $Window.FindName("chkVC")
$chkBluebeam    = $Window.FindName("chkBluebeam")
$cmbBluebeamSource = $Window.FindName("cmbBluebeamSource")
$chkDebloat     = $Window.FindName("chkDebloat")
$chkOffice      = $Window.FindName("chkOffice")
$radUpdateDefault = $Window.FindName("radUpdateDefault")
$radUpdateDelay = $Window.FindName("radUpdateDelay")
$chkRename      = $Window.FindName("chkRename")

# 
# Block 3: UTILITY & UI FUNCTIONS
# 

# helper function to prevent the GUI from freezing during heavy installs
function Sync-UI {
    $dispatcher = [System.Windows.Threading.Dispatcher]::CurrentDispatcher
    $dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)
}

# logging in the black text box at the bottom of the GUI
function Write-Log {
    param(
        [string]$Message, 
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message`r`n"
    
    $txtLog.AppendText($LogEntry)
    $txtLog.ScrollToEnd() # scrolls to newest line in log
    Sync-UI
}

# the progress bar (0 to 100)
function Upd8-Prog {
    param([int]$Value)
    $pbStatus.Value = $Value
    Sync-UI
}

# changes power settings to prevent sleeping during onboarding, it'll turn back to defaults once the script or the onboarding process finishes
function Manage-SleepSettings {
    param([switch]$DisableSleep)
    
    if ($DisableSleep) {
        Write-Log "Disabling sleep/standby mode to prevent interruptions..."
        # sets AC power standby timeout to 0 (Never)
        Start-Process -FilePath "powercfg.exe" -ArgumentList "/x -standby-timeout-ac 0" -NoNewWindow -Wait
    } else {
        Write-Log "Reverting sleep/standby mode to Windows defaults..."
        # reverts AC power standby timeout to default (15 min)
        Start-Process -FilePath "powercfg.exe" -ArgumentList "/x -standby-timeout-ac 15" -NoNewWindow -Wait
    }
}

# grabs logged-in user details to pre-fill the renaming text boxes
function Get-UserDetails {
    Write-Log "Querying Active Directory for logged-in user details..."
    try {
        # gets the currently logged-in domain user
        $LoggedInUser = (Get-CimInstance Win32_ComputerSystem).UserName
        $SamAccountName = $LoggedInUser.Split('\')[-1]
        
        # query Active Directory (will fail if machine is not joined to a domain)
        $Searcher = New-Object System.DirectoryServices.DirectorySearcher
        $Searcher.Filter = "(&(objectCategory=person)(objectClass=user)(sAMAccountName=$SamAccountName))"
        $Result = $Searcher.FindOne()
        
        if ($null -ne $Result) {
            $txtFirstName.Text = $Result.Properties["givenname"][0]
            
            # get the surname which contains both Middle and Last name
            $RawSurname = $Result.Properties["sn"][0].ToString().Trim()
            
            # If there's a space, split the first word into Middle Name, and the rest into Last Name
            if ($RawSurname -match "\s") {
                $NameParts = $RawSurname -split "\s+", 2
                $txtMiddleName.Text = $NameParts[0]
                $txtLastName.Text = $NameParts[1]
            } else {
                $txtMiddleName.Text = ""
                $txtLastName.Text = $RawSurname
            }
            
            Write-Log "Successfully pulled AD names: $($txtFirstName.Text) $($txtMiddleName.Text) $($txtLastName.Text)" "SUCCESS"
        } else {
            Write-Log "User $SamAccountName not found in AD. Defaulting to manual entry." "WARN"
            $txtFirstName.Text = $SamAccountName
            $txtLastName.Text = "User"
        }
    } catch {
        Write-Log "Failed to query AD: $($_.Exception.Message). Please enter names manually." "WARN"
    }
}

function Update-Preview {  # this generates a preview of the PC name as the admin types
    $f = $txtFirstName.Text.Trim()
    $m = $txtMiddleName.Text.Trim()
    $l = $txtLastName.Text.Trim()
    
    # combine Middle + Last, then replace any spaces or hyphens with a single hyphen
    $combinedLast = "$m $l".Trim() -replace '[\s\-]+', '-'
    
    if ([string]::IsNullOrWhiteSpace($f) -or [string]::IsNullOrWhiteSpace($combinedLast)) {
        $txtPreviewPCName.Text = "WAITING FOR INPUT..."
        return
    }

    # get only the first initial of the First Name
    $fi = $f.Substring(0,1)
    
    $ideal = "$fi$combinedLast`PC".ToUpper()
    
    # Enforce NetBIOS 15-character limit dynamically (if they have like 2 or 3 lastnames just in case (most likely won't happen) ) pulled from stackoverflow to account for middle names
    if ($ideal.Length -gt 15) {
        $reserved = 3 # 1 char for First Initial, 2 chars for "PC"
        $avail = 15 - $reserved
        
        # Substring the combined last name and trim hyphens
        $truncatedLast = $combinedLast.Substring(0, $avail).TrimEnd('-')
        $txtPreviewPCName.Text = "$fi$truncatedLast`PC".ToUpper()
    } else {
        $txtPreviewPCName.Text = $ideal
    }
}
 
# Block 4:APPLICATION & TWEAK FUNCTIONS

#--------------------- below are the easiest/straightforward apps to implement ---------------------#
function Install-Chrome {
    Write-Log "Downloading and installing Google Chrome from Web..."
    try {
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        
        # winget returns 0 for success, or -1978335189 if it's already installed
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) { 
            Write-Log "Google Chrome installed successfully." "SUCCESS"
            
            # pulls up a screen to show the IT guy can set chrome as the default web browser
            Write-Log "Opening Default Apps settings for Chrome..."
            [System.Windows.MessageBox]::Show("Chrome installation complete. You can set Chrome as the default browser in the settings window that is about to open.", "Set Default Browser", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
            Start-Process "ms-settings:defaultapps?registeredAppMachine=Google%20Chrome"

        } else {
            Write-Log "Chrome installation returned exit code $($proc.ExitCode)." "WARN"
        }
    } catch {
        Write-Log "Failed to install Google Chrome: $($_.Exception.Message)" "ERROR"
    }
}

function Install-GoogleDrive {
    Write-Log "Downloading and installing Google Drive from Web..."
    try {
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Google.Drive --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) {
            Write-Log "Google Drive installed successfully." "SUCCESS"
        } else {
            Write-Log "Google Drive installation returned exit code $($proc.ExitCode)." "WARN"
        }
    } catch {
        Write-Log "Failed to install Google Drive: $($_.Exception.Message)" "ERROR"
    }
}

function Install-AdobeAcrobat {
    Write-Log "Downloading and installing Adobe Acrobat Reader from Web..."
    # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING 
    # $AdobePath = "\\DOMAIN.IP\NinjaProvApps\AdobeAcrobat\acroread.msi"
    # if (-not (Test-Path $AdobePath)) { return }
    # $AdobeArgs = "/i `"$AdobePath`" /qn /norestart EULA_ACCEPT=YES"
    # $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $AdobeArgs -Wait -PassThru
    
    try {
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Adobe.Acrobat.Reader.64-bit --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) {
            Write-Log "Adobe Acrobat Reader installed successfully." "SUCCESS"
        } else {
            Write-Log "Adobe Acrobat Reader installation failed (exit code $($proc.ExitCode))." "ERROR"
        }
    } catch {
        Write-Log "ERROR: Failed to install Adobe Acrobat Reader: $($_.Exception.Message)" "ERROR"
    }
}

#--------------------- below are prereqs ---------------------#
function Install-ODBC {
    param([string]$Source)
    Write-Log "Installing Microsoft ODBC Driver... (Source: $Source)"
    try {
        # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING 
        # $Args = '/i "\\DOMAIN.IP.ADDRESS\NinjaProvApps\VistaClient\msodbcsql.msi" /qn /norestart IACCEPTMSODBCSQLLICENSETERMS=YES'
        # $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $Args -Wait -PassThru
        
        # Enforcing Web installation for public script
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Microsoft.msodbcsql.17 --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        
        if ($proc.ExitCode -in @(0, 3010, -1978335189)) { 
            Write-Log "Microsoft ODBC Driver installed successfully." "SUCCESS" 
        } else { 
            Write-Log "ODBC Driver installation returned exit code $($proc.ExitCode)." "WARN" 
        }
    } catch {
        Write-Log "Failed to install ODBC Driver: $($_.Exception.Message)" "ERROR"
    }
}

function Install-NetFramework {
    param([string]$Source)
    Write-Log "Installing .NET Framework 4.8... (Source: $Source)"
    try {
        # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING 
        # $Args = '/q /norestart'
        # $proc = Start-Process -FilePath "\\DOMAIN.IP.ADDRESS\NinjaProvApps\VistaClient\ndp48-x86-x64-allos-enu.exe" -ArgumentList $Args -Wait -PassThru
        
        
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Microsoft.DotNet.Framework.DeveloperPack_4.8 --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        
        if ($proc.ExitCode -in @(0, 3010, -1978335189)) { Write-Log ".NET Framework 4.8 installed successfully." "SUCCESS" } 
        else { Write-Log ".NET Framework installation returned exit code $($proc.ExitCode)." "WARN" }
    } catch { Write-Log "Failed to install .NET Framework: $($_.Exception.Message)" "ERROR" }
}

function Install-SAPReports {
    Write-Log "Installing SAP Crystal Reports..."
    try {
        # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING
        # $Args = '/i "\\DOMAIN.IP.ADDRESS\NinjaProvApps\SAP\CRRuntime_64bit_13_0_25.msi" /qn /norestart'
        # $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $Args -Wait -PassThru
        
        # SAP Crystal reports is often proprietary and requires a direct download link from the company that distributes it aka Vista
        Write-Log "SAP Crystal Reports is usually downloaded with a link from the BI company that distributes their software (so it's not available in my public ver.)" "WARN"
       
        
    } catch { Write-Log "Failed to install SAP Crystal Reports: $($_.Exception.Message)" "ERROR" }
}

function Install-VCRedist {
    param([string]$Source)
    Write-Log "Installing VC++ Redistributable... (Source: $Source)"
    try {
        # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING 
        # $Args = '/install /quiet /norestart'
        # $proc = Start-Process -FilePath "\\DOMAIN.IP.ADDRESS\NinjaProvApps\Bluebeam\vc_redist.x64.exe" -ArgumentList $Args -Wait -PassThru 
        
        
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Microsoft.VCRedist.2015+.x64 --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        
        if ($proc.ExitCode -in @(0, 3010, -1978335189)) { Write-Log "VC++ Redistributable installed successfully." "SUCCESS" } 
        else { Write-Log "VC++ Redistributable installation returned exit code $($proc.ExitCode)." "WARN" }
    } catch { Write-Log "Failed to install VC++ Redistributable: $($_.Exception.Message)" "ERROR" }
}

#--------------------- below are bluebeam+vista ---------------------#
function Install-Bluebeam {
    param([string]$Source)
    Write-Log "Starting Bluebeam Revu Installation from Web..."

    try {
        $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install -e --id Bluebeam.Revu.21 --accept-source-agreements --accept-package-agreements --silent" -Wait -PassThru -NoNewWindow
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq -1978335189) { Write-Log "Bluebeam Revu installed successfully from Web." "SUCCESS" }
        else { Write-Log "Bluebeam Web installation returned exit code $($proc.ExitCode)." "WARN" }
    } catch { 
        Write-Log "Failed to install Bluebeam from Web: $($_.Exception.Message)" "ERROR" 
    }

    # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING
    <# 
    $LocalTemp = "C:\Windows\Temp\Ninja Deploy\Bluebeam"
    $NetworkPath = "\\DOMAIN.IP.ADDRESS\NinjaProvApps\Bluebeam"
    
    try {
        if (-not (Test-Path $LocalTemp)) { New-Item -ItemType Directory -Path $LocalTemp -Force | Out-Null }
        Copy-Item -Path "$NetworkPath\*" -Destination $LocalTemp -Recurse -Force
        
        $vcProc = Start-Process -FilePath "$LocalTemp\vc_redist.x64.exe" -ArgumentList "/install /quiet /norestart" -Wait -PassThru
        
        $msiArgs = '/i "' + $LocalTemp + '\Bluebeam Revu x64 21.msi" /qn /norestart'
        $bbProc = Start-Process -FilePath "msiexec.exe" -ArgumentList $msiArgs -Wait -PassThru
    } catch {
        Write-Log "ERROR: Failed to install Bluebeam: $($_.Exception.Message)" "ERROR"
    } finally {
        Remove-Item -Path "C:\Windows\Temp\Ninja Deploy" -Recurse -Force -ErrorAction SilentlyContinue
    }
    #>
}

function Install-Vista {
    Write-Log "Starting Viewpoint Vista Installation..."
    
    # OLD DC LOGIC COMMENTED OUT FOR PUBLIC HOSTING
    <# 
    $NetworkPath = "\\DOMAIN.IP.ADDRESS\NinjaProvApps\VistaClient"
    $LocalTemp = "C:\Windows\Temp\VistaDeploy"
    try {
        if (-not (Test-Path $LocalTemp)) { New-Item -ItemType Directory -Path $LocalTemp -Force | Out-Null }
        Copy-Item -Path "$NetworkPath\*" -Destination $LocalTemp -Recurse -Force
        
        # ... Installation of bundled MSI's ... 
        $VistaArgs = '/i "' + $LocalTemp + '\VistaClient.26.3.1.7.msi" /qn /norestart ALLUSERS=1 /lv "C:\Windows\Temp\Vista_Install.log"'
        $vistaProc = Start-Process -FilePath "msiexec.exe" -ArgumentList $VistaArgs -Wait -PassThru
    } catch { } finally { Remove-Item -Path $LocalTemp -Recurse -Force -ErrorAction SilentlyContinue }
    #>


    Write-Log "Viewpoint Vista is usually downloaded with a link from the BI company that distributes their software (so it's not available in my public ver.)" "WARN"
}

#--------------------- below is the debloat script ---------------------# 
function Invoke-Debloat {
    Write-Log "Starting Windows 11 Debloat..."
    
    $app_packages = @(
        "Microsoft.WindowsCamera", "Clipchamp.Clipchamp", "Microsoft.WindowsAlarms",
        "Microsoft.WindowsFeedbackHub", "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsMaps", "Microsoft.ZuneMusic", "Microsoft.BingNews",
        "Microsoft.Todos", "Microsoft.ZuneVideo", "Microsoft.MicrosoftOfficeHub",
        "Microsoft.People", "Microsoft.PowerAutomateDesktop", "MicrosoftCorporationII.QuickAssist",
        "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsSoundRecorder",
        "Microsoft.BingWeather", "Microsoft.Xbox.TCUI", "Microsoft.GamingApp",
        "Microsoft.BingSearch", "Microsoft.Windows.Ai.Copilot.Provider",
        "Microsoft.Windows.Copilot", "Microsoft.Copilot"
    )

    Write-Log "Suspending Microsoft Store auto-updates to prevent script from hanging..." #just in case
    $StoreRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
    if (-not (Test-Path $StoreRegPath)) { New-Item -Path $StoreRegPath -Force | Out-Null }
    Set-ItemProperty -Path $StoreRegPath -Name "AutoDownload" -Value 2 -Type DWord -Force

    Stop-Process -Name "WinStore.App", "InstallAgent" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5
    Write-Log "AppX engine is unlocked. Proceeding with bloatware removal..."

    # prov packages
    Write-Log "--- Removing Provisioned Packages ---"
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -in $app_packages } | ForEach-Object {
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction Stop
            Write-Log "[SUCCESS] Removed provisioned: $($_.DisplayName)" "SUCCESS"
        } catch {
            Write-Log "[ERROR] Couldn't remove provisioned $($_.DisplayName): $($_.Exception.Message)" "ERROR"
        }
    }

    # installed packages
    Write-Log "--- Removing Installed AppX Packages ---"
    foreach ($App in $app_packages) {
        $foundPackages = Get-AppxPackage -AllUsers -Name $App -ErrorAction SilentlyContinue
        if (-not $foundPackages) {
            Write-Log "[-] Skipped: $App (Not currently installed)"
            continue
        }
        $foundPackages | ForEach-Object {
            try {
                Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction Stop
                Write-Log "[SUCCESS] Removed: $($_.Name)" "SUCCESS"
            } catch {
                Write-Log "[ERROR] Failed to remove $($_.Name): $($_.Exception.Message)" "ERROR"
            }
        }
    }

    # McAfee removal attempt by looking for any Win32 products with "McAfee" in the name and uninstalling them
    Write-Log "--- Removing McAfee ---"
    $mcafeeApps = Get-CimInstance -Class Win32_Product -Filter "Name LIKE '%McAfee%'" -ErrorAction SilentlyContinue
    if ($mcafeeApps) {
        foreach ($app in $mcafeeApps) {
            Write-Log "Attempting to uninstall: $($app.Name)..." "WARN"
            try {
                Invoke-CimMethod -InputObject $app -MethodName Uninstall | Out-Null
                Write-Log "[SUCCESS] Successfully uninstalled $($app.Name)" "SUCCESS"
            } catch {
                Write-Log "[ERROR] Could not uninstall $($app.Name): $($_.Exception.Message)" "ERROR"
            }
        }
    } else {
        Write-Log "[-] Skipped: No McAfee Win32 products found on this system."
    }

    # diable the disGUSTING Copilot
    Write-Log "--- Disabling Copilot via Policy ---"
    $copilotRegPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
    )
    foreach ($path in $copilotRegPaths) {
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    }
    Set-ItemProperty -Path $copilotRegPaths[0] -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $copilotRegPaths[1] -Name "RemoveMicrosoftCopilotApp" -Value 1 -Type DWord -Force
    Write-Log "[SUCCESS] Copilot disabled and blocked via Local Group Policy registry keys." "SUCCESS"

    # disable OneDrive Setup
    Write-Log "--- Configuring OneDrive prevention ---"
    $OneDrivePath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\Disable OneDrive"
    if (-not (Test-Path $OneDrivePath)) { New-Item -Path $OneDrivePath -Force | Out-Null }
    New-ItemProperty -Path $OneDrivePath -Name "StubPath" -Value 'REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f' -PropertyType String -Force | Out-Null
    Write-Log "[SUCCESS] OneDrive setup disabled via Active Setup (you can reinstall one-drive if you please)" "SUCCESS"

    # cleanup
    Write-Log "Debloat complete. Re-enabling Microsoft Store auto-updates..."
    Set-ItemProperty -Path $StoreRegPath -Name "AutoDownload" -Value 4 -Type DWord -Force
}

#--------------------- below is the office cleanup + installation script ---------------------# 
function Install-OfficeLTSC {
    Write-Log "Starting Office cleanup and installation process..."
    
    #Office's installation below won't work out of the box since it relies on JMW's custom XML configuration to install
    # The code is left the same, but it just won't execute
    
    $LocalTemp = "C:\Windows\Temp\NinjaDeploy"
    $NetworkPath = "\\DOMAIN.IP.ADDRESS\NinjaProvApps\Office" 
    
    Write-Log "Getting rid of old files..."
    Remove-Item -Path $LocalTemp -Recurse -Force -ErrorAction SilentlyContinue
    
    New-Item -ItemType Directory -Path $LocalTemp -Force | Out-Null
    
    Write-Log "Copying Office files locally..."
    try {
        Copy-Item -Path "$NetworkPath\*" -Destination $LocalTemp -Recurse -Force -ErrorAction Stop
        Write-Log "Copy completed successfully."
    } catch {
        Write-Log "CRITICAL: Failed to copy files from server. Reason: $($_.Exception.Message)" "ERROR"
        return # exits this function early without crashing the whole GUI
    }
    
    # cleanup phase
    $CleanScript = "$LocalTemp\Clean office.ps1"
    if (Test-Path $CleanScript) {
        try {
            Write-Log "Running Office cleanup..."
            $proc = Start-Process -FilePath "PowerShell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$CleanScript`"" -Wait -PassThru
            Write-Log "Cleanup exited with code $($proc.ExitCode)"
            
            # wait for any legacy processes to clear
            $timeout = [DateTime]::Now.AddSeconds(120)
            while ([DateTime]::Now -lt $timeout) {
                $running = Get-Process -Name @("setup","msiexec") -ErrorAction SilentlyContinue
                if (-not $running) { break }
                Write-Log "Waiting for setup processes to clear before installing..."
                Start-Sleep -Seconds 5
            }
        } catch {
            Write-Log "Cleanup failed: $($_.Exception.Message)" "ERROR"
            return
        }
    } else {
        Write-Log "Clean office.ps1 not found in $LocalTemp. Skipping cleanup phase..." "WARN"
    }
    
    try {
        Write-Log "Starting Office LTSC 2024 install..."
        
        $SetupArgs = '/configure "' + $LocalTemp + '\Configuration3.14.2025.xml"'
        
        # Execution is commented out because it depends on custom XML
        # $proc = Start-Process -FilePath "$LocalTemp\setup.exe" -ArgumentList $SetupArgs -WorkingDirectory $LocalTemp -Wait -PassThru
        # Write-Log "setup.exe exited with code $($proc.ExitCode)"
        
        # if ($proc.ExitCode -notin @(0, 3010)) {
        #     Write-Log "Office installation failed (Exit Code: $($proc.ExitCode))" "ERROR"
        # } else {
        #     Write-Log "Office installation completed successfully." "SUCCESS"
        # }
        
        Write-Log "Skipped Execution: Custom configuration XML is required." "WARN"

    } catch {
        Write-Log "Failed to install office: $($_.Exception.Message)" "ERROR"
    } finally {
        Write-Log "Removing local staging files..."
        Remove-Item -Path $LocalTemp -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Office cleanup and installation complete."
    }
}

#--------------------- below is the windows updates config script ---------------------# 
function Set-WindowsUpd8s {
    param([string]$Mode)
    
    $WUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    
    # ensure the base registry path exists
    if (-not (Test-Path $WUPath)) {
        New-Item -Path $WUPath -Force | Out-Null
    }

    if ($Mode -eq "Delay") {
        Write-Log "Applying Windows Update delays (Features: 365 days, Security: 4 days, No Drivers)..."
        try {
            # Prevent Windows from installing drivers 
            Set-ItemProperty -Path $WUPath -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord -Force
            
            # Defer Feature Updates by 365 days 
            Set-ItemProperty -Path $WUPath -Name "DeferFeatureUpd8s" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $WUPath -Name "DeferFeatureUpd8sPeriodInDays" -Value 365 -Type DWord -Force
            
            # Defer Quality (Security) Updates by 4 days 
            Set-ItemProperty -Path $WUPath -Name "DeferQualityUpd8s" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $WUPath -Name "DeferQualityUpd8sPeriodInDays" -Value 4 -Type DWord -Force
            
            Write-Log "Windows Update policies applied successfully." "SUCCESS"
        } catch {
            Write-Log "Failed to apply Windows Update delays: $($_.Exception.Message)" "ERROR"
        }
    } 
    else {
        Write-Log "Setting Windows Updates to Default (No modifications)..."
        try {
            # Remove the specific delay keys to revert to default behavior
            $keysToRemove = @(
                "ExcludeWUDriversInQualityUpdate", 
                "DeferFeatureUpd8s", 
                "DeferFeatureUpd8sPeriodInDays", 
                "DeferQualityUpd8s", 
                "DeferQualityUpd8sPeriodInDays"
            )
            foreach ($key in $keysToRemove) {
                Remove-ItemProperty -Path $WUPath -Name $key -ErrorAction SilentlyContinue
            }
            Write-Log "Windows Updates reverted to standard default." "SUCCESS"
        } catch {
            Write-Log "Failed to revert Windows Update policies: $($_.Exception.Message)" "ERROR"
        }
    }
}

#--------------------- below renames the computer ---------------------# 
function Rename-PC {
    Write-Log "Starting PC Rename process..."
    
    #gets name from the preview
    $NewPCName = $txtPreviewPCName.Text
    
    if ($NewPCName -eq "WAITING FOR INPUT...") {
        Write-Log "First Name or Last Name field is empty. Cannot rename PC." "ERROR"
        return
    }

    $CurrentName = $env:COMPUTERNAME
    Write-Log "Current PC name: $CurrentName"
    Write-Log "Target PC name:  $NewPCName"

    if ($CurrentName -ieq $NewPCName) {
        Write-Log "Computer already has correct name." "SUCCESS"
    } else {
        try {
            Rename-Computer -NewName $NewPCName -Force -ErrorAction Stop
            Write-Log "Computer rename command completed successfully. (Requires Reboot)" "SUCCESS"
        } catch {
            Write-Log "Rename failed: $($_.Exception.Message)" "ERROR"
        }
    }
}

# 
# Block 5: EXECUTION TRIGGERS (Button Clicks)
# 

# CUSTOM BUTTON LOGIC
$btnRunCustom.Add_Click({
    
    # show the list of selected scripts
    $ActionList = [System.Collections.Generic.List[string]]::new()
    
    if ($chkChrome.IsChecked) { $ActionList.Add("- Google Chrome") }
    if ($chkDrive.IsChecked) { $ActionList.Add("- Google Drive") }
    if ($chkAdobe.IsChecked) { $ActionList.Add("- Adobe Acrobat Reader") }
    if ($chkVC.IsChecked) { $ActionList.Add("- VC++ Redistributable") }
    if ($chkODBC.IsChecked) { $ActionList.Add("- Microsoft ODBC Driver for SQL Server") }
    if ($chkNet.IsChecked) { $ActionList.Add("- .NET Framework 4.8") }
    if ($chkCrystal.IsChecked) { $ActionList.Add("- SAP Crystal Reports") }
    if ($chkBluebeam.IsChecked) { $ActionList.Add("- Bluebeam Revu") }
    if ($chkVista.IsChecked) { $ActionList.Add("- Viewpoint Vista") }
    if ($chkDebloat.IsChecked) { $ActionList.Add("- Windows 11 Debloater") }
    if ($chkOffice.IsChecked) { $ActionList.Add("- Office LTSC 2024") }
    
    if ($radUpdateDelay.IsChecked) { $ActionList.Add("- Delay Windows Updates (Features/Security)") }
    else { $ActionList.Add("- Default Windows Updates") }
    
    if ($chkRename.IsChecked) { $ActionList.Add("- Rename PC") }
    
    # if nothing was selected
    if ($ActionList.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Please select at least one option before running.", "No Selection", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }

    # popup too confirm
    $Message = "You're about to run the following scripts:`n`n" + ($ActionList -join "`n") + "`n`nDo you want to proceed?"
    $Confirm = [System.Windows.MessageBox]::Show($Message, "Confirm Custom Execution", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    
    if ($Confirm -ne 'Yes') { return } # stops if user selects No
    
    # proceed
    $btnRunCustom.IsEnabled = $false 
    $btnRunPreset.IsEnabled = $false
    
    Write-Log "Starting Custom Onboarding Execution..."
    Manage-SleepSettings -DisableSleep
    Upd8-Prog -Value 10

    if ($chkChrome.IsChecked) { Install-Chrome }
    if ($chkDrive.IsChecked) { Install-GoogleDrive }
    if ($chkAdobe.IsChecked) { Install-AdobeAcrobat }
    
    $PrereqSource = $cmbPrereqSource.Text
    
    if ($chkVC.IsChecked) { Install-VCRedist -Source $PrereqSource }
    if ($chkODBC.IsChecked) { Install-ODBC -Source $PrereqSource }
    if ($chkNet.IsChecked) { Install-NetFramework -Source $PrereqSource }
    if ($chkCrystal.IsChecked) { Install-SAPReports } 

    if ($chkBluebeam.IsChecked) { 
        $BbSource = $cmbBluebeamSource.Text
        Install-Bluebeam -Source $BbSource 
    }
    
    if ($chkVista.IsChecked) { Install-Vista }
    if ($chkDebloat.IsChecked) { Invoke-Debloat }
    if ($chkOffice.IsChecked) { Install-OfficeLTSC }
    
    if ($radUpdateDelay.IsChecked) { Set-WindowsUpd8s -Mode "Delay" } 
    else { Set-WindowsUpd8s -Mode "Default" }
    
    if ($chkRename.IsChecked) { Rename-PC }
    
    Upd8-Prog -Value 100
    Manage-SleepSettings 
    Write-Log "Custom Onboarding Complete!" "SUCCESS"
    
    $btnRunCustom.IsEnabled = $true
    $btnRunPreset.IsEnabled = $true
})

# PRESET BUTTON LOGIC
$btnRunPreset.Add_Click({
    
    # shows everythign that'll run in the preset
    $PresetList = @"
You're about to run the following scripts:

- Windows 11 Debloater
- Google Drive
- SAP Crystal Reports
- VC++ Redistributable
- Microsoft ODBC Driver
- .NET Framework 4.8
- Viewpoint Vista
- Adobe Acrobat Reader
- Bluebeam Revu
- Office LTSC 2024
- Google Chrome
- Rename PC

Do you want to proceed?
"@
    $Confirm = [System.Windows.MessageBox]::Show($PresetList, "Confirm Preset Execution", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    
    if ($Confirm -ne 'Yes') { return } # same thing, stops if no is selected

    # proceed with the rest of the script
    $btnRunCustom.IsEnabled = $false
    $btnRunPreset.IsEnabled = $false
    
    Write-Log "Starting PRESET Onboarding Execution..." 
    Manage-SleepSettings -DisableSleep
    Upd8-Prog -Value 5

    Invoke-Debloat
    Upd8-Prog -Value 15

    Install-GoogleDrive
    Upd8-Prog -Value 20
    
    Install-SAPReports
    Upd8-Prog -Value 30
    
    Install-VCRedist -Source "Web (Latest)"
    Install-ODBC -Source "Web (Latest)"
    Install-NetFramework -Source "Web (Latest)"
    Install-Vista -Source "Web (Latest)"
    Upd8-Prog -Value 50
    
    Install-AdobeAcrobat
    Upd8-Prog -Value 60
    
    Install-Bluebeam -Source "Web (Latest)"
    Upd8-Prog -Value 75
    
    Install-OfficeLTSC
    Upd8-Prog -Value 90

    Install-Chrome
    Set-WindowsUpd8s -Mode "Default"
    Rename-PC
    
    Upd8-Prog -Value 100
    Manage-SleepSettings 
    Write-Log "Preset Onboarding Complete!" "SUCCESS"
    
    $btnRunCustom.IsEnabled = $true
    $btnRunPreset.IsEnabled = $true
})

# 
# Block 6: INITIALIZATION & LAUNCH
#

# update the rename preview in real-time when typing
$txtFirstName.Add_TextChanged({ Update-Preview })
$txtMiddleName.Add_TextChanged({ Update-Preview })
$txtLastName.Add_TextChanged({ Update-Preview })

# run the startup functions before showing the window
Get-UserDetails

# the GUI
$Window.ShowDialog() | Out-Null
