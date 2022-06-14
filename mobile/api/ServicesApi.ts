import Service from '../domain/Service'
import useFetch, { FetchHook } from './fetch-utils'

const useServices = (): FetchHook<Service[]> => {
  return useFetch<Service[]>('/services')
}

export default useServices
