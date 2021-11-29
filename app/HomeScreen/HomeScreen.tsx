import TopBar from 'app/TopBar'
import moment from 'moment'
import React, { useEffect, useState } from 'react'
import { FlatList, RefreshControl, SafeAreaView, StatusBar, View } from 'react-native'

import { Divider, IndexPath, Layout, Select, SelectItem, Spinner, Text, useTheme } from '@ui-kitten/components'

import useServices from '../../api/ServicesApi'
import IFilters from '../../domain/Filters'
import Service from '../../domain/Service'
import Error from '../Error'
import Filters from '../Filters'
import ServiceCard from '../ServiceCard'
import sortServices from './sort-functions'

const selectData = ['Alphabétique croissant', 'Alphabétique décroissant', 'État croissant', 'État décroissant']

const HomeScreen: React.FC = () => {
    const theme = useTheme()
    const [selectedSortIndex, setSelectedSortIndex] = useState<IndexPath>(new IndexPath(3))

    const { data, loading, error, refreshing, reloadDataOnError, refreshData } = useServices()
    const [filteredData, setFilteredData] = useState(data)
    const lastUpdatedDate = data ? new Date(Math.max(...data.map((e) => new Date(e.updated_at).getTime()))) : null
    const [filters, setFilters] = useState<IFilters>({
        success: true,
        warning: true,
        danger: true,
    })
    const renderItem = ({ item }: { item: Service }) => <ServiceCard service={item} />

    useEffect(() => {
        setFilteredData([...(filteredData ? filteredData : []).sort((a, b) => sortServices(selectedSortIndex, a, b))])

    }, [selectedSortIndex])

    const filterServices = (service: Service) =>
        (service.qualiteDeService.key === 1 && filters.success) ||
        (service.qualiteDeService.key === 2 && filters.warning) ||
        (service.qualiteDeService.key === 3 && filters.danger)

    useEffect(() => {
        setFilteredData(
            [...(data ? data : [])].filter(filterServices).sort((a, b) => sortServices(selectedSortIndex, a, b))
        )
    }, [filters])

    const filter = (value: 'warning' | 'success' | 'danger') => {
        setFilters((prevFilters) => ({ ...prevFilters, [value]: !prevFilters[value] }))
    }

    useEffect(() => {
        setFilteredData(
            [...(data ? data : [])].filter(filterServices).sort((a, b) => sortServices(selectedSortIndex, a, b))
        )
    }, [data])

    return (
        <SafeAreaView style={{height: '100%', backgroundColor: theme['color-basic-800']}}>
            <Layout style={{ height: '100%', flexDirection: 'column', flex: 1 }}>
                <StatusBar  animated={true} backgroundColor={theme['color-basic-900']} barStyle="light-content" />
                <TopBar />
                <Divider />
                {lastUpdatedDate !== null && (
                    <Text style={{ textAlign: 'center', backgroundColor: 'white', color: theme['color-basic-900'] }}>
                        Dernière mise à jour : {moment(lastUpdatedDate).format('DD/MM/YYYY à HH:mm')}
                    </Text>
                )}
                <View style={{ alignItems: 'center', margin: 10, height: '100%', flex: 1 }}>
                    <View style={{ marginTop: 10, marginBottom: 10 }}>
                        <Text style={{ textAlign: 'center' }}>
                            Retrouvez en continu la météo des principaux services numériques de l'académie.
                        </Text>
                    </View>
                    <Layout level="1" style={{ flexDirection: 'row', marginBottom: 5 }}>
                        <Select
                            disabled={refreshing}
                            style={{ flex: 1, marginHorizontal: 2 }}
                            selectedIndex={selectedSortIndex}
                            label="Trier"
                            placeholder="Choisir une option"
                            size="small"
                            value={selectedSortIndex && selectData[selectedSortIndex.row]}
                            onSelect={(index) => setSelectedSortIndex(index as IndexPath)}
                        >
                            {selectData.map((title, index) => (
                                <SelectItem title={title} key={index} />
                            ))}
                        </Select>
                    </Layout>
                    <Filters filters={filters} filter={filter} disabled={refreshing} />
                    <View style={{ flex: 1, width: '100%' }}>
                        {loading && !refreshing ? (
                            <View style={{ display: 'flex', flexDirection: 'row', marginTop: 20, justifyContent: 'center' }}>
                                <Text style={{ marginRight: 10 }}>Chargement des services</Text>
                                <Spinner />
                            </View>
                        ) : error ? (
                            <Error
                                message="Une erreur est survenue lors de la récupération des données"
                                reload={reloadDataOnError}
                            />
                        ) : (
                            <FlatList
                                data={filteredData}
                                renderItem={renderItem}
                                keyExtractor={(item) => item.id.toString()}
                                refreshControl={
                                    <RefreshControl
                                        refreshing={refreshing}
                                        onRefresh={refreshData}
                                        colors={[theme['color-primary-500']]}
                                    />
                                }
                                style={{
                                    backgroundColor: refreshing ? 'black' : 'transparent',
                                    opacity: refreshing ? 0.5 : 1,
                                }}
                            />
                        )}
                    </View>
                </View>
            </Layout>
        </SafeAreaView>
    )
}

export default HomeScreen
