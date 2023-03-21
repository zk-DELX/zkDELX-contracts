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
