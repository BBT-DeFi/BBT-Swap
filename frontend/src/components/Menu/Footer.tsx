import React from 'react'
import styled from 'styled-components'
import { ButtonMenu, ButtonMenuItem, LinkExternal, Flex, Svg, Image, Button } from '@pancakeswap/uikit'

const Wrapper = styled.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
  align-items: center;
  margin-top: 16px;

  ${({ theme }) => theme.mediaQueries.md} {
    justify-content: space-between;
    flex-direction: row;
  }
`

const BubbleWrapper = styled(Flex)`
  svg {
    fill: ${({ theme }) => theme.colors.bbtColor};
    transition: background-color 0.2s, opacity 0.2s;
  }
  &:hover {
    svg {
      opacity: 0.65;
    }
  }
  &:active {
    svg {
      opacity: 0.85;
    }
  }
`

const Footer = () => {
  return (
    <Wrapper>
      <Flex flexDirection={['column', 'column', 'row']} alignItems="center">
        <LinkExternal
          href="https://northbridge.link/"
          ml={[0, 0, '10px']}
          mt={['10px', '10px', 0]}
          mb={[0, 0, '22px']}
        >
          Convert to KAP-20
        </LinkExternal>
      </Flex>
    </Wrapper>
  )
}

export default Footer
