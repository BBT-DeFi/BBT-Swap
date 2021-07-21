import { ChainId } from '@pancakeswap/sdk'

const NETWORK_URLS: { [chainId in ChainId]: string } = {
  [ChainId.MAINNET]: 'https://rpc-testnet.bitkubchain.io',
  [ChainId.TESTNET]: 'https://rpc-testnet.bitkubchain.io',
}

export default NETWORK_URLS
