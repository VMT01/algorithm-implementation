# Define options and arguments
options="f:"
long_options="file:"

# Use getopt to parse options
longopts=$(getopt -a -o "$options" --long "$long_options" -- "$@")

# Evaluate arguments into separate variables
eval set -- "$longopts"

file=""

while :; do
    case "$1" in
        -f | --file ) file="$2"; shift 2
        ;;
        -- ) shift; break
        ;;
        \? ) echo "Invalid option: -$OPTARG" >&2; exit 1
        ;;
    esac
done

# Check for file exists in command
if [ -z "$file" ]; then
    echo "Error: No file specified!"
    exit 1
fi

# Checo for file exists in current workspace
file_directory=$(find . -name "$file")
if [ -z "$file_directory" ]; then
    echo "Error: Cannot find $file in current directory"
    exit 1
fi

# Build and run CPP files
build_and_run_cpp() {
    echo "Building $1..."
    $(gcc $2 -o "ocpp")
    echo "Running $1...\n"
    ./ocpp
    echo "\n\nCleanning..."
    rm -rf ./ocpp
}

# Extract file extension
extension="${file##*.}"
case "$extension" in
    cpp) build_and_run_cpp "$file" "$file_directory"
    ;;
    py) echo "PYTHON IS NOT IMPLEMENT YET"
    ;;
    js) echo "JS IS NOT IMPLEMENT YET"
    ;;
    rs) echo "RUST IS NOT IMPLEMENT YET"
    ;;
    *) echo "NO IMPLEMENT FOR $extension"
    ;;
esac
