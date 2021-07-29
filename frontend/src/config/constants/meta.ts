import { ContextApi } from 'contexts/Localization/types'
import { PageMeta } from './types'

export const DEFAULT_META: PageMeta = {
  title: 'BBT Swap',
  description:
    'The most popular AMM on BSC by user count! Earn CAKE through yield farming or win it in the Lottery, then stake it in Syrup Pools to earn more tokens! Initial Farm Offerings (new token launch model pioneered by BBT Swap), NFTs, and more, on a platform you can trust.',
  image: 'https://pancakeswap.finance/images/hero.png',
}

export const getCustomMeta = (path: string, t: ContextApi['t']): PageMeta => {
  switch (path) {
    case '/':
      return {
        title: `${t('Home')} | ${t('BBT Swap')}`,
      }
    case '/competition':
      return {
        title: `${t('Trading Battle')} | ${t('BBT Swap')}`,
      }
    case '/prediction':
      return {
        title: `${t('Prediction')} | ${t('BBTSwap')}`,
      }
    case '/farms':
      return {
        title: `${t('Farms')} | ${t('BBT Swap')}`,
      }
    case '/pools':
      return {
        title: `${t('Pools')} | ${t('BBTSwap')}`,
      }
    case '/lottery':
      return {
        title: `${t('Lottery')} | ${t('BBTSwap')}`,
      }
    case '/collectibles':
      return {
        title: `${t('Collectibles')} | ${t('BBT Swap')}`,
      }
    case '/ifo':
      return {
        title: `${t('Initial Farm Offering')} | ${t('BBT Swap')}`,
      }
    case '/teams':
      return {
        title: `${t('Leaderboard')} | ${t('BBT Swap')}`,
      }
    case '/profile/tasks':
      return {
        title: `${t('Task Center')} | ${t('BBT Swap')}`,
      }
    case '/profile':
      return {
        title: `${t('Your Profile')} | ${t('BBT Swap')}`,
      }
    default:
      return null
  }
}
