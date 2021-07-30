import { BASE_URL } from 'config'

const getTokenLogoURL = (address: string) =>
  `${BASE_URL}/images/tokens/${address}.png`

export default getTokenLogoURL
