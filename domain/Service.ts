import QualiteDeService from './QualiteDeService'

export default interface Service {
    id: number
    libelle: string
    description: string
    qualiteDeService: QualiteDeService
    // eslint-disable-next-line camelcase
    updated_at: string
}
