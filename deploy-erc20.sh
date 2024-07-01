pushd warp-token
if [ "$1" -eq 0 ]; then
	forge create Ltk --rpc-url=http://127.0.0.1:8545 --private-key=`cat ../contract-deployer.pk`
	popd warp-token
elif [ "$1" -eq 1 ]; then
	forge create Ltk --rpc-url=http://127.0.0.1:8546 --private-key=`cat ../contract-deployer.pk`
	popd warp-token
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi

