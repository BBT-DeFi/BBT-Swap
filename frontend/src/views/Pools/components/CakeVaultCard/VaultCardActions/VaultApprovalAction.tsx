import React from 'react'
import styled from 'styled-components'
import { Button, AutoRenewIcon, Skeleton } from '@pancakeswap/uikit'
import { useTranslation } from 'contexts/Localization'
import { useVaultApprove } from '../../../hooks/useApprove'

const ButtonEnable = styled(Button)`
background:#02D767;
`

// apy auto cake

interface ApprovalActionProps {
  setLastUpdated: () => void
  isLoading?: boolean
}

const VaultApprovalAction: React.FC<ApprovalActionProps> = ({ isLoading = false, setLastUpdated }) => {
  const { t } = useTranslation()

  const { handleApprove, requestedApproval } = useVaultApprove(setLastUpdated)

  return (
    <>
      {isLoading ? (
        <Skeleton width="100%" height="52px" />
      ) : (
        <ButtonEnable
          isLoading={requestedApproval}
          endIcon={requestedApproval ? <AutoRenewIcon spin color="currentColor" /> : null}
          disabled={requestedApproval}
          onClick={handleApprove}
          width="100%"
        >
          {t('Enable')}
        </ButtonEnable>
      )}
    </>
  )
}

export default VaultApprovalAction
