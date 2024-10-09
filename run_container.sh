
# Optional arguement
MOUNTDIR_REL=${1:-$PWD} # Set mount directory - $PWD (present working dir) by default


# Function to convert a relative path to an absolute one - Note different methods for linux and mac OS
get_absolute_path() {
    local relative_path="$1"
    local absolute_path="$1"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local absolute_path="$(readlink -f "$relative_path")"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        local absolute_path="$(perl -MCwd -e 'print Cwd::abs_path(shift)' "$relative_path")"  #! Untested! Pester me if this doesn't work!
    fi
    echo "$absolute_path"
}

# Docker won't accept a relative path when mounting a volume so ensure MOUNTDIR is an absolute path
MOUNTDIR=$(get_absolute_path "$MOUNTDIR_REL")

echo "Mounting directory" ${MOUNTDIR}

# Copy .bashrc/.inputrc to mount directory UNLESS we're mounting $HOME - don't want to accidently overwrite them!
if [ "$MOUNTDIR" != "$HOME" ]; then
    cp .inputrc $MOUNTDIR  # copy .bashrc file, container will run it when it starts
    cp .bashrc $MOUNTDIR   # copy .inputrc file, nice-to-have cmd history tool
else
    echo "WARNING: Trying to mount home directory - will not copy .bashrc and .inputrc files"
    echo "WARNING: You will need to execute the commands in .bashrc yourself"
fi

# Run container - diffent commands for linux/macOS so that x11 forwarding works
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        docker run --platform linux/amd64 --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm -it -v $MOUNTDIR/:/home/atreus  benw22022/faser:el9-cvmfs bash
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        docker run --platform linux/amd64 --privileged -e DISPLAY=docker.for.mac.host.internal:0 --rm -it -v $MOUNTDIR/:/home/atreus  benw22022/faser:el9-cvmfs bash
fi