import {ServiceStatusEntity} from "./ServiceStatusEntity.ts";
import {EntityMetadata} from "../strapi/v3/EntityMetadata.ts";

/**
 * Interface representing an academic service
 */
export interface Service extends EntityMetadata {
    libelle: string
    description?: string
    qualiteDeService: ServiceStatusEntity
}