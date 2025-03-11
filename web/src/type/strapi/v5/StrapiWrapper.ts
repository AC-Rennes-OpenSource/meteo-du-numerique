import {EntityMetadata} from "./EntityMetadata.ts";
import {StrapiMeta} from "./StrapiMeta.ts";

export type StrapiWrapper<EntityType> = {
    documentId: string
} & EntityType & EntityMetadata


export type StrapiReturn<EntityType> = {
    data: StrapiWrapper<EntityType>[]
    meta: StrapiMeta
}

export type SingleStrapiReturn<EntityType> = {
    data: StrapiWrapper<EntityType>
}
