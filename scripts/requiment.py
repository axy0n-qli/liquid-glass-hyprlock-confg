import subprocess
import sys

print("Installing required dependencies...")

cmd = [
    "sudo", "pacman", "-S", "--needed", "--noconfirm",
    "playerctl", "hyprlock", "hypridle", "hyprland", "ttf-jetbrains-mono-nerd",
]

try:
    subprocess.run(cmd, check=True)
    print("Dependencies installed successfully!")
except subprocess.CalledProcessError as error:
    print(f"Dependency installation failed (exit code {error.returncode})")
    sys.exit(1)
except KeyboardInterrupt:
    print("\nInterrupted by the user.")
    sys.exit(1)
