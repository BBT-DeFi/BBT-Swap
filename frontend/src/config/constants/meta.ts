import { ContextApi } from 'contexts/Localization/types'
import { PageMeta } from './types'

export const DEFAULT_META: PageMeta = {
  title: 'BBTSwap',
  description:
    '*',
  image: 'https://pancakeswap.finance/images/hero.png',
}

export const getCustomMeta = (path: string, t: ContextApi['t']): PageMeta => {
  switch (path) {
    case '/':
      return {
        title: `${t('Home')} | ${t('BBTSwap')}`,
      }
    case '/competition':
      return {
        title: `${t('Trading Battle')} | ${t('BBTSwap')}`,
      }
    case '/prediction':
      return {
        title: `${t('Prediction')} | ${t('BBTSwap')}`,
      }
    case '/farms':
      return {
        title: `${t('Farms')} | ${t('BBTSwap')}`,
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
        title: `${t('Collectibles')} | ${t('BBTSwap')}`,
      }
    case '/ifo':
      return {
        title: `${t('Initial Farm Offering')} | ${t('BBTSwap')}`,
      }
    case '/teams':
      return {
        title: `${t('Leaderboard')} | ${t('BBTSwap')}`,
      }
    case '/profile/tasks':
      return {
        title: `${t('Task Center')} | ${t('BBTSwap')}`,
      }
    case '/profile':
      return {
        title: `${t('Your Profile')} | ${t('BBTSwap')}`,
      }
    default:
      return null
  }
}
