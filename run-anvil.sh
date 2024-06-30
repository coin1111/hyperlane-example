set -x
if [ "$1" -eq 0 ]; then
    PORT=8545
    CHAINID=31337
elif [ "$1" -eq 1 ]; then
    PORT=8546
    CHAINID=31338
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi
anvil --port $PORT --block-time 1  --chain-id $CHAINID
