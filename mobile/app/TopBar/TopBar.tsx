import React from 'react'
import { Image } from 'react-native'

import { Text, TopNavigation } from '@ui-kitten/components'

import Logo from './tt.png'

const TopBar: React.FC = () => {
    return (
        <TopNavigation
            alignment="center"
            title={() => <Text category="h4">Météo du numérique</Text>}
            accessoryLeft={() => <Image source={Logo} style={{ height: 50, width: 50, backgroundColor: 'white' }} />}
        />
    )
}

export default TopBar
