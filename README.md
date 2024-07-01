# Hyperlane example of sending messages between 2 chains

## Architecture

1. We create 2 "blockchains" using Foundry Anvil (equivalent to hardhat): 
- anvil8545
- anvil8546

2. Launch 2 validator for each of 2 blockchains. Each validator will sign messages in mailbox on its chain. Validator private keys must be stored security, otherwise messages can be validated by an attacker.

3. Launch 2 releayer each for its chain. Each relayer watches for messages and validator signatures on its chain and send a message to the second chain. Relayer private keys if stolen will not lead to data loss, since relayer only copies a message from one chain mailbox to the other chain.


## Setup

1. Install hyperlane cli
```
npm install -g @hyperlane-xyz/cli@3.16.0 # 4.0.0+ has different cli commands
```

2. Create 2 chains 

```
# anvil8545
hyperlane config create chain 
```
use  values from this file ```$HOME/.hyperlane/chains/anvil8545/metadata.yaml``` to answer questions:
```
name: anvil8545
chainId: 31337
domainId: 31337
protocol: ethereum
rpcUrls:
  - http: http://localhost:8545
blocks:
  confirmations: 1
  reorgPeriod: 1
  estimateBlockTime: 6
transactionOverrides:
  maxFeePerGas: 1000000000
  maxPriorityFeePerGas: 1000000000
  # add this section manually if missing. this is required for warp send to work
nativeToken:
  name: ETH
  symbol: ETH
  decimals: 18
  ```

  create 2nd chain by copying ```$HOME/.hyperlane/chains/anvil8545/metadata.yaml``` i n to ```$HOME/.hyperlane/chains/anvil8546/metadata.yaml``` and fixing yaml values

## Install Foundry

Foundry is equivalent of Hardhat, but new. It has anvil which is simulation of EVM.

```
curl -L https://foundry.paradigm.xyz | bash

foundryup

```

## Create keys

For this example 3 set of keys are required
1. Deployer keys. These keys are used to deploy contracts on both chains. A key can be created using Foundry's cast

```cast wallet new
```

Save private key in ```contract-deployer.pk`` and publick key in ``` contract-deployer.pub```

2. Validator keys
Each validator would use the same key for simplicity. We use the first account key from anvil predefined accounts:
```
pub: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
pk: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

3. for relayer we use contract-deployer key

## Create ISM (Interchain security module)

```
hyperlane config create ism
```
Resulting file can be found in configs/ism.yaml:
```
anvil8545:
  threshold: 1
  validators:
    - "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
anvil8546:
  threshold: 1
  validators:
    - "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
```

note that validator address is set to public key used for validators for both chains

## Set up environment

```
source set-vars.sh
```

## Run Anvil for each chain
```
# use terminal 1
./run-anvil.sh 0
```

```
# use terminal 2
./run-anvil.sh 1
```

## Fund deployer on both chains

```
./fund-deployer.sh 0
./fund-deployer.sh 1
```

## Deploy hyperlane core contracts
```
./deploy-core.sh
```

## Run validators and relayers using docker
```
./run-validator.sh 0
./run-validator.sh 1
```

```
./run-relayer.sh 0
./run-relayer.sh 1
```

Check that all containres are running using ```docker ps -a```

```
CONTAINER ID   IMAGE                                                            COMMAND                  CREATED         STATUS         PORTS     NAMES
bf3626a7bd72   gcr.io/abacus-labs-dev/hyperlane-agent:3bb9d0a-20240619-130157   "tini -- ./relayer -…"   3 minutes ago   Up 3 minutes             upbeat_haslett
cd6e035f0914   gcr.io/abacus-labs-dev/hyperlane-agent:3bb9d0a-20240619-130157   "tini -- ./relayer -…"   3 minutes ago   Up 3 minutes             stupefied_zhukovsky
7b7d3a923531   gcr.io/abacus-labs-dev/hyperlane-agent:3bb9d0a-20240619-130157   "tini -- ./validator…"   3 minutes ago   Up 3 minutes             keen_goldwasser
371c1f6abfce   gcr.io/abacus-labs-dev/hyperlane-agent:3bb9d0a-20240619-130157   "tini -- ./validator…"   4 minutes ago   Up 4 minutes             modest_stonebraker

```

## Send messages

From anvil8545 to anvil8546
```
./send-message.sh 0
```

From anvil8546 to anvil8545
```
./send-message.sh 1
```

