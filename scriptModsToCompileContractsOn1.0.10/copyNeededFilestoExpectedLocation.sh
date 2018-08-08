echo "======================================="
echo "This utility moves around files to be where the eosiocpp tool expects them."
echo "It was written to work with EOSIO 1.0.10.  Things change fast.  It may not work for 1.1.1..."
echo "Move required files to where the eosiocpp tool expects them..."
echo "======================================="
echo " "
echo "You need to have built and installed EOS by this point.  Press Ctrl-C if you haven't."
echo "That means you've built according to the Getting Started pages on the EOSIO Developer Portal"
echo "You can start here  https://developers.eos.io/eosio-nodeos/docs/getting-the-code"
echo "and continue through the instructions until you've run 'sudo make install'"
echo " "
echo " "
echo "Please enter the path to your cloned eos repo"
read EOSIO_CLONED_REPO_ROOT
echo "EOSIO_CLONED_REPO_ROOT: (${EOSIO_CLONED_REPO_ROOT})"

if [ ! -d "$EOSIO_CLONED_REPO_ROOT" ]; then
  echo "I don't see that folder; did you type it correctly?"
  exit 0
fi

EOSIO_CLONED_REPO_ROOT=${HOME}/eosSandbox/eos
echo "About to move needed files from (${EOSIO_CLONED_REPO_ROOT})"
EOSIO_INSTALL_DIR=/usr/local/eosio
echo "EOSIO_INSTALL_DIR: (${EOSIO_INSTALL_DIR})"
BOOST_INSTALL_INCLUDE_DIR=${HOME}/opt/boost/include
echo "BOOST_INSTALL_INCLUDE_DIR: (${BOOST_INSTALL_INCLUDE_DIR})"

echo "Fixing Compilation Paths..."
# sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/include ${EOSIO_INSTALL_DIR}/include/
sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/contracts/eosiolib ${EOSIO_INSTALL_DIR}/include/
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/eosiolib/*.hpp ${EOSIO_INSTALL_DIR}/include/eosiolib/
sudo mkdir -p ${EOSIO_INSTALL_DIR}/include/libc++/upstream/include && \
  sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/contracts/libc++/upstream/include/* ${EOSIO_INSTALL_DIR}/include/libc++/upstream/include
sudo mkdir -p ${EOSIO_INSTALL_DIR}/include/musl/upstream/include && \
  sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/contracts/musl/upstream/include/* ${EOSIO_INSTALL_DIR}/include/musl/upstream/include
sudo cp -R ${EOSIO_CLONED_REPO_ROOT}/externals/magic_get/include/boost ${BOOST_INSTALL_INCLUDE_DIR}

# Fix Linking Folders
CONTRACTS_SDK_LIB_DIR=${EOSIO_INSTALL_DIR}/contractsdk/lib/
echo "Fixing Linder Paths... Linker lib folder target: (${CONTRACTS_SDK_LIB_DIR})"
sudo mkdir -p ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/eosiolib/eosiolib.bc ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/libc++/libc++.bc ${CONTRACTS_SDK_LIB_DIR}
sudo cp ${EOSIO_CLONED_REPO_ROOT}/build/contracts/musl/libc.bc ${CONTRACTS_SDK_LIB_DIR}

