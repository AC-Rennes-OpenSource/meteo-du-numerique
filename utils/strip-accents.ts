const stripAccents = (value: string) => value.normalize("NFD").replace(/[\u0300-\u036f]/g, "")

export default stripAccents
