import React from 'react'
import styled, { css } from 'styled-components'
import { Button, useWalletModal } from '@pancakeswap/uikit'
import useAuth from 'hooks/useAuth'
import { useTranslation } from 'contexts/Localization'


const ButtonUnlock = styled(Button)`
background: #02D767;
`


const UnlockButton = (props) => {
  const { t } = useTranslation()
  const { login, logout } = useAuth()
  const { onPresentConnectModal } = useWalletModal(login, logout)

  return (
    <ButtonUnlock onClick={onPresentConnectModal} {...props}>
      {t('Unlock Wallet')}
    </ButtonUnlock>
  )
}

export default UnlockButton