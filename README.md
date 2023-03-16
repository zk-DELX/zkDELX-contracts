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
forge test
```

### Contract deployment

Please create a `.env` file before deployment. An example can be found in `.env.example`.

#### Dryrun

```
forge script script/Deploy.s.sol -f [network]
```

### Live

```
forge script script/Deploy.s.sol -f [network] --verify --broadcast
```