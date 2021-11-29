import HomeScreen from 'app/HomeScreen'
import React, { useEffect } from 'react'

import * as eva from '@eva-design/eva'
import { ApplicationProvider, IconRegistry } from '@ui-kitten/components'
import { EvaIconsPack } from '@ui-kitten/eva-icons'
import messaging from '@react-native-firebase/messaging'
import { Alert } from 'react-native'

const App: React.FC = () => {
    useEffect(() => {
        messaging()
            .subscribeToTopic('updated')
            .catch(() => Alert.alert('Une erreur est survenue lors de la souscription aux notifications.'))
    }, [])

    return (
        <>
            <IconRegistry icons={EvaIconsPack} />
            <ApplicationProvider {...eva} theme={eva.dark}>
                <HomeScreen />
            </ApplicationProvider>
        </>
    )
}

export default App
