import React from 'react'
import { Card, CardBody, Heading, Text } from '@pancakeswap/uikit'
import styled from 'styled-components'
import { getBalanceNumber } from 'utils/formatBalance'
import { useTotalSupply, useBurnedBalance } from 'hooks/useTokenBalance'
import { useTranslation } from 'contexts/Localization'
import { getCakeAddress } from 'utils/addressHelpers'
import CardValue from './CardValue'

const StyledCakeStats = styled(Card)`
  margin-left: auto;
  margin-right: auto;
`

const Row = styled.div`
  align-items: center;
  display: flex;
  font-size: 14px;
  justify-content: space-between;
  margin-bottom: 8px;
`

const CakeStats = () => {
  const { t } = useTranslation()
  const totalSupply = useTotalSupply()
  const burnedBalance = getBalanceNumber(useBurnedBalance(getCakeAddress()))
  const cakeSupply = totalSupply ? getBalanceNumber(totalSupply) - burnedBalance : 0

  return (
    <StyledCakeStats>
      <CardBody>
        <Heading scale="xl" mb="24px" color="textBitkub">
          {t('Cake Stats')}
        </Heading>
        <Row>
          <Text fontSize="14px" color="textBitkub">{t('Total CAKE Supply')}</Text>
          {cakeSupply && <CardValue color="textBitkub" fontSize="14px" value={cakeSupply} />}
        </Row>
        <Row>
          <Text fontSize="14px" color="textBitkub">{t('Total CAKE Burned')}</Text>
          <CardValue color="textBitkub" fontSize="14px" decimals={0} value={burnedBalance} />
        </Row>
        <Row>
          <Text fontSize="14px" color="textBitkub">{t('New CAKE/block')}</Text>
          <CardValue color="textBitkub" fontSize="14px" decimals={0} value={19} />
        </Row>
      </CardBody>
    </StyledCakeStats>
  )
}

export default CakeStats
