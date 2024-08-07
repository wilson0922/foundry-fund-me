-include .env

build:; forge build

deploy-anvil:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url ${RPC_URL_ANVIL} --account wilson_anvil --broadcast