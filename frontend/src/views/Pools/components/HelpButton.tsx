import React from 'react'
import styled from 'styled-components'
import { Text, Button, HelpIcon, Link } from '@pancakeswap/uikit'
import { useTranslation } from 'contexts/Localization'

const ButtonMain = styled(Button)`
  background-color:#02D767;
  color: ${({ theme }) => theme.colors.text};
  `
const ButtonText = styled(Text)`
  display: none;
  ${({ theme }) => theme.mediaQueries.xs} {
    display: block;
  }
`

const StyledLink = styled(Link)`
  margin-right: 16px;
  display: flex;
  justify-content: flex-end;

  &:hover {
    text-decoration: none;
  }
  ${({ theme }) => theme.mediaQueries.sm} {
    flex: 1;
  }
`

const HelpButton = () => {
  const { t } = useTranslation()
  return (
    <StyledLink external href="https://docs.pancakeswap.finance/syrup-pools/syrup-pool">
      <ButtonMain px={['14px', null, null, null, '20px']} variant="success">
        <ButtonText bold fontSize="16px">
          {t('Help')}
        </ButtonText>
        <HelpIcon ml={[null, null, null, 0, '6px']} />
      </ButtonMain>
    </StyledLink>
  )
}

export default HelpButton
