import React from 'react'
import { useRouteMatch, Link } from 'react-router-dom'
import styled from 'styled-components'
import {
  ButtonMenu,
  ButtonMenuItem,
  Toggle,
  Text,
  Flex,
  NotificationDot,
  useMatchBreakpoints,
} from '@pancakeswap/uikit'
import { useTranslation } from 'contexts/Localization'
import ToggleView, { ViewMode } from './ToggleView/ToggleView'

const ButtonSelectMenu = styled(ButtonMenu)`
  background-color:transparent;
  .ksnaJT{
    background-color:#02D767;
  }
  .fKmQTe{
    background-color:#02D767;
  }
`

const FlexToggle = styled(Flex)`
//Hover Toggle
.cRtcwJ{
  background-color:#02D767;
}
.ffFWKU{
  background-color:#02D767;
}
.kzdlOT:hover + .sc-hmbstg:not(:disabled):not(:checked) {
  box-shadow: 0px 0px 0px 3px #02D767;
}
.kzdlOT:focus + .sc-hmbstg {
box-shadow: 0px 0px 0px 3px #02D767;
}
 
`


const PoolTabButtons = ({ stakedOnly, setStakedOnly, hasStakeInFinishedPools, viewMode, setViewMode }) => {
  const { url, isExact } = useRouteMatch()
  const { isXs, isSm } = useMatchBreakpoints()
  const { t } = useTranslation()

  const viewModeToggle = <ToggleView viewMode={viewMode} onToggle={(mode: ViewMode) => setViewMode(mode)} />

  const liveOrFinishedSwitch = (
    <ButtonSelectMenu activeIndex={isExact ? 0 : 1} scale="sm">
      <ButtonMenuItem as={Link} to={`${url}`}>
        {t('Live')}
      </ButtonMenuItem>
      <NotificationDot show={hasStakeInFinishedPools}>
        <ButtonMenuItem as={Link} to={`${url}/history`}>
          {t('Finished')}
        </ButtonMenuItem>
      </NotificationDot>
    </ButtonSelectMenu>
  )

  const stakedOnlySwitch = (
    <FlexToggle mt={['4px', null, 0, null]} ml={[0, null, '24px', null]} justifyContent="center" alignItems="center">
      <Toggle scale="sm" checked={stakedOnly} onChange={() => setStakedOnly((prev) => !prev)} />
      <Text ml={['4px', '4px', '8px']}>{t('Staked only')}</Text>
    </FlexToggle>
  )

  if (isXs || isSm) {
    return (
      <Flex flexDirection="column" alignItems="flex-start" mb="24px">
        <Flex width="100%" justifyContent="space-between">
          {viewModeToggle}
          {liveOrFinishedSwitch}
        </Flex>
        {stakedOnlySwitch}
      </Flex>
    )
  }

  return (
    <Flex
      alignItems="center"
      justifyContent={['space-around', 'space-around', 'flex-start']}
      mb={['24px', '24px', '24px', '0px']}
    >
      {viewModeToggle}
      {liveOrFinishedSwitch}
      {stakedOnlySwitch}
    </Flex>
  )
}

export default PoolTabButtons
