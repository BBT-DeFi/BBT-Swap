import React from 'react'
import styled from 'styled-components'
import { Link, useLocation } from 'react-router-dom'
import { ButtonMenu, ButtonMenuItem } from '@pancakeswap/uikit'

const StyledNav = styled.nav`
  margin-bottom: 40px;
`

const getActiveIndex = (pathname: string): number => {
  if (
    pathname.includes('/pool') ||
    pathname.includes('/create') ||
    pathname.includes('/remove') ||
    pathname.includes('/swap') ||
    pathname.includes('/find')
  ) {
    return 0
  }
  return 1
}

const Nav = () => {
  const location = useLocation()
  return (
    <StyledNav>
      <ButtonMenu activeIndex={getActiveIndex(location.pathname)} scale="sm" variant="bbtColor">
        <ButtonMenuItem id="swap-nav-link" to="/swap" as={Link}>
          Swap
        </ButtonMenuItem>
        <ButtonMenuItem id="pool-nav-link" to="/pool" as={Link}>
          Liquidity
        </ButtonMenuItem>
      </ButtonMenu>
    </StyledNav>
  )
}

export default Nav
