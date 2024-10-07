# EL9 Docker Container

Built for FASER/FASER2 studies with GEANT4

## Building the container
To build the container run:
```
./build_container.sh
```

## Running the container
To run the container run:
```
./run_container.sh
```

This script should automatically mount your current working directory

## Displaying windows macOS (x11 forwarding)

If you run the container and try and open up a GUI window, such as a `TBrowser` e.g. 
```bash
$ root 
root [0] new TBrowser
Warning in <TBrowser::TBrowser>: The ROOT browser cannot run in batch mode
```
it probably won't work due to x11 forwarding not being setup (x11 is the protocol on unix machines which manages the creation of windows).

To get x11 forwarding to work on you mac machine follow the instructions on this [gist](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088).

# Getting Geant4 visualisation working
If not already there, copy `init_vis.mac` into your Geant4 app build directory