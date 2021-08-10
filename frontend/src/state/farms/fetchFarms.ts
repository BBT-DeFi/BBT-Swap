import { FarmConfig } from 'config/constants/types'
import fetchFarm from './fetchFarm'

const fetchFarms = async (farmsToFetch: FarmConfig[]) => {
  const data = await Promise.all(
    farmsToFetch.map(async (farmConfig) => {
      const farm = await fetchFarm(farmConfig)
      // console.log({farmConfig})
      return farm
    }),
  ).catch(ex => console.error(ex))

  return data
}

export default fetchFarms
