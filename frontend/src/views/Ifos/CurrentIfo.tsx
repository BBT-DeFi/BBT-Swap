import React from 'react'
import { ifosConfig } from 'config/constants'
import useGetPublicIfoV1Data from 'views/Ifos/hooks/v1/useGetPublicIfoData'
import useGetWalletIfoV1Data from 'views/Ifos/hooks/v1/useGetWalletIfoData'
import useGetPublicIfoV2Data from 'views/Ifos/hooks/v2/useGetPublicIfoData'
import useGetWalletIfoV2Data from 'views/Ifos/hooks/v2/useGetWalletIfoData'
import IfoFoldableCard from './components/IfoFoldableCard'
import IfoLayout from './components/IfoLayout'
import IfoSteps from './components/IfoSteps'
import IfoQuestions from './components/IfoQuestions'

/**
 * Note: currently there should be only 1 active IFO at a time
 */
const activeIfo = ifosConfig.find((ifo) => ifo.isActive)

const Ifo = () => {
  const publicIfoData = useGetPublicIfoV1Data(activeIfo)
  const walletIfoData = useGetWalletIfoV1Data(activeIfo)

  return (
    <IfoLayout>
      <IfoFoldableCard ifo={activeIfo} publicIfoData={publicIfoData} walletIfoData={walletIfoData} isInitiallyVisible />
      <IfoSteps ifo={activeIfo} walletIfoData={walletIfoData} />
      <IfoQuestions />
    </IfoLayout>
  )
}

export default Ifo
