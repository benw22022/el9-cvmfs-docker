# EL9 Docker Container

Scripts for running an el9 container with `cvmfs` mounted for FASER/FASER2 studies with GEANT4

Special thanks to @tzuhanchang who did a lot of the hard work by giving me the DockerFile to build a container with `cvmfs` mounted  

## Installing Docker

To install docker see the getting started page in the docker [documentation](https://docs.docker.com/get-started/get-docker/)

## Running the container

To start the container run:

```bash
./run_container.sh
```

The docker image is hosted on [docker hub](https://hub.docker.com/layers/benw22022/faser/el9-cvmfs/images/sha256-e6cffa8f752e192eae60b134dd28fb34682d257e02eed9355d17986c186ae116?context=repo) and the container should be pulled when you run this script for the first time.

This script should automatically mount your current working directory. Alternatively you can mount a directory by passing an argument:

```bash
./run_container.sh /path/to/directory/
```

The `./run_container.sh` script will copy over the `.bashrc` and `.inputrc` files to your mounted directory. When you start a terminal in the container it will automatically source the `.bashrc` and run the commands to mount the `cvmfs` repositories. The `.inputrc` is just a nice to have command history tool; start tying a command and press the `up`/`down` arrows to scroll through previously used commands. If you try and mount your home directory the `.bashrc` and `.inputrc` files will not be copied over to avoid accidentally overwriting any existing files. If this happens you'll need to run the commands to mount the `cvmfs` repositories yourself.
<!-- The commands in the `.bashrc` could also be built into the docker container, but it was decided to put them in the `.bashrc` instead to allow for future customisation without the need to rebuild the container. 
-> Actually it appears that you cannot start the auto mounter when building the container
-->

Once inside the container you can setup an LCG release with:

```bash
source /cvmfs/sft.cern.ch/lcg/views/LCG_105/x86_64-el9-gcc11-opt/setup.sh
```

*Note*: Setting up LCG releases and other software from cvmfs are likely to be slow. Running programs such as `root` for the first time are also likely to be slow.

## Displaying windows on mac OS (x11 forwarding)

On a mac, if you run the container and try and open up a GUI window, such as a `TBrowser` for example:

```bash
$ root 
root [0] new TBrowser
Warning in <TBrowser::TBrowser>: The ROOT browser cannot run in batch mode
```

it probably won't work due to x11 forwarding not being set up (x11 is the protocol on unix machines which manages the creation of windows).

To get x11 forwarding to work on you mac machine follow the instructions on this [gist](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088). *Note*: the final step in this guide involves pulling a container and running `xclock` however, this container is depreciated so no longer works. To verify x11 forwarding is working run `./run_container.sh` and try and open a firefox window (simply enter `firefox` in the terminal).

To follow this guide you'll need to install the `homebrew` package manager. Instructions on installing `homebrew` if you do not have it already can be found in this [guide](https://mac.install.guide/homebrew/3).

## Getting Geant4 visualisation working

If not already there, copy `init_vis.mac` into your geant4 app build directory

You can then start your geant4 app interactively by doing `./<myGeant4App>`.

*Special note for macOS*: You need to edit the `vis.mac` file and change the viewer backend from `OGL` to `TOOLSSG_QT_ZB`.
i.e. replace

```bash
/vis/open OGL 600x600-0+0
```

with:

```bash
/vis/open/ TOOLSSG_QT_ZB
```

## Some notes about running code in docker containers

- To exit a container type `exit` or `ctrl + d`
- Docker containers are self-contained environments, they don't know anything about your host system. To give the container access to your host filesystem you need to mount a directory using the `-v <path/on/host>:<path/on/container>` option when doing `docker run`. Only files and folders in `<path/on/host>` will be accessible from within the container.
- Docker containers don't (by default) save changes on exit. If you make a change to the container environment it won't be there when you start the container again. Likewise, any files you write to a will not be kept on exit *unless* they were saved to a mounted directory.

## Building the container

The image on docker hub should be sufficient but should you wish to build the container yourself (say you want to apply some changes) you can run:

```bash
./build_container.sh
```

*Note*: You'll need to update the container name in the `run_container.sh` script

## Compiling older FASER G4 models

Sometimes `make` will complain that `fatal error: g4root.hh: No such file or directory`. This is because this file was removed in newer releases of Geant4 (>= 11.0). To fix, replace instances of `#include "g4root.hh"` with `#include "G4AnalysisManager.hh"`.

There was also a change to `G4String`, now instead of something like `thePrePVname(0,4) == "calo"` instead do `thePrePVname.substr(0, 4) == "calo"`.
