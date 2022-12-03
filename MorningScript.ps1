#Try block for Error Handling
try
{
    # While Loop up until user input is 5
    while ($UserInput -ne 5)
    {
        #List of Options displayed to user
        Write-Host "
        1. Creates DailyLog.txt of files with .log extention
        2. Sorted Files in Alphabetical order into SortedFiles.txt
        3. Current CPU and Memory Usage
        4. Running Processes listed by virtual size
        5. Exit the script"
    
        #Asks user to pick an option
        Write-Host "Choose an option (1-5):"
        $UserInput = Read-Host

        # Different options selected by user w/ Switch statements
        switch($UserInput)
        {
            1 { 
                # When user chooses option 1
                Write-Host "Creating DailyLog.txt"
                "TIMESTAMP: " + (Get-Date) | Out-File -Filepath $PSScriptRoot\DailyLog.txt -Append
                Get-ChildItem -Path $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append 
            }
    
            2 { 
                # When user chooses option 2
                Write-Host "Creating SortedFiles.txt"
                Get-ChildItem "$PSScriptRoot" | Sort-Object Name | Format-Table -AutoSize -Wrap |
                Out-File -FilePath "$PSScriptRoot\SortedFiles.txt" 
            }

            3 { 
                #When user chooses option 3
                Write-Host "Gathering CPU and Memory Statistics"  
                $CounterList = "\Processor(_Total)\% Processor Time", "\Memory\Committed Bytes"                
                Get-Counter -Counter $CounterList -MaxSamples 4 -SampleInterval 5 
            }
    
            4 { 
                # When user chooses option 4
                Write-Host "Listing Running Processes"
                Get-Process | Select-Object ID, Name, VM | Sort-Object VM | Out-GridView 
            }
    
            5 { 
                #When user chooses option 5 (Exits)
                Write-Host -ForegroundColor Yellow "Now Exiting" 
            }
        }
    }
}
# Catch block for exception handling
catch
{
    Write-Host -ForegroundColor Red "An Error Occured"
}