# Introduction

This is a project for Decentralized ELectricity eXchange (DELX).

Refer to [excalidraw](https://excalidraw.com/#room=1e40eb59d4910c89d990,kqi-1NwQ7TxqgMy-49i0Nw) for the system design

## Specifications
- In frontend, all prices keep two decimals precision in dollars, e.g., 0.47 $/KWh, and when interacting with smart contract, all prices are represented in cents, e.g., 47 cents/KWh. 
- People can choose to pay in various stablecoins, USDT, USDC etc. The value of a KWh of electricity should be always stable. Involving Eth for payments will break this stability. Look at [here](https://www.statista.com/statistics/263492/electricity-prices-in-selected-countries/) for the worldwide  electricity household prices.
- User types: consumer, prosumer, producer


## Foundry Installation

To install with [DappTools](https://github.com/dapphub/dapptools):

```
dapp install [user]/[repo]
```

To install with [Foundry](https://github.com/gakonst/foundry):

```
forge install [user]/[repo]
```

## Local development

This project uses [Foundry](https://github.com/gakonst/foundry) as the development framework.

### Dependencies

```
forge install
```

### Compilation

```
forge build
```

### Testing

```
forge test -vvvvv
```

### Contract deployment

Please create a `.env` file before deployment. An example can be found in `.env.example`.

#### Local deployment

Run `anvil` by open another terminal. This will start a local network and spin up 10 accounts and private keys and log them out to the console. Once the network is running, we can use forge to deploy the contract to the network. 

Next, set the PRIVATE_KEY variable by using one of the private keys given to you by Anvil: 

`export PRIVATE_KEY=<your-private-key>`

To deploy localy, run the code below: (In the `.env` file, input only `ETHERSCAN_KEY="43YT5BP2MWN1HMBY5I5IE5BQ7I1FBB5Z2D"` should be good to deploy locally)

```
forge script script/Market.s.sol:ContractScript --fork-url http://localhost:8545 \
--private-key $PRIVATE_KEY --broadcast
```

#### Dryrun

```
forge script script/Deploy.s.sol -f [network]
```

### Live

```
forge script script/Deploy.s.sol -f [network] --verify --broadcast
```



### Example 
https://github.com/dabit3/foundry-workshop

### Polygon zkEVM
Contract address: `0x258FF931ce6A7DC9391a649E8a7A84fC17717c76`

Testnet setup and bridge ETH from Goerli https://wiki.polygon.technology/docs/zkEVM/develop

Then using Remix to deploy it.

Etherscan verifcation process: https://github.com/oceans404/zkevm-hardhat-demo#verify-your-polygon-zkevm-testnet-contract

https://explorer.public.zkevm-test.net/address/0x258FF931ce6A7DC9391a649E8a7A84fC17717c76/contracts#address-tabs 

### Scroll Alpha Testnet
https://guide.scroll.io/developers/developer-quickstart 

Contract deployment to run:

```
forge create --rpc-url https://alpha-rpc.scroll.io/l2 \
  --constructor-args 1000000000 \
  --private-key <PK> \
  --legacy \
  src/Market.sol:Market
```

Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x6ed5AA348b93022D0f117823f2F7525EecA526fd
Transaction hash: 0x0ab4e000eb522c23328c428dcc5fd4cd164d47a4e790c6dc02ce9daef0deb479
Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x258FF931ce6A7DC9391a649E8a7A84fC17717c76
Transaction hash: 0x8097d4708ce748ad12fd8c6a24dfd145079a3fe48cf37b4fb292bd1a3ce3b93b

### Taiko Hackathon Testnet
```
orge create --rpc-url https://l2rpc.a2.taiko.xyz/ \
  --constructor-args 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99 \
  --private-key <PK> \
  --legacy \
  src/test/TestToken.sol:TestToken

Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x258FF931ce6A7DC9391a649E8a7A84fC17717c76
Transaction hash: 0x707be16258be9ea9af34e3ba011f81980c7d6afa2bf9c28406099a71d388e6b5
```

```
forge create --rpc-url https://l2rpc.hackathon.taiko.xyz \
  --constructor-args <PK> \
  --private-key <PK> \
  --legacy \
  src/Market.sol:Market

Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x6ed5AA348b93022D0f117823f2F7525EecA526fd
Transaction hash: 0xdbb97be9580e2ed72ad53b4ba85b59ef41172d1f44908032954c5933e8da2013
```