
hyperlane deploy core --targets anvil8545,anvil8546
cp configs/agent.json configs/agent-docker.json

sed -i '' 's|"http://localhost|"http://host.docker.internal|g'  configs/agent-docker.json
