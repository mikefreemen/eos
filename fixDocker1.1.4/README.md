[h1]Fixing the Docker environment for EOSIO software so contracts compile[/h1]
This fix is for running EOSIO v1.1.4 in the provided Docker container.

[h3]Notes[/h3]
1) This is *not* a simple fix.  Unfortunately, the Docker container block.one provides with v1.1.4 of the software does not have all the required files in it.  So to get your Docker container working, you need to download ***and build*** the source.  Likely not the reason you wanted to use Docker in the first place.  But at least this gets things working if you're inclined to use the Docker container anyway.
2) I'm not coding it to 1.1.4, but things change fast, so given that this is an area of code that's actively changing, don't count on it beyond 1.1.4.  I'll attempt to update it as changes are made.  This is kludgy; don't expect much...
3) I've used Docker for years now but never understood it as well as I would have liked.  This was a learning project for me as much as it was about getting this container to work.  This is version 1 where the compilation/linking works.  I'll likely next map a special folder for dev to make development a bit more convenient, but that's not done yet.

[h2]The Goal[/h2]
My main goal was simply to get the [hello world tutorial](https://developers.eos.io/eosio-cpp/docs/hello-world) on the [EOS Developer Portal](https://developers.eos.io/) working in Docker.  This script and one other mod achieves that.

TL;DR: The instructions in my blog post plus the script in this folder should get the job done with EOSIO v1.1.4.

Blog Post: [EOS Contracts Nube Troubleshooting Tech Note #3: a fix Docker container for compiling the EOSIO 1.1.4 hello Contract Tutorial](https://steemit.com/eos/@mikefreemen/eos-contracts-nube-troubleshooting-tech-note-3-a-fix-docker-container-for-compiling-the-eosio-1-1-4-hello-contract-tutorial)

Running the Script
 - It will ask you for the folder you cloned the EOS repo into.  If you haven't done this already, clone the repo and remember where you did that with this command 'git clone https://github.com/EOSIO/eos --recursive'
 - Then it will move a few files the compiler and linker need into the docker container to the appropriate locations.
 - It appears that the build system / file structure is being reorganized, and these files are just out of sync with the intended structure.  So this puts the needed files (at least for the hello tutorial) where the compiler/linker expect them.

To be uber-clear, this is not meant to do what the EOSIO, I'm sure soon, will do to actually fix this.  This is just a stop-gap measure to assist those like me trying to learn EOS Contracts at a time when the primary example in the repo doesn't work.  If I get fed up with this format and try to formalize this solution more, I'll update the code here.

