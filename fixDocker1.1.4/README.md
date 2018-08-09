[h1]Fixing the Docker environment for EOSIO software so contracts compile[/h1]
This fix is for running EOSIO v1.1.4 in the provided Docker container.

[h3]Notes[/h3]
1) This is *not* a simple fix.  Unfortunately, the Docker container block.one provides with v1.1.4 of the software does not have all the required files in it.  So to get your Docker container working, you need to download ***and build*** the source.  Likely not the reason you wanted to use Docker in the first place.  But at least this gets things working if you're inclined to use the Docker container anyway.
2) I'm not coding it to 1.1.4, but things change fast, so given that this is an area of code that's actively changing, don't count on it beyond 1.1.4.  I'll attempt to update it as changes are made.  This is kludgy; don't expect much...
3) I've used Docker for years now but never understood it as well as I would have liked.  This was a learning project for me as much as it was about getting this container to work.  This is version 1 where the compilation/linking works.  I'll likely next map a special folder for dev to make development a bit more convenient, but that's not done yet.

[h2]The Goal[/h2]
My main goal was simply to get the [hello world tutorial](https://developers.eos.io/eosio-cpp/docs/hello-world) on the [EOS Developer Portal](https://developers.eos.io/) working in Docker.  This script and one other mod achieves that.

[h3]Preconditions[/h3]
 - Follow [tutorial for setting up Docker](https://developers.eos.io/eosio-nodeos/docs/docker-quickstart) container.
 - Follow [instructions for starting node in Docker container](https://developers.eos.io/eosio-cpp/docs/introduction-to-smart-contracts) Step 1 and 2.
 - Then starting at Step 3, things started going sideways.  Include the following mods as you continue with the Tutorial.

[h4]Quick Side Note on Docker in case you're new to it...[/h4]
  You can execute a bash shell and look around inside the Docker container.
  This is one of the core debugging tools you'll need.  So...
  Start a bash shell by typing `docker exec -it eosio /bin/bash`
  From here, you can look around, and what you'll find is that the `eosio.bios` contract that the tutorial says to load is *not* in a `build` folder.  In fact, if you do a `find` command, you'll find that there's no `build` folder anywhere in the container.  So... let's point it elsewhere.

[h3]Tweak #1: Loading eosio.bios contract[/h3]
So the step in Step 3 goes from
`cleos set contract eosio build/contracts/eosio.bios -p eosio@active`
to
`cleos set contract eosio /contracts/eosio.bios -p eosio@active`

This `/contracts` folder is, in fact, in the root of the container, and it contains the missing `eosio.bios.wast`.

Ok, so now we have the 'eosio.bios' contract loaded, and can progress to the next tutorial.

[h3]Tweak #2: Correctin paths in the Token, exchange, msig as well as the hello Tutorials[/h3]
In the [Introduction to the EOSIO Token Contract](https://developers.eos.io/eosio-cpp/docs/token-tutorial), we similarly need to remove the `build` part of the path when we load the eosio.token contract.

`cleos set contract eosio.token build/contracts/eosio.token -p eosio.token@active`

becomes

`cleos set contract eosio.token /contracts/eosio.token -p eosio.token@active`

You'll have to do the same removal of the `build` component in each contract you load, so...

`cleos set contract exchange /contracts/exchange -p exchange@active`

and

`cleos set contract eosio.msig /contracts/eosio.msig -p eosio.msig@active`


[h3]Tweak #3: The Hello World Contract Tutorial[/h3]
This finally brings us to [The "Hello World" Contract Tutorial](https://developers.eos.io/eosio-cpp/docs/hello-world), where we run into the compilation/linkage problems...

Now, at this point, you've gotta make sure your eosio commands are aliased so they're referencing the binaries in the Docker container because you don't have those binaries on your host computer, only in the Docker container.  So... add the following to your ~/.bashrc (or equivalent) file:

    `# You've already aliased cleos as part of the tutorial, but you'll need a few others`
    `# This is the binary that runs the block producing node that's running in the background.  You may not need this immediately, but why not reference the basic binaries?`
    `alias nodeos='docker exec -it eosio /opt/eosio/bin/nodeos'`

    `# This is the compile script.  This is the one we're really interested for this tutorial`
    `alias eosiocpp='docker exec -it eosio /opt/eosio/bin/eosiocpp'`

    `# This is a bonus one.  Remember I mentioned earlier that you can peep inside a docker container any time?  This is just meant to provide a short hand for when you want to run a single command inside the Docker container, for example, to look around...`
    `alias esh='docker exec -it eosio'`

Ok, with that done, we can try to compile the hello contract.

After creating hello.cpp, and trying to compile it with this line

`eosiocpp -o hello.wast hello.cpp`

you'll get the error 

`clang-4.0: error: no such file or directory: 'hello.cpp'`

How can it not find the file you just created in the folder you're executing the `eosiocpp` command from, you might ask?  Well, remember that the `eosiocpp` command is aliased to execute *inside* the docker container.  In fact, the entire context for that command is inside the docker container, meaning that once you used the aliased `eosiocpp` command, `eosiocpp` knows nothing about your current directory on your machine.  Hence, when you tell it to run, it looks around ***inside the docker container*** and appropriately doesn't see the file you just wrote.

So, what do we do?  Well you have a few options.  Rather than the really slick answer that just hands you a fish, I'm going to give you a more kludgy version that shows you around your new environment a little more...

Use your aliased shell command `esh` we created above to look inside the container.

`esh ls -al /`

This will show you what's in the root directory of the container.

Notice there's a `contracts` folder?  You could put your `hello` folder in there, or you can create a separate folder in the root to house the contracts you write and keep them separate from the ones that come with the EOSIO code.  For this example, I'm going to follow the better practice of keep my code separate from the provided contracts.

So let's actually get a commandline in the Docker image to give you some familiarity with that.

`docker exec -it eosio /bin/bash`
 - '-it' tells docker to allow you to interact with the container in "interactive" mode
 - 'eosio' is the name of the container
 - and '/bin/bash' give you a shell script to work in (as a view into the container)

You're now "logged into" the Docker container.

`mkdir /mycontracts`
`cd /mycontracts`
`mkdir hello`
`cd hello`

Now, at this point, you might be hating me for not walking you through this before you typed (or copy and pasted?) the hello.cpp code.

Never fear, it's just an opportunity to introduce another cool Docker thing.

We'll exit the container and copy the hello.cpp you typed outside the container into the container.

`exit`  #Exit the Docker container
`docker cp hello.cpp eosio:/mycontracts/hello/`  #Navigate to wherever your hello contract is and copy the .cpp file into the docker container
`docker exec -it eosio /bin/bash`  # Log back into the container
`cd /mycontracts/hello/`
`ls`

And you should see your file.  Tell me that's not cool...

Ok, so now your file is in the docker container.  It's time to compile it.

`eosiocpp -o hello.wast hello.cpp`

and you get an error!

`hello.cpp:1:10: fatal error: 'eosiolib/eosio.hpp' file not found`
`#include <eosiolib/eosio.hpp>`
`         ^~~~~~~~~~~~~~~~~~~~`
`1 error generated.`

But notice!  It's a different thing that's now not being found.  It found hello.cpp, which was our problem a few moments ago, and now it's having trouble finding a file you've referenced in hello.cpp.  Why is this?

Well, notice that the `eosiolib/eosio.hpp` reference isn't an absolute path, and clearly your `hello` directory doesn't have an `eosiolib` subdirectory in it, so the compiler is understandably having trouble here.  It turns out the `eosiocpp` sets certain folders where it expects to find library files from the EOSIO core software, and the `eosiolib` folder isn't there.  Why?!  Well, because the block.one team has been super busy being awesome and, from the looks of things, was mid-way through a reorganization of all these files when the software got released.  So we have a not-completely-working file structure.  So while we wait for them to finish/fix it, you and I are going to fix it enough to get us working again...

So there's 2 parts involved next.  One is fixing a bug in `eosiocpp` itself that's gnarly enough that it'd be dumb to work around it.  Then we're going to move some files from where they *actually* are to where the compiler is looking for them.

[h3]Part 1: fixing the gnarly part...[/h3]
 - Still in your Docker container, open up `/opt/eosio/bin/eosiocpp` in your favorite text editor, ie. `vi`.
 - Look for the following on or near line 57

`${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/eosiolib.bc \`
`${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/libc++.bc \`
`${EOSIO_INSTALL_DIR}/usr/share/eosio/contractsdk/lib/libc.bc`

You want to remove the `/usr/share/eosio` part of the path so that it now looks like

`${EOSIO_INSTALL_DIR}/contractsdk/lib/eosiolib.bc \`
`${EOSIO_INSTALL_DIR}/contractsdk/lib/libc++.bc \`
`${EOSIO_INSTALL_DIR}/contractsdk/lib/libc.bc`

Save your changes, and close the file.

Phew!  Part 1 done.

[h3]2) OK, now for the compiler.[/h3]

Next we're going to move the files that aren't where the compiler expects them...

Rather than give you the gory details, I've written a script you can grab from [my github repo](https://raw.githubusercontent.com/mikefreemen/eos/master/fixBuildFor1.1.4/copyNeededFilestoExpectedLocation.sh).  Paste the contents of this script into a new file, set it to be executable, and run it.

After cloning the eosio repo, you'll need to build.  Build by running the `eosio_build.sh` script in the cloned repo's root.  See [the EOSIO tutorial](https://developers.eos.io/eosio-nodeos/docs/autobuild-script) if you like...

Running the Script
 - It will ask you for the folder you cloned the EOS repo into.  If you haven't done this already, clone the repo and remember where you did that with this command 'git clone https://github.com/EOSIO/eos --recursive'
 - Then it will move a few files the compiler and linker need into the docker container to the appropriate locations.
 - It appears that the build system / file structure is being reorganized, and these files are just out of sync with the intended structure.  So this puts the needed files (at least for the hello tutorial) where the compiler/linker expect them.

To be uber-clear, this is not meant to do what the EOSIO, I'm sure soon, will do to actually fix this.  This is just a stop-gap measure to assist those like me trying to learn EOS Contracts at a time when the primary example in the repo doesn't work.  If I get fed up with this format and try to formalize this solution more, I'll update the code here.

Now we can finally compile the `hello` contract.

