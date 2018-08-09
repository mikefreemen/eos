debugOn="Please debug prettily for me..."
debugEnabled () {
  [ ! -z "$debugOn" ]
}
echo "======================================="
echo "This utility copies into the eosio Docker container the missing files that will make compiling/linking work for contracts."
echo "It was written to work with EOSIO 1.1.4.  Things change fast.  It may not work for 1.1.5..."
echo "Move required files to where the eosiocpp tool expects them..."
echo "======================================="
echo " "
echo "You do *not* need to have built the EOS source, but you do need to clone the eos github repository."
echo "If you need to clone the repo, press Ctrl-C and then run 'git clone https://github.com/EOSIO/eos.git'.  Take note of where you do this because you'll need to tell this script where that folder is."
echo " "
echo " "

debugEnabled && echo "Debug mode enabled..."

echo "Please enter the path to your cloned eos repo"

### TEMPORARY ###
# read EOSIO_CLONED_REPO_ROOT
EOSIO_CLONED_REPO_ROOT=/home/mike/eosSandbox/eos
### TEMPORARY ###

debugEnabled && echo "EOSIO_CLONED_REPO_ROOT: (${EOSIO_CLONED_REPO_ROOT})"
if [ ! -d "$EOSIO_CLONED_REPO_ROOT" ]; then
  echo "I don't see that folder; did you type it correctly?"
  exit 0
fi

debugEnabled && echo "About to move needed files from (${EOSIO_CLONED_REPO_ROOT})"
EOSIO_INSTALL_DIR=/opt/eosio
debugEnabled && echo "EOSIO_INSTALL_DIR: (${EOSIO_INSTALL_DIR})"

### NEED FIXING ###
BOOST_INSTALL_INCLUDE_DIR=${HOME}/opt/boost/include
debugEnabled && echo "BOOST_INSTALL_INCLUDE_DIR: (${BOOST_INSTALL_INCLUDE_DIR})"
###################

echo "Fixing Compilation Paths..."
# sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/include ${EOSIO_INSTALL_DIR}/include/

#docker exec -it eosio mkdir -p ${EOSIO_INSTALL_DIR}/include/eosiolib
docker cp ${EOSIO_CLONED_REPO_ROOT}/contracts/eosiolib eosio:${EOSIO_INSTALL_DIR}/include/

docker exec -it mkdir -p ${EOSIO_INSTALL_DIR}/include/libc++/upstream/include
cp ${EOSIO_CLONED_REPO_ROOT}/contracts/libc++/upstream/include ${EOSIO_INSTALL_DIR}/include/libc++/upstream/
exit 0

sudo mkdir -p ${EOSIO_INSTALL_DIR}/include/musl/upstream/include
sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/contracts/musl/upstream/include/* ${EOSIO_INSTALL_DIR}/include/musl/upstream/include
sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/externals/magic_get/include/boost ${BOOST_INSTALL_INCLUDE_DIR}

# Fix Linking Folders
CONTRACTS_SDK_LIB_DIR=${EOSIO_INSTALL_DIR}/contractsdk/lib/
echo "Fixing Linker Paths... Linker lib folder target: (${CONTRACTS_SDK_LIB_DIR})"
sudo mkdir -p ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/eosiolib/eosiolib.bc ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/libc++/libc++.bc ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/musl/libc.bc ${CONTRACTS_SDK_LIB_DIR}
