#debugOn="Please debug prettily for me..."
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
echo "If you need to clone the repo, press Ctrl-C and then run 'git clone https://github.com/EOSIO/eos.git --recursive'.  Take note of where you do this because you'll need to tell this script where that folder is."
echo " "
echo " "

debugEnabled && echo "Debug mode enabled..."

echo "Please enter the path to your cloned eos repo"
read EOSIO_CLONED_REPO_ROOT

debugEnabled && echo "EOSIO_CLONED_REPO_ROOT: (${EOSIO_CLONED_REPO_ROOT})"
if [ ! -d "$EOSIO_CLONED_REPO_ROOT" ]; then
  echo "I don't see that folder; did you type it correctly?"
  exit 0
fi

debugEnabled && echo "About to move needed files from (${EOSIO_CLONED_REPO_ROOT})"
EOSIO_INSTALL_DIR=/opt/eosio
debugEnabled && echo "EOSIO_INSTALL_DIR: (${EOSIO_INSTALL_DIR})"

BOOST_INSTALL_INCLUDE_DIR=/usr/local/include
debugEnabled && echo "BOOST_INSTALL_INCLUDE_DIR: (${BOOST_INSTALL_INCLUDE_DIR})"

echo "Fixing Compilation Paths..."
docker cp ${EOSIO_CLONED_REPO_ROOT}/contracts/eosiolib eosio:${EOSIO_INSTALL_DIR}/include/

docker cp ${EOSIO_CLONED_REPO_ROOT}/contracts/libc++/upstream eosio:${EOSIO_INSTALL_DIR}/include/libc++/

docker cp ${EOSIO_CLONED_REPO_ROOT}/contracts/musl eosio:${EOSIO_INSTALL_DIR}/include/

docker cp ${EOSIO_CLONED_REPO_ROOT}/externals/magic_get/include/boost eosio:${BOOST_INSTALL_INCLUDE_DIR}

# Fix Linking Folders
CONTRACTS_SDK_LIB_DIR=${EOSIO_INSTALL_DIR}/contractsdk/lib/
echo "Fixing Linker Paths... Linker lib folder target: (${CONTRACTS_SDK_LIB_DIR})"
docker exec -it eosio mkdir -p ${CONTRACTS_SDK_LIB_DIR}
docker cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/eosiolib/eosiolib.bc eosio:${CONTRACTS_SDK_LIB_DIR}
docker cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/libc++/libc++.bc eosio:${CONTRACTS_SDK_LIB_DIR}
docker cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/musl/libc.bc eosio:${CONTRACTS_SDK_LIB_DIR}

echo " "
echo "Done.  If you don't see any errors listed, everything likely went as planned."
echo " "
