export const API_SERVICES_ENDPOINT = 'https://www.toutatice.fr/strapi/services';
export const LATEST_UPDATE_ENDPOINT = 'https://www.toutatice.fr/strapi/services?_sort=updated_at:DESC&_limit=1';

// URLs des stores
export const urls = {
    android: "https://play.google.com/store/apps/details?id=fr.acrennes.meteo_du_numerique",
    ios: "https://apps.apple.com/fr/app/m%C3%A9t%C3%A9o-du-num%C3%A9rique/id6738698333",
    fallback: "/" // URL pour les non-mobiles
}