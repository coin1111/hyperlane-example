
if [ "$1" -eq 0 ]; then
	hyperlane send transfer -w /Users/ruslan/.hyperlane/deployments/warp_routes/LTK/anvil8545-anvil8546-config.yaml --origin  anvil8545 --destination anvil8546
elif [ "$1" -eq 1 ]; then
	hyperlane send transfer -w /Users/ruslan/.hyperlane/deployments/warp_routes/LTK/anvil8545-anvil8546-config.yaml --origin  anvil8546 --destination anvil8545
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi

