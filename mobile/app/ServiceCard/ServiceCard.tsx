import React from 'react'
import { View } from 'react-native'
import Markdown from 'react-native-markdown-display'

import { Card, Divider, Icon, Text, useTheme } from '@ui-kitten/components'

import Service from '../../domain/Service'

interface ServiceCardProps {
    service: Service
}

const CardHeader: React.FC<{ title: string; status: Status; qosLibelle: string }> = ({ title, status, qosLibelle }) => {
    const theme = useTheme()

    const getIconName = () => {
        switch (status) {
            case 'success':
                return 'sun-outline'
            case 'warning':
                return 'umbrella-outline'
            case 'danger':
                return 'flash-outline'
            default:
                return 'info-outline'
        }
    }

    return (
        <View>
            <View style={{ display: 'flex', flexDirection: 'row', justifyContent: 'space-between', margin: 10 }}>
                <Text category="h6" style={{ color: theme['color-basic-800'] }}>
                    {title}
                </Text>
                <Icon fill={theme[`color-${status}-default`]} name={getIconName()} style={{ height: 25, width: 25 }} />
            </View>
            <Divider />
            <Text style={{ backgroundColor: theme[`color-${status}-default`], paddingLeft: 10 }}>{qosLibelle}</Text>
        </View>
    )
}

type Status = 'basic' | 'primary' | 'success' | 'info' | 'warning' | 'danger' | 'control'

const ServiceCard: React.FC<ServiceCardProps> = ({ service }) => {
    const getStatus = (): Status => {
        switch (service.qualiteDeService.key) {
            case 1:
                return 'success'
            case 2:
                return 'warning'
            case 3:
                return 'danger'
            default:
                return 'basic'
        }
    }

    return (
        <Card
            header={() => (
                <CardHeader
                    title={service.libelle}
                    status={getStatus()}
                    qosLibelle={service.qualiteDeService.libelle}
                />
            )}
            status={getStatus()}
            style={{ marginVertical: 5, marginHorizontal: 2, backgroundColor: 'white' }}
        >
            <Markdown >
                {service.description}
            </Markdown>
        </Card>
    )
}

export default ServiceCard
