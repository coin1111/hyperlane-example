
if [ "$1" -eq 0 ]; then
    hyperlane send message --key  0xc7e3eb4490ae10be9c519775df937a530b5a386561c22545609a706dedcca5bd --verbosity trace --origin anvil8545 --destination anvil8546
elif [ "$1" -eq 1 ]; then
    hyperlane send message --key  0xc7e3eb4490ae10be9c519775df937a530b5a386561c22545609a706dedcca5bd --verbosity trace --origin anvil8546 --destination anvil8545
else
    echo "Invalid argument. Please provide 0 or 1."
    exit 1
fi



