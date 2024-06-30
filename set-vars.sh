# directories for each validators
mkdir -p val-anvil8545
mkdir -p val-anvil8546

# directories for each relayer
mkdir -p hyperlane_db_relayer
mkdir -p hyperlane_db_relayer2

# temp directory for validator signatures
mkdir -p tmp/hyperlane-validator-signatures-val-anvil8545
mkdir -p tmp/hyperlane-validator-signatures-val-anvil8546


# key to deploy hyperlane contracts
export HYP_KEY=$(cat contract-deployer.pk)

# config file used by docker containers
export CONFIG_FILES=$HOME/projects/hyperlane-example/configs/agent-docker.json

export VALIDATOR_SIGNATURES_DIR1=tmp/hyperlane-validator-signatures-val-anvil8545
export VALIDATOR_SIGNATURES_DIR2=tmp/hyperlane-validator-signatures-val-anvil8546

# hyperlane docker image to use with validator and relayer
export IMAGE_TAG=3bb9d0a-20240619-130157
#export IMAGE_TAG=705c911-20240627-131536
