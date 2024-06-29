# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Please provide a fan speed percentage (e.g., 50, 75, 100)."
    exit 1
fi

# Check if the provided argument is a valid number between 0 and 100
if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -lt 0 ] || [ "$1" -gt 100 ]; then
    echo "Error: Please provide a valid number between 0 and 100."
    exit 1
fi

# Set the fan speed
sudo -E nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=$1"

echo "Fan speed set to $1%"
