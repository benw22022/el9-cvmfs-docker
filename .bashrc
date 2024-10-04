# Place this in your work directory where you start your container and this will be automatically executed when the container starts

# User specific aliases and functions
sudo mount -t cvmfs atlas.cern.ch /cvmfs/atlas.cern.ch
sudo mount -t cvmfs atlas-condb.cern.ch /cvmfs/atlas-condb.cern.ch
sudo mount -t cvmfs atlas-nightlies.cern.ch /cvmfs/atlas-nightlies.cern.ch
sudo mount -t cvmfs grid.cern.ch /cvmfs/grid.cern.ch
sudo mount -t cvmfs sft-nightlies.cern.ch /cvmfs/sft-nightlies.cern.ch
sudo mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
sudo mount -t cvmfs unpacked.cern.ch /cvmfs/unpacked.cern.ch
sudo mount -t cvmfs geant4.cern.ch /cvmfs/geant4.cern.ch
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

