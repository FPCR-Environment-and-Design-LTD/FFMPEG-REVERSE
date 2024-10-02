Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Video Reverser"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Create Label for Input File
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Text = "Select Video File:"
$inputLabel.Location = New-Object System.Drawing.Point(10, 20)
$inputLabel.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($inputLabel)

# Create TextBox for Input File Path
$inputTextbox = New-Object System.Windows.Forms.TextBox
$inputTextbox.Location = New-Object System.Drawing.Point(120, 20)
$inputTextbox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($inputTextbox)

# Create Button for Selecting Input File
$inputButton = New-Object System.Windows.Forms.Button
$inputButton.Text = "Browse"
$inputButton.Location = New-Object System.Drawing.Point(330, 18)
$inputButton.Size = New-Object System.Drawing.Size(50, 25)
$form.Controls.Add($inputButton)

# Create Label for Output Directory
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = "Select Output Folder:"
$outputLabel.Location = New-Object System.Drawing.Point(10, 60)
$outputLabel.Size = New-Object System.Drawing.Size(110, 20)
$form.Controls.Add($outputLabel)

# Create TextBox for Output Directory Path
$outputTextbox = New-Object System.Windows.Forms.TextBox
$outputTextbox.Location = New-Object System.Drawing.Point(120, 60)
$outputTextbox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($outputTextbox)

# Create Button for Selecting Output Folder
$outputButton = New-Object System.Windows.Forms.Button
$outputButton.Text = "Browse"
$outputButton.Location = New-Object System.Drawing.Point(330, 58)
$outputButton.Size = New-Object System.Drawing.Size(50, 25)
$form.Controls.Add($outputButton)

# Create Reverse Button
$reverseButton = New-Object System.Windows.Forms.Button
$reverseButton.Text = "Reverse Video"
$reverseButton.Location = New-Object System.Drawing.Point(150, 100)
$reverseButton.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($reverseButton)

# Create OpenFileDialog for selecting video file
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.Filter = "Video Files|*.mp4;*.avi;*.mkv;*.mov|All files (*.*)|*.*"

# Create FolderBrowserDialog for selecting output folder
$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog

# Action for Input Browse Button
$inputButton.Add_Click({
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $inputTextbox.Text = $openFileDialog.FileName
    }
})

# Action for Output Browse Button
$outputButton.Add_Click({
    if ($folderBrowserDialog.ShowDialog() -eq 'OK') {
        $outputTextbox.Text = $folderBrowserDialog.SelectedPath
    }
})

# Action for Reverse Video Button
# Action for Reverse Video Button
$reverseButton.Add_Click({
    $inputFile = $inputTextbox.Text
    $outputDir = $outputTextbox.Text
    if (-not (Test-Path $inputFile)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid video file.")
        return
    }
    if (-not (Test-Path $outputDir)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid output folder.")
        return
    }

    # Get ffmpeg.exe location relative to the script
    $ffmpegPath = Join-Path $PSScriptRoot "ffmpeg.exe"
    
    if (-not (Test-Path $ffmpegPath)) {
        [System.Windows.Forms.MessageBox]::Show("FFmpeg not found at: " + $ffmpegPath)
        return
    }

    # Construct output file path
    $outputFile = Join-Path $outputDir ([System.IO.Path]::GetFileNameWithoutExtension($inputFile) + "_reversed.mp4")

    # Prepare arguments for FFmpeg command
    $arguments = "-i `"$inputFile`" -vf reverse -af areverse `"$outputFile`""

    # Display the command for debugging
    [System.Windows.Forms.MessageBox]::Show("FFmpeg Path: " + $ffmpegPath + "`nArguments: " + $arguments)

    # Execute FFmpeg with Start-Process
    try {
        Start-Process -FilePath $ffmpegPath -ArgumentList $arguments -NoNewWindow -Wait
        [System.Windows.Forms.MessageBox]::Show("Video reversed successfully!")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred: " + $_.Exception.Message)
    }
})



# Show the form
$form.ShowDialog()
