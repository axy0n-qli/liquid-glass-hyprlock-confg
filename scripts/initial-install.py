import sys

authorisation = input("This script will overwrite the existing hyprlock configuration! Are you sure you want to continue? (Y/N) ")

if authorisation.lower() == "y":
    print("Continuing...")
elif authorisation.lower() == "n":
    sys.exit(1)  
else:
    print("Invalid input. Please enter 'Y' or 'N'.")
    sys.exit(1)