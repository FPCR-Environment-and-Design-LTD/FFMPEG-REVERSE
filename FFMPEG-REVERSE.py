import tkinter as tk
from tkinter import filedialog, messagebox
import os
import subprocess

# Function to browse and select input video file
def browse_input_file():
    filename = filedialog.askopenfilename(filetypes=[("Video Files", "*.mp4;*.avi;*.mkv;*.mov"), ("All files", "*.*")])
    if filename:
        input_entry.delete(0, tk.END)
        input_entry.insert(0, filename)

# Function to browse and select output directory
def browse_output_directory():
    directory = filedialog.askdirectory()
    if directory:
        output_entry.delete(0, tk.END)
        output_entry.insert(0, directory)

# Function to reverse the video using ffmpeg
def reverse_video():
    input_file = input_entry.get()
    output_dir = output_entry.get()

    if not os.path.isfile(input_file):
        messagebox.showerror("Error", "Please select a valid video file.")
        return

    if not os.path.isdir(output_dir):
        messagebox.showerror("Error", "Please select a valid output folder.")
        return

    # Construct output file path
    output_file = os.path.join(output_dir, f"{os.path.splitext(os.path.basename(input_file))[0]}_reversed.mp4")

    # Get ffmpeg executable path
    ffmpeg_path = os.path.join(os.getcwd(), "ffmpeg.exe")

    if not os.path.isfile(ffmpeg_path):
        messagebox.showerror("Error", f"FFmpeg not found at: {ffmpeg_path}")
        return

    # Prepare arguments for FFmpeg command
    arguments = ["-i", input_file, "-vf", "reverse", "-af", "areverse", output_file]

    # Display the command for debugging
    command_str = f"FFmpeg Path: {ffmpeg_path}\nArguments: {' '.join(arguments)}"
    print(command_str)  # Print to console instead of message box for debugging

    # Execute FFmpeg with subprocess
    try:
        subprocess.run([ffmpeg_path] + arguments, check=True)
        messagebox.showinfo("Success", "Video reversed successfully!")
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"An error occurred: {e}")

# Create main application window
app = tk.Tk()
app.title("Video Reverser")
app.geometry("400x300")  # Increased height to accommodate more widgets
app.resizable(False, False)

# Input File Section
input_label = tk.Label(app, text="Select Video File:")
input_label.pack(pady=10)

input_entry = tk.Entry(app, width=50)
input_entry.pack(pady=5)

input_button = tk.Button(app, text="Browse", command=browse_input_file)
input_button.pack(pady=5)  # Added padding for better layout

# Output Directory Section
output_label = tk.Label(app, text="Select Output Folder:")
output_label.pack(pady=10)

output_entry = tk.Entry(app, width=50)
output_entry.pack(pady=5)

output_button = tk.Button(app, text="Browse", command=browse_output_directory)
output_button.pack(pady=5)  # Added padding for better layout

# Reverse Video Button
reverse_button = tk.Button(app, text="Reverse Video", command=reverse_video)
reverse_button.pack(pady=20)  # Make sure there's enough padding

# Run the application
app.mainloop()
