#/bin/bash
# Original Code from: https://medium.com/@ekkis/eos-development-on-docker-3f4eb9b680ec

WALLET_NAME_OPT="--name test_wallet "

rm .Pass
rm .OwnerKeys
rm .ActiveKeys

isDocker="This is Docker!"
if [ -z isDocker ]; then
  PATH_MOD_FOR_DOCKER="build"
else
  PATH_MOD_FOR_DOCKER=""
fi

runCleos () { 
  #For the 1.1.4 Dev Portal Smart Contract Tutorial provided docker container: docker exec -it eosio /opt/eosio/bin/cleos -u http://0.0.0.0:8888 --wallet-url http://0.0.0.0:8888 $@
  docker-compose -f <ABSOLUTE_PATH_TO_CLONED_EOS_REPO_DIR>/Docker/docker-compose.yml exec keosd /opt/eosio/bin/cleos -u http://nodeosd:8888 --wallet-url http://localhost:8900 $@
}

#echo "Creating$WALLET_NAME_OPT wallet..."
runCleos wallet create $WALLET_NAME_OPT--to-console > .Pass

echo "Just wrote .Pass..."
echo "=====.Pass contents are as follows====="
cat .Pass
echo "============================="

echo "Import chain key..."
runCleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 $WALLET_NAME_OPT
echo "Set bios contract..."
runCleos set contract eosio $PATH_MOD_FOR_DOCKER/contracts/eosio.bios -p eosio@active

echo "Creating key pairs..."
runCleos create key --to-console > .OwnerKeys
runCleos create key --to-console > .ActiveKeys

OwnerKey=$(cat .OwnerKeys |grep Public |cut -d" " -f3)
echo "OwnerKey: $OwnerKey"
ActiveKey=$(cat .ActiveKeys |grep Public |cut -d" " -f3)
echo "ActiveKey: $ActiveKey"

echo "Import generated Active/Owner keys..."
runCleos wallet import --private-key=$(cat .OwnerKeys |grep Private |cut -d" " -f3) $WALLET_NAME_OPT
runCleos wallet import --private-key=$(cat .ActiveKeys |grep Private |cut -d" " -f3) $WALLET_NAME_OPT

echo "Creating \"user\" account"
runCleos create account eosio user $OwnerKey $ActiveKey
echo "Creating \"tester\" account"
runCleos create account eosio tester $OwnerKey $ActiveKey

runCleos get accounts $OwnerKey
