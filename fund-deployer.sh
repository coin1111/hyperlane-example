if [ "$1" -eq 0 ]; then
    port=8545
elif [ "$1" -eq 1 ]; then
    port=8546
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi
cast send 0xd0A8b649C848917C035d7aF0267c1bBE964B9f88 \
--rpc-url http://127.0.0.1:$port \
--private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
--value $(cast tw 1)
