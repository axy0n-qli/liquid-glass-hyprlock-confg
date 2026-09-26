import subprocess
import sys

print("Installing required dependencies...")

cmd = ["sudo", "pacman", "-S", "--needed", "playerctl", "hyprlock", "hypridle", "--noconfirm"]

try:
    res = subprocess.run(cmd, check=True)
    print("Dependencies installed successfully!")
except subprocess.CalledProcessError as e:
    print(f"Installation failed")
except KeyboardInterrupt:
    print("\nInterrupted by the user.")
    sys.exit(1)
except Exception as e:
    print(f"Error")