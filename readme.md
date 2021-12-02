Météo du numérique
-----

Ce dépôt contient les sources de l'application Météo du numérique actuellement déployée sur le [Google Play store](https://play.google.com/store/apps/details?id=com.meteodunumerique&gl=FR).

Pour lancer l'application vous aurez besoin de rajouter les fichiers :
* `gradle.properties` dans le dossier `android`
* `google-services.json` et `my-upload-key.keystore` dans le dossier `android/app`

Pour lancer l'image docker permettant de mocker l'API de production :
* Lancer la commande `docker-compose -f docker/meteo-du-numerique.yml up -d`

Dans le fichier `envs/local.json` changer l'adresse IP par la votre pour que l'émulateur ai accès à l'API json-server.

Ensuite, lancer la commande `yarn install` ou `npm install` pour installer les dépendances dans le dossier `node_modules`. Puis lancer la commande `yarn android` ou `npm run android` qui va démarrer votre émulateur en installant l'application sur ce dernier et lancer la commande `yarn start-dev`.