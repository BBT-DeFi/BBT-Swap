import React from 'react'
import styled from 'styled-components'
import { Box } from '@pancakeswap/uikit'
import Container from '../Layout/Container'
// layout header
const Outer = styled(Box)<{ background?: string }>`
background: linear-gradient(180deg, rgba(2, 215, 103, 0.24) 0%, rgba(2, 215, 103, 0) 100%);
`

const Inner = styled(Container)`
  padding-top: 32px;
  padding-bottom: 32px;
`

const PageHeader: React.FC<{ background?: string }> = ({ background, children, ...props }) => (
  <Outer background={background} {...props}>
    <Inner>{children}</Inner>
  </Outer>
)

export default PageHeader
