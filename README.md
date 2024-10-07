# EL9 Docker Container

Scripts for running an el9 container with `cvmfs` mounted for FASER/FASER2 studies with GEANT4

To install docker see [documentation](https://docs.docker.com/get-started/get-docker/)

## Running the container

To run the container run:

```bash
./run_container.sh
```

The docker image is hosted on [docker hub](https://hub.docker.com/layers/benw22022/faser/el9-cvmfs/images/sha256-e6cffa8f752e192eae60b134dd28fb34682d257e02eed9355d17986c186ae116?context=repo) and the container should be pulled when you run this script for the first time.

This script should automatically mount your current working directory. Alternatively you can mount a directory by passing an argument:

```bash
./run_container.sh /path/to/directory/
```

The `./run_container.sh` script will copy over the `.bashrc` and `.inputrc` files to your mounted directory. When you start a terminal in the container it will automatically source the `.bashrc` and run the commands to mount the `cvmfs` repositories. The `.inputrc` is just a nice to have command history tool. If you try and mount your home directory the `.bashrc` and `.inputrc` files will not be copied over to avoid accidentally overwriting any existing files. If this happens you'll need to run the commands to mount the `cvmfs` repositories yourself. The commands in the `.bashrc` could also be built into the docker container, but it was decided to put them in the `.bashrc` instead to allow for future customisation without the need to rebuild the container.

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

To get x11 forwarding to work on you mac machine follow the instructions on this [gist](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088).

## Getting Geant4 visualisation working

If not already there, copy `init_vis.mac` into your geant4 app build directory

You can then start your geant4 app interactively by doing `./<myGeant4App>`.

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
