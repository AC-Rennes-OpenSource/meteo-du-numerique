import {EntityMetadata} from "./EntityMetadata.ts";

export type NestedEntities<NestedEntityType> = NestedEntityData<NestedEntityType>[]

export type NestedEntityData<NestedEntityType> = {
    documentId: string
} & NestedEntityType & EntityMetadata
