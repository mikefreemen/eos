This is kludgy; don't expect much...

My main goal was simply to get the hello world tutorial on the EOS Developer Portal working.  This script and one other mod achieves that.

Preconditions:
 - clone the EOS github repo according to the [Getting the Code page](https://developers.eos.io/eosio-nodeos/docs/getting-the-code)
 - Build EOS source as described in the [Build Tutorial here](https://developers.eos.io/eosio-nodeos/docs/autobuild-script)
 - Install the executables according to [these instructions](https://developers.eos.io/eosio-nodeos/docs/install-executables).
 - Then following the 2 steps below
 
1) edit `/usr/local/eosio/bin/eosiocpp`
 - On lines 57, 58, and 59, you'll find this
    ${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/eosiolib.bc \
    ${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/libc++.bc \
    ${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/libc.bc
 - Change those paths to look like this
    ${EOSIO_INSTALL_DIR}/contractsdk/lib/eosiolib.bc \
    ${EOSIO_INSTALL_DIR}/contractsdk/lib/libc++.bc \
    ${EOSIO_INSTALL_DIR}/contractsdk/lib/libc.bc

2) Then download the script in this folder in my repo, set it executable if needed, and execute it.
 - It will ask you for the folder you cloned the EOS repo into.
 - Then it will move around a few files the compiler and linker need to compile and link.
 - It appears that the build system / file structure is being reorganized, and this file is just out of sync with the intended system.  So this puts the needed files (at least for the hello tutorial) where the compiler/linker expect them.
