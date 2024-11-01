# PowerShell script to open all urls in the workspace.txt file + desired apps
# Riley Taylor 2024



# path should be injected by some ini or config or pipeline setup for a real application
#chrome_path
#outlook_path
#slack_path

#where/how do you properly inject these paths?


########################################################################################

#start chrome + tabs, new window based on self inserted ';' delimiter (no delimiter at start, only needed at the end.):

#contains debug information in $window_count and some $Write-Host

# Define path to workspace file
$path = "C:\Users\RileyTaylor\Desktop"
Set-Location $path
$urls = Get-Content workspace.txt

# Initialize an empty array to hold URLs for each window
$currentUrls = @()
$window_count = 0

foreach ($url in $urls) {
    if ($url -eq ";") {
        # Only proceed if $currentUrls has valid URLs
        if ($currentUrls.Count -gt 0) {
            $window_count += 1
            Write-Host "Found ';'. This is window number: $window_count"
            
            # Filter out any null, empty, or whitespace-only strings (the second one is a regular expression to mean it has at least one non-white space character)
            #So this check pipe Where-Object approach checks each url to make sure it isn't null and has at least one non-whitespace character
            $currentUrls = $currentUrls | Where-Object { ($_ -ne $null) -and ($_ -match '\S') }
            $arguments = @("--new-window") + $currentUrls
            
            # Debug output to verify arguments are correct
            Write-Host "Opening Chrome with arguments:" $arguments
            
            # Only execute if arguments contain valid URLs
            if ($arguments.Count -gt 1) {
                Start-Process -FilePath "chrome.exe" -ArgumentList $arguments
            } else {
                Write-Host "No valid URLs found to open in this window."
            }

            $currentUrls.Clear() # Clear list for the next window
        }
    } else {
        # Add only non-empty, trimmed URLs to the list
        $url = $url.Trim() # Remove any surrounding whitespace
        if ($url -ne "") { $currentUrls += $url }
    }
}

# Open any remaining URLs if no trailing delimiter
if ($currentUrls.Count -gt 0) {
    $window_count += 1
    Write-Host "Opening final window, number: $window_count"
    
    # Filter out any null, empty, or whitespace-only strings (the second one is a regular expression to mean it has at least one non-white space character)
    #So this check pipe Where-Object approach checks each url to make sure it isn't null and has at least one non-whitespace character
    $currentUrls = $currentUrls | Where-Object { ($_ -ne $null) -and ($_ -match '\S') }
    $arguments = @("--new-window") + $currentUrls
    
    # Debug output for the final window
    Write-Host "Opening Chrome with arguments:" $arguments
    
    if ($arguments.Count -gt 1) {
        Start-Process -FilePath "chrome.exe" -ArgumentList $arguments
    } else {
        Write-Host "No valid URLs found to open in the final window."
    }
}




########################################################################################

#start Outlook
Start-Process -FilePath "OUTLOOK.EXE" -WorkingDirectory "C:\Program Files\Microsoft Office\root\Office16"


########################################################################################

#Teams and ToDo are "Windows Apps" so they are super janky to work with - not a basic .exe:
#See here for how to reference: https://answers.microsoft.com/en-us/windows/forum/windows_10-windows_store/starting-windows-10-store-app-from-the-command/836354c5-b5af-4d6c-b414-80e40ed14675?page=2


#start ToDo
$AppName="ToDo" #Place the name of the App in the quotes. For example: ToDo, Camera, etc...
$Path="shell:appsfolder\"+(Get-AppXPackage | where{$_.Name -match "$AppName"} | select -expandproperty packagefamilyname)+"!App"
Start-Process $Path


########################################################################################

#start Teams
$teamsURI = "msteams://"
Start-Process $teamsURI


########################################################################################

#start Slack
Start-Process -FilePath "slack.exe" -WorkingDirectory "C:\Users\RileyTaylor\AppData\Local\slack"
