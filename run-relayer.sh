
if [ "$1" -eq 0 ]; then
    SIGNATURES_DIR=$VALIDATOR_SIGNATURES_DIR1
    RELAYER_DIR=hyperlane_db_relayer
elif [ "$1" -eq 1 ]; then
    SIGNATURES_DIR=$VALIDATOR_SIGNATURES_DIR2
    RELAYER_DIR=hyperlane_db_relayer2
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi

RELAYER_KEY=$(cat contract-deployer.pk)
#IMAGE_TAG=3bb9d0a-20240619-130157
docker run \
  --platform linux/amd64 \
  -d \
  -it \
  -e CONFIG_FILES=/config/agent-config.json \
  --mount type=bind,source=$CONFIG_FILES,target=/config/agent-config.json,readonly \
  --mount type=bind,source="$(pwd)"/$RELAYER_DIR,target=/hyperlane_db \
  --mount type=bind,source="$(pwd)"/$SIGNATURES_DIR,target=/tmp/validator-signatures,readonly \
  gcr.io/abacus-labs-dev/hyperlane-agent:"$IMAGE_TAG" \
  ./relayer \
  --db /hyperlane_db \
  --relayChains anvil8545,anvil8546 \
  --allowLocalCheckpointSyncers true \
  --log.level trace \
  --defaultSigner.key $RELAYER_KEY \
