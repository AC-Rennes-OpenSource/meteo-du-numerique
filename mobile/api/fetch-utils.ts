import { useEffect, useState } from 'react'

import { apiSettings } from '../config/settings'

export interface FetchHook<T> {
    loading: boolean
    error: boolean
    data?: T
    refreshing: boolean
    refreshData: () => void
    reloadDataOnError: () => void
}

const useFetch = <T>(url: string): FetchHook<T> => {
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(false)
    const [data, setData] = useState<T>()
    const [refreshing, setRefreshing] = useState(false)
    const [shouldLoadData, setShouldLoadData] = useState(true)

    const refreshData = () => {
        setShouldLoadData(true)
        setRefreshing(true)
    }

    const reloadDataOnError = () => {
        setShouldLoadData(true)
    }

    useEffect(() => {
        const fetchData = async () => {
            if (shouldLoadData) {
                setLoading(true)
                setError(false)
                try {
                    const response = await fetch(`${apiSettings.url}${url}`)
                    const res = await response.json()
                    setData(res)
                } catch {
                    setError(true)
                } finally {
                    setLoading(false)
                    setShouldLoadData(false)
                    setRefreshing(false)
                }
            }
        }
        // eslint-disable-next-line @typescript-eslint/no-floating-promises
        fetchData()
    }, [url, shouldLoadData])

    return {
        loading,
        error,
        data,
        refreshing,
        reloadDataOnError,
        refreshData,
    }
}

export default useFetch
