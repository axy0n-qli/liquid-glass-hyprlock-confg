import subprocess
import sys

authorisation = input("Are you sure you want to continue? (Y/N) ")
if authorisation == "N" or authorisation == "n":
    sys.exit(1)
elif authorisation == "Y" or authorisation == "y":
    print("Installing...")

processus = subprocess.Popen(
    ["bash", "./scripts/install-files.sh"],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,  
    text=True,
    bufsize=1                  
)


for ligne in processus.stdout:
    print(ligne, end="")
    sys.stdout.flush()         

processus.wait()

if processus.returncode == 0:
    print("\nDone! The installation has completed successfully.")
else:
    print(f"\nError: The installation failed with code {processus.returncode}")