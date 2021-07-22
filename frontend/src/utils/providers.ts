import { ethers } from 'ethers'
import getRpcUrl from 'utils/getRpcUrl'

const RPC_URL = getRpcUrl()
// const RPC_URL = 'https://bsc-dataseed.binance.org/'

export const simpleRpcProvider = new ethers.providers.JsonRpcProvider(RPC_URL)

export default null
