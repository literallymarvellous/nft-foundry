## NFT Contract

#### title Yuri NFT

#### author Ahiara Ikechukwu Marvellous

#### A 100 NFT token that can be collected by anyone, no more than 5 token mints per person per mint.

### Deployment

#### Goerli testnet: 0x007081b55882A23a3B3537A22b4507ad551Ff18a

### Setup

#### CLone repo

```sh
git clone repo
cd yield-farm
```

#### install dependecies and packages

```sh
forge install
```

#### Build smart contracts

```sh
forge build
```

#### Test smart contracts

```sh
forge test
```

#### deployment

Create .env and add to file
GOERLI_RPC_URL=....
ETHERSCAN_KEY=....
PRIVATE_KEY=....

```sh
forge script script/Yuri.s.sol:ContractScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
```
