import { ChainId } from '@pancakeswap/sdk'
import MULTICALL_ABI from './abi.json'

const MULTICALL_NETWORKS: { [chainId in ChainId]: string } = {
  [ChainId.MAINNET]: '0xd2f9F33E231f5b2103Cba7393dE61CBc15527E9d',
  [ChainId.TESTNET]: '0xd2f9F33E231f5b2103Cba7393dE61CBc15527E9d',
}

export { MULTICALL_ABI, MULTICALL_NETWORKS }
