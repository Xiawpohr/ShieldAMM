# ShieldAMM

ShieldAMM is a POC for private DEX that allow users to trade assets without revealing the accounts that the assets originate from. It uses recursive zkSNARKs to prove both the asset users owned (by having already deposited) and correctness of AMM calculation including swap, add_liquidity, remove_liquidy.

I am inspired by this article: [Unlocking the Power of Recursive ZK Snarks: Applications and Implementations](https://medium.com/@denniswon/unlocking-the-power-of-recursive-zk-snarks-applications-and-implementations-83666a22b54a) that says recursive ZK Snarks offer several benefits, including compression and composability. In this POC, I was exploring the composability concept that recursive proofs offer and how it can be applied to build a private DEX.

With the help of recursive proofs, the DEX may has several advantages:

- Provide privacy of users' accounts and assets. Users can trade without revealing their accounts or actual balances.

- MEV resistance because of difficulty to guess the actual volumn and price of a trade.

- Maybe saving gas fee compared to normal DEX because the AMM calculation run off chain, and only just verify the correctness on chain.


## How it works
Recursive proofs allows for the verification of a smart proof inside another proof. In this project, recursive proofs are below:

- Proof of swap = Proof of deposit + Proof of swap calculation + Verify the new commitment
- Proof of add liquidity = Proof of deposit + Proof of add liquidity calculation + Verify the new commitments
- Proof of remove liquidity = Proof of deposit + Proof of remove liquidity calculation + Verify the new commitments

### Tech stacks

- Circuits(POC): Noir-lang
- Contract(POC): Solidity, Foundry, Hardhat
- Frontend(Not completed): Nextjs, viem, wagmi, Typescript

## Deployed contracts

### Scroll
- Hasher: [0x304Ed679c69275a8B12A6663983eBc4619DA7C3a]()
- TokenDepositVerifier: [0x1C502a3813d4344Eb25410216ce4De00B730AD21](https://sepolia.scrollscan.com/address/0x1c502a3813d4344eb25410216ce4de00b730ad21#code)
- LiquidityDepositVerifier: [0x73035CCf7fA8E97cB7F32C6f2E6cCDcF42294A8a](https://sepolia.scrollscan.com/address/0x73035ccf7fa8e97cb7f32c6f2e6ccdcf42294a8a#code)
- SwapVerifier: [0x26cc60457f335b08ab058b860C827749ef9FA054](https://sepolia.scrollscan.com/address/0x26cc60457f335b08ab058b860c827749ef9fa054#code)
- AddLiquidityVerifier: [0x5c6A2101890195716Ee63aDE4De14A779AE50e0a](https://sepolia.scrollscan.com/address/0x5c6a2101890195716ee63ade4de14a779ae50e0a#code)
- RemoveLiquidityVerifier: [0xb6e84861c691aa9dfbb48cd67f4be2cbccbf69f6](https://sepolia.scrollscan.com/address/0xb6e84861c691aa9dfbb48cd67f4be2cbccbf69f6#code)
- ShieldAMM: [0xEdbE93b0C9209ee404883748a6e30BCDFa8e397b](https://sepolia.scrollscan.com/address/0xedbe93b0c9209ee404883748a6e30bcdfa8e397b#code)
- BaseToken: 0xD28BDAD0ED2Cc5B15C6076180457b052886F6Ce9
- QuoteToken: 0x74b88b2102852cc333B709485bbF2C49ab36817A

### Zircuit
- Hasher: [0xC8A9D09B83364Bac3057d7771042F2e65DE7fD66]()
- TokenDepositVerifier: [0xa04Fd76a26d4A26D3DE35CdFAa519D2ce0BAB210]()
- SwapVerifier: [0x8dFC02934789B07Cd6b54eDf50CE0B2100f16C7B]()
- AddLiquidityVerifier: [0x67282Fd79C505a25EB0Ce413C5e22398A1D4706A]()
- RemoveLiquidityVerifier: [0x26812E22584dA408c2c91C9C845b9c21CE50E720]()
- ShieldAMM: [0xF4f831bf6538DE2B1130E13326ED9c8Aa227EdA7]()
- BaseToken: 0xE5Fb43b8AE0eFA84b5718437Bb8B0528fAd65eB4
- QuoteToken: 0xF3d2905747F1F0Ae8E8062E31a6626f936e3C72d

### Polygon (Updating...)
- Hasher: []()
- TokenDepositVerifier: []()
- SwapVerifier: []()
- AddLiquidityVerifier: []()
- RemoveLiquidityVerifier: []()
- ShieldAMM: []()
- BaseToken: 
- QuoteToken: 

### Optimism (Updating...)
- Hasher: []()
- TokenDepositVerifier: []()
- SwapVerifier: []()
- AddLiquidityVerifier: []()
- RemoveLiquidityVerifier: []()
- ShieldAMM: []()
- BaseToken: 
- QuoteToken: 

### Linea (Updating...)
- Hasher: []()
- TokenDepositVerifier: []()
- SwapVerifier: []()
- AddLiquidityVerifier: []()
- RemoveLiquidityVerifier: []()
- ShieldAMM: []()
- BaseToken: 
- QuoteToken: 

### ThunderCore (Updating...)
- Hasher: []()
- TokenDepositVerifier: []()
- SwapVerifier: []()
- AddLiquidityVerifier: []()
- RemoveLiquidityVerifier: []()
- ShieldAMM: []()

### Ten Protocol (Updating...)
- Hasher: []()
- TokenDepositVerifier: []()
- SwapVerifier: []()
- AddLiquidityVerifier: []()
- RemoveLiquidityVerifier: []()
- ShieldAMM: []()
