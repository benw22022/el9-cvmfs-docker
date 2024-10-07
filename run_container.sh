
MOUNTDIR=${1:-$PWD} # Set mount directory - $PWD (present working dir) by default

echo "Mounting directory" ${MOUNTDIR}

if [ "$MOUNTDIR" != "$HOME" ]; then
    cp .inputrc $MOUNTDIR  # copy .bashrc file, container will run it when it starts
    cp .bashrc $MOUNTDIR   # copy .inputrc file, nice-to-have cmd history tool
else
    # Don't copy .bashrc/.inputrc if we're mounting $HOME, don't want to accidently overwrite them!
    echo "WARNING: Trying to mount home directory - will not copy .bashrc and .inputrc files"
    echo "WARNING: You will need to execute the commands in .bashrc yourself"
fi

# Run container
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        docker run --platform linux/amd64 --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm -it -v $MOUNTDIR/:/home/atreus  benw22022/faser:el9-cvmfs bash
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        docker run --platform linux/amd64 --privileged -e DISPLAY=docker.for.mac.host.internal:0 --rm -it -v $MOUNTDIR/:/home/atreus  benw22022/faser:el9-cvmfs bash
fi