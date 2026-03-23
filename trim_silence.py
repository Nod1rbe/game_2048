import subprocess
import sys
import os


# Install required packages
subprocess.check_call([sys.executable, "-m", "pip", "install", "pydub", "imageio-ffmpeg"])



# Set ffmpeg executable path
pydub.AudioSegment.converter = imageio_ffmpeg.get_ffmpeg_exe()

def detect_leading_silence(sound, silence_threshold=-45.0, chunk_size=5):
    trim_ms = 0
    while sound[trim_ms:trim_ms+chunk_size].dBFS < silence_threshold and trim_ms < len(sound):
        trim_ms += chunk_size
    return trim_ms

dir_path = r"c:\Project\game_2048\assets\audio"
files = ["merge1.mp3", "merge2.mp3", "merge3.mp3"]

for filename in files:
    path = os.path.join(dir_path, filename)
    if os.path.exists(path):
        print(f"Processing {filename}...")
        try:
            audio = pydub.AudioSegment.from_mp3(path)
            trim_lead = detect_leading_silence(audio)
            
            if trim_lead > 0:
                print(f"Found {trim_lead}ms of silence. Trimming...")
                trimmed = audio[trim_lead:]
                trimmed.export(path, format="mp3")
                print(f"Successfully trimmed and saved {filename}.")
            else:
                print(f"No significant leading silence found for {filename}.")
        except Exception as e:
            print(f"Failed to process {filename}: {e}")
    else:
        print(f"File not found: {path}")

print("Done.")
