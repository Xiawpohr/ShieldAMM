import { mainnet } from "wagmi/chains";

interface Token {
  name: string
  symbol: string
  decimals: number
  address: string
  isQuate: boolean
}

interface ContractMeta {
  address: string
  abi: JSON
}

export const PairTokens: Record<number, Token[]> = {
  [mainnet.id]: [
    {
      name: 'Base Token',
      symbol: 'BASE',
      decimals: 4,
      address: '0xbase',
      isQuate: false,
    },
    {
      name: 'Quote Token',
      symbol: 'QUOTR',
      decimals: 4,
      address: '0xquote',
      isQuate: false,
    },
  ]
}

export const ExchangeContract: Record<number, ContractMeta> = {
  [mainnet.id]: {
    address: '0xExchange',
    abi: [{}]
  }
}