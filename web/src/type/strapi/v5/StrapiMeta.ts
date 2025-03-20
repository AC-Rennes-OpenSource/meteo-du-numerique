export type StrapiMeta = {
    pagination: StrapiPagination
}

export type StrapiPagination = {
    page: number
    pageCount: number
    pageSize: number
    total: number
}