Example output:
```
Getting gas quote                                                                [0/1831]
Paying for gas with 0 wei
Dispatching message
Pending 0xed2017e778ab4ff9a038dbc2fcc43a9a0b1fae3b319854f02eeed575274477f0 (waiting 1 blocks for confirmation)
Sent message from anvil8546 to 0x7873EAB34FBbb4efEBB34d53F0B24D33684F9D94 on anvil8545.
Message ID: 0x0c7187e0faadf505804cdbf58a33d50d52d4f659366eb905b646ae635ca627e6
Message: {"parsed":{"version":3,"nonce":0,"origin":31338,"sender":"0x000000000000000000000000d0a8b649c848917c035d7af0267c1bbe964b9f88","destination":31337,"recipient":"0x0000000000000000000000007873eab34fbbb4efebb34d53f0b24d33684f9d94","body":"0x48656c6c6f21","originChain":"anvil8546","destinationChain":"anvil8545"},"id":"0x0c7187e0faadf505804cdbf58a33d50d52d4f659366eb905b646ae635ca627e6","message":"0x030000000000007a6a000000000000000000000000d0a8b649c848917c035d7af0267c1bbe964b9f8800007a690000000000000000000000007873eab34fbbb4efebb34d53f0b24d33684f9d9448656c6c6f21"}
Waiting for message delivery on destination chain...
Checking if message 0x0c7187e0faadf505804cdbf58a33d50d52d4f659366eb905b646ae635ca627e6 wa
s processed
Checking if message 0x0c7187e0faadf505804cdbf58a33d50d52d4f659366eb905b646ae635ca627e6 wa
s processed
Message 0x0c7187e0faadf505804cdbf58a33d50d52d4f659366eb905b646ae635ca627e6 was processed
All messages processed for tx 0xed2017e778ab4ff9a038dbc2fcc43a9a0b1fae3b319854f02eeed5752
74477f0
Message was delivered! 
```


## cleanup

```
./docker-rm.sh
./cleanup.sh
```

use crtl-c to stop anvil instances

## Debugging ethereum contracts

To debug ethereum contracts install hardhat:
```
npm i --save-dev hardhat
npx hardhat init 
npm i --save-dev @nomicfoundation/hardhat-foundry
```

```
# run script
npx hardhat run eth-scripts/valAnnounce.ts
```


## Create ERC20 token for Warp route

1. create forge project
```
forge init --force warp-token
cd warp-token
forge install openzeppelin/openzeppelin-contracts

```

2. Deploy token
```
cd ..
./deploy-erc20.sh 0
./deploy-erc20.sh 1
Deployer: 0xd0A8b649C848917C035d7aF0267c1bBE964B9f88                                     
Deployed to: 0xA9456C391C1930Fc50af92C7C44b45CF6066C1B4                                  
Transaction hash: 0x25ad41e15928c63a55b914054e5233c92b255df5023ae9b926930a7fd4c91d7e     

```

run tests
```
forge test
cd ..
```

3. Create warp config

```
hyperlane config create warp
```
Resulting file:
```
anvil8545:
  isNft: false
  type: collateral
  token: "0xA9456C391C1930Fc50af92C7C44b45CF6066C1B4"
  owner: "0xd0A8b649C848917C035d7aF0267c1bBE964B9f88"
  mailbox: "0x08F49137cF9fBcB702EF21661c268a1083Cc7058"
anvil8546:
  isNft: false
  type: collateral
  token: "0xA9456C391C1930Fc50af92C7C44b45CF6066C1B4"
  owner: "0xd0A8b649C848917C035d7aF0267c1bBE964B9f88"
  mailbox: "0x08F49137cF9fBcB702EF21661c268a1083Cc7058"
  ```

  make sure that token contract returned by ```./deploy-token.sh``` matches token in warp config file in ```configs/warp-route-deployment.yaml```.

4. Deploy warp route contracts

```
hyperlane deploy warp
```

this will produce a new config file in ```~/.hyperlane/deployments/warp_routes/LTK/anvil8545-anvil8546-config.yaml```
this config file is required to send tokens over warp route

5. Send tokens via warp route

```
hyperlane send transfer -w ~/.hyperlane/deployments/warp_routes/LTK/anvil8545-anvil8546-config.yaml --origin  anvil8545 --destination anvil8546
```

output:
```
Sending test transfer                                                                                                     
Selected origin chain: anvil8545, destination chain: anvil8546                                                       
Running pre-flight checks for chains...                                                                                   
✅ Chains are valid                                                                                                       
✅ Signer is valid                                                                                                        
✅ Balances are sufficient                                                                                                
Sending 1 wei from anvil8545 to anvil8546                                                                                 
Approval is required for transfer of LTK                                                                                  
Approval required for transfer of LTK                                                                                     
Approval is required for transfer of LTK                                                                                  
Approval required for transfer of LTK                                                                                     
Pending 0x63a3cadb4b6674c1ac6a210c66828715f4022cd6261488714ade615deefc8ac6 (waiting 1 blocks for confirmation)           
Pending 0xc3ddf61f4d19e5d1a185586a35ebd3dfee5242bff8e72e95aa9dd26a0127ccf0 (waiting 1 blocks for confirmation)           
Sent message from anvil8545 to 0xd0A8b649C848917C035d7aF0267c1bBE964B9f88 on anvil8546.                              
Message ID: 0xde74b0f1480c5a8715707e614e16fe3112040e84615ec993585f60b437593533                                       
Message 0xde74b0f1480c5a8715707e614e16fe3112040e84615ec993585f60b437593533 was processed                             
All messages processed for tx 0xc3ddf61f4d19e5d1a185586a35ebd3dfee5242bff8e72e95aa9dd26a0127ccf0                     
Transfer sent to destination chain!
```














See official [docs] (https://docs.hyperlane.xyz/docs/guides/deploy-hyperlane-local-agents)