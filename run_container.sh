

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        docker run --platform linux/amd64 --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm -it -v $PWD/:/home/atreus  docker.io/library/el9-cvmfs-container bash
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        docker run --platform linux/amd64 --privileged -e DISPLAY=docker.for.mac.host.internal:0 --rm -it -v $PWD/:/home/atreus  docker.io/library/el9-cvmfs-container bash
fi