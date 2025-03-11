# La météo du numérique

## Fonctionnement de la partie web

L'intelligence ce situe dans le fichier /js/meteo-strapi.js
Il s'agit de récupérer le contenu créé dans le Headless CMS Strapi que celui expose via une API.
En cohérence avec le travail côté Strapi, nous sollicitons le endpoint /services puis nous bouclons
très simplement sur
les informations reçues et alimentons un DIV dans la partie HTML.
Pour chaque service nous recevons sa clé, son libellé, sa qualité de service et sa description.

Pour le côté cosmétique nous manipulons également quelques SVG dans le fichier javascript.

## Pour tester la redirection avec le qrcode

1. Installez http-server si ce n’est pas déjà fait :`npm install -g http-server`
2. Lancez le serveur HTTP : `http-server -p 8000`
3. Accédez à l’URL : http://localhost:8000/redirect.html
4. Dans la console du navigateur, simuler un appareil iOS ou Android