# Introduction

This is a project for Decentralized ELectricity eXchange powered by Zero Knowledge technology (zkDELX).

zkDELX is an innovative decentralized electricity exchange protocol based on zkEVM that facilitates the integration of electric vehicles and renewable energy industries. This protocol provides a user-friendly and efficient experience, similar to popular ride-sharing services like Uber, to match the supply side of green energy generated from households with surplus energy storage, and the demand side of electric vehicles finding charging sources in a very convenient way.

Sellers can create an offer by providing their energy storage information, location, and electricity price, which is aggregated from local real-time electricity prices using a price oracle. Buyers can select the offer based on the options of price, demand for electricity, and distance between the seller's energy storage location and the buyer's electric vehicle.

Powered by advanced zkEVM technology scaling solutions, the transaction is low-cost and high-volume.

To further decentralize the platform, the backend database also utilizes a decentralized database to store information. As a result, the transaction data can potentially become a public good product that facilitates research and development within the green industry.

Refer to [excalidraw](https://excalidraw.com/#room=1e40eb59d4910c89d990,kqi-1NwQ7TxqgMy-49i0Nw) for the system design and and [these slides](https://docs.google.com/presentation/d/1IRCl-LmM3ytD--NWAEF0NsmdatydBXYflLBzF42_WFM/edit) for the project introduction.

## Specifications

- In frontend, all prices keep two decimals precision in dollars, e.g., 0.47 $/KWh. When interacting with smart contract, all prices related args are represented in BigNumber.
- People can choose to pay in various stablecoins, USDT, USDC etc. The value of a KWh of electricity should be always stable. Involving Eth for payments will break this stability. Look at [here](https://www.statista.com/statistics/263492/electricity-prices-in-selected-countries/) for the worldwide electricity household prices.
- User types: buyer, seller

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

## Update on Taiko Testnet
Deploy on Taiko Alpha-3 Testnet

Test Token Deployment

```
forge create --rpc-url https://rpc.test.taiko.xyz \
  --constructor-args <minter_address> <token_name> \
  --private-key <deploy_pk> \
  --legacy \
  src/test/TestToken.sol:TestToken
```

As results:

```
Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x258FF931ce6A7DC9391a649E8a7A84fC17717c76
Transaction hash: 0x86122c968750d59d4e45598e339d541ee5456b5560c42714de6787628fa2bbf6
```

Main contract deployment

```
forge create --rpc-url https://rpc.test.taiko.xyz \
  --constructor-args 1000000000 \
  --private-key <PK> \
  --legacy \
  src/Market.sol:Market
```

As results
```
Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x6ed5AA348b93022D0f117823f2F7525EecA526fd
Transaction hash: 0xb7364544613478a59cce52a046ba8e23977bcbe08b001664a80cf93eed43781d
```





### Scroll Alpha Testnet

Contract address: `0x0eDD23e9aD4Df447B2F8EE410cb66aAfE08F9f0D`

Developer guide:
https://guide.scroll.io/developers/developer-quickstart

Contract deployment to run:

```
forge create --rpc-url https://alpha-rpc.scroll.io/l2 \
  --constructor-args 1000000000 \
  --private-key <PK> \
  --legacy \
  src/Market.sol:Market
```

Test token deploy:

```
forge create --rpc-url https://alpha-rpc.scroll.io/l2 \
  --constructor-args <Minter address> \
  --private-key <PK> \
  --legacy \
  ----build-info \
  src/test/TestToken.sol:TestToken
https://blockscout.scroll.io/address/0x7A3CFcf7FD5C67abb2970EEB35D3a4a2BacCACD2/read-contract#address-tabs
```

### Taiko Hackathon Testnet

Deploy main contract:

```
forge create --rpc-url https://l2rpc.a2.taiko.xyz/ \
  --constructor-args <Minter Address> \
  --private-key <PK> \
  --legacy \
  src/test/TestToken.sol:TestToken

Deployer: 0xb72D7383D233697B74c672BAa0B0BfeCAAc10B99
Deployed to: 0x258FF931ce6A7DC9391a649E8a7A84fC17717c76
Transaction hash: 0x707be16258be9ea9af34e3ba011f81980c7d6afa2bf9c28406099a71d388e6b5
```

Deploy test token contract:

```
forge create --rpc-url https://l2rpc.a2.taiko.xyz \
  --constructor-args 1000000000000000000000 \
  --private-key <PK> \
  --legacy \
  src/Market.sol:Market

Deployed to:  0x4e2b1bA85b1696A8C826Be0524eFb9345701d776
```
