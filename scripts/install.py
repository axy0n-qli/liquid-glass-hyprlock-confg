import subprocess
import sys

answer = input("This will replace hyprlock.conf and hypridle.conf (a timestamped backup is kept). Continue? (Y/N) ")
if answer.strip().lower() != "y":
    sys.exit(1)

print("Installing...")

process = subprocess.Popen(
    ["bash", "./scripts/install-files.sh"],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True,
    bufsize=1,
)

for line in process.stdout:
    print(line, end="")
    sys.stdout.flush()

process.wait()

if process.returncode == 0:
    print("\nDone! The installation has completed successfully.")
else:
    print(f"\nError: The installation failed with code {process.returncode}")

sys.exit(process.returncode)
