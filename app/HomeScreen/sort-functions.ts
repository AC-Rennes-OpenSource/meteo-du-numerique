import { IndexPath } from '@ui-kitten/components'

import Service from '../../domain/Service'
import stripAccents from '../../utils/strip-accents'

export default  (sortIndex: IndexPath | undefined, a: Service, b: Service) => {
    switch (sortIndex?.row) {
        case 0:
            return alphabeticAscendingSort(a, b)
        case 1:
            return alphabeticDescendingSort(a, b)
        case 2:
            return stateAscendingSort(a, b)
        case 3:
            return stateDescendingSort(a, b)
        default:
            return alphabeticAscendingSort(a, b)
    }
}

const alphabeticAscendingSort = (a: Service, b: Service) => {
    const aLibelle = stripAccents(a.libelle)
    const bLibelle = stripAccents(b.libelle)
    if (aLibelle > bLibelle) return 1
    if (aLibelle < bLibelle) return -1
    return 0
}

const alphabeticDescendingSort = (a: Service, b: Service) => {
    const aLibelle = stripAccents(a.libelle)
    const bLibelle = stripAccents(b.libelle)
    if (aLibelle > bLibelle) return -1
    if (aLibelle < bLibelle) return 1
    return 0
}

const stateAscendingSort = (a: Service, b: Service) => {
    const aKey = a.qualiteDeService.key
    const bKey = b.qualiteDeService.key
    if (aKey > bKey) return 1
    if (aKey < bKey) return -1
    return alphabeticAscendingSort(a,b)
}

const stateDescendingSort = (a: Service, b: Service) => {
    const aKey = a.qualiteDeService.key
    const bKey = b.qualiteDeService.key
    if (aKey > bKey) return -1
    if (aKey < bKey) return 1
    return alphabeticAscendingSort(a,b)
}
