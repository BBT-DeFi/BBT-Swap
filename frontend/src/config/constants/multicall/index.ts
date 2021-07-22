import { ChainId } from '@pancakeswap/sdk'
import MULTICALL_ABI from './abi.json'

const MULTICALL_NETWORKS: { [chainId in ChainId]: string } = {
  [ChainId.MAINNET]: '0x80E239569A212122aE0490A154D94A39Acdae421',
  [ChainId.TESTNET]: '0x80E239569A212122aE0490A154D94A39Acdae421',
}

export { MULTICALL_ABI, MULTICALL_NETWORKS }
