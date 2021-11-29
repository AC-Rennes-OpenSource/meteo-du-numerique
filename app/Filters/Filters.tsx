import React from 'react'
import { View } from 'react-native'

import { Button, Icon, Text, useTheme } from '@ui-kitten/components'

import IFilters from '../../domain/Filters'

interface FiltersProps {
    filters: IFilters
    filter: (value: 'warning' | 'success' | 'danger') => void
    disabled: boolean
}

const WarningIcon = (props: any) => {
    const theme = useTheme()
    return <Icon {...props} name="umbrella-outline" fill={theme[`color-warning-default`]} />
}

const SuccessIcon = (props: any) => {
    const theme = useTheme()
    return <Icon {...props} name="sun-outline" fill={theme[`color-success-default`]} />
}

const DangerIcon = (props: any) => {
    const theme = useTheme()
    return <Icon {...props} name="flash-outline" fill={theme[`color-danger-default`]} />
}

const Filters: React.FC<FiltersProps> = ({ filters, filter, disabled }) => {
    const filterWarnings = () => {
        filter('warning')
    }

    const filterSuccess = () => {
        filter('success')
    }

    const filterDanger = () => {
        filter('danger')
    }

    return (
        <View style={{ display: 'flex', flexDirection: 'row', justifyContent: 'center', width: '100%' }}>
            <View style={{ justifyContent: 'center' }}>
                <Text>Filtrer : </Text>
            </View>
            <Button
                disabled={disabled}
                style={{ margin: 2 }}
                size="small"
                appearance={filters.success ? 'filled' : 'ghost'}
                accessoryLeft={SuccessIcon}
                onPress={filterSuccess}
            />
            <Button
                disabled={disabled}
                style={{ margin: 2 }}
                size="small"
                appearance={filters.warning ? 'filled' : 'ghost'}
                accessoryLeft={WarningIcon}
                onPress={filterWarnings}
            />
            <Button
                disabled={disabled}
                style={{ margin: 2 }}
                size="small"
                appearance={filters.danger ? 'filled' : 'ghost'}
                accessoryLeft={DangerIcon}
                onPress={filterDanger}
            />
        </View>
    )
}

export default Filters
