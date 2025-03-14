import {EntityMetadata} from "../strapi/v3/EntityMetadata.ts";

export interface ServiceStatusEntity extends EntityMetadata {
    libelle: "Fonctionnement habituel" | "Perturbations" | "Dysfonctionnement bloquant"
    key: 1 | 2 | 3
}