import React, { ReactText } from 'react'
import { View } from 'react-native'

import { Button, Icon, Text, useTheme } from '@ui-kitten/components'

interface ErrorProps {
    message: ReactText
    reload: () => void
}

const RefreshIcon = (props) => <Icon {...props} name="refresh" />

const Error: React.FC<ErrorProps> = ({ message, reload }) => {
    const theme = useTheme()
    return (
        <View
            style={{
                borderColor: theme['color-danger-600'],
                borderRadius: 5,
                borderWidth: 1,
                padding: 10,
                backgroundColor: theme['color-danger-200'],
            }}
        >
            <Text style={{ color: theme['color-danger-600'],textAlign: 'center', marginBottom: 5 }}>{message}</Text>
            <Button status="danger" appearance="outline" accessoryRight={RefreshIcon} onPress={reload} >
                Recharger les données
            </Button>
        </View>
    )
}

export default Error
