const BBT_OFFICIAL = 'https://thanakiat-gusgus.github.io/bbt-api/bbt-official.json'
const BBT_SAMPLE = 'https://thanakiat-gusgus.github.io/bbt-api/bbt-sample.json'

export const UNSUPPORTED_LIST_URLS: string[] = []

// lower index == higher priority for token import
export const DEFAULT_LIST_OF_LISTS: string[] = [
  BBT_OFFICIAL,
  BBT_SAMPLE,
  ...UNSUPPORTED_LIST_URLS, // need to load unsupported tokens as well
]

// default lists to be 'active' aka searched across
export const DEFAULT_ACTIVE_LIST_URLS: string[] = []
