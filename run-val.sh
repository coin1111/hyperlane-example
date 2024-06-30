if [ "$1" -eq 0 ]; then
    VAL_DIR=val-anvil8545
    CHAIN_NAME=anvil8545
    SIGNATURES_DIR=$VALIDATOR_SIGNATURES_DIR1
elif [ "$1" -eq 1 ]; then
    VAL_DIR=val-anvil8546
    CHAIN_NAME=anvil8546
    SIGNATURES_DIR=$VALIDATOR_SIGNATURES_DIR2
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi

VAL_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

#IMAGE_TAG=3bb9d0a-20240619-130157
#IMAGE_TAG=3adc0e9-20240319-152359

docker run \
  --platform linux/amd64 \
  -d \
  -it \
  -e CONFIG_FILES=/config/agent-config.json \
  --mount type=bind,source=$CONFIG_FILES,target=/config/agent-config.json,readonly \
  --mount type=bind,source="$(pwd)"/"$VAL_DIR",target=/hyperlane_db \
  --mount type=bind,source="$(pwd)"/$SIGNATURES_DIR,target=/tmp/validator-signatures \
  gcr.io/abacus-labs-dev/hyperlane-agent:"$IMAGE_TAG" \
  ./validator \
  --db /hyperlane_db \
  --originChainName "$CHAIN_NAME" \
  --checkpointSyncer.type localStorage \
  --checkpointSyncer.path /tmp/validator-signatures \
  --log.level trace \
  --validator.key "$VAL_KEY"
