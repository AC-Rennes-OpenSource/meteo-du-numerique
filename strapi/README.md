# La météo du numérique
## Le gestionnaire de contenu
Nous avons fait le choix de Strapi pour trois raisons : 
* il est léger
* il est open source
* il est français

Vous trouverez la documentation d'installation sur leur site web : https://strapi.io/

## Le modèle de données
Nous n'avons besoin que de deux types de données : les services numériques et leur qualité de service.
Dans la partie Content Types Builder il faut créer les types suivants : 

__Service__
* libelle (Texte)
* description (Texte enrichi)
* qualiteDeService (Relation avec _Qualite de service_)

__Qualite de service__ 
* libelle (Texte)
* key (Number)
* services (Relation avec _Service_)

![Les types de données](/images/strapi-contenttype-service.png "Les types de données")


## Le peuplement
Dans la partie Collection Types, vous devrez saisir les informations qui seront alors disponibles via API.
strapi-collection-services.png
![Les collections](/images/strapi-collection-services.png "Les collections")