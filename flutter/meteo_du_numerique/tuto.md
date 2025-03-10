# Tutoriel Complet : Déployer une App Flutter avec Git, GitHub Actions, Fastlane et Match pour Débutants  
Ce tutoriel te guide pas à pas pour configurer un projet Flutter avec trois versions (prod, test, grosse feature),  
en utilisant Git, GitHub Actions avec un runner local, Fastlane pour automatiser les déploiements Android/iOS,  
et Match pour gérer les certificats iOS. Ton repo contient deux dossiers : `app/` (Flutter) et `backend/`.  
Tout est expliqué comme si tu découvrais chaque outil pour la première fois !

# Étape 1 : Préparer ton environnement local  
Avant de coder, il faut installer les outils nécessaires sur ta machine (Ubuntu ou macOS).  

## Sur ta machine  
- Installe Git : C’est pour gérer ton code.  
  Sur Ubuntu, ouvre un terminal (Ctrl + Alt + T) et tape :  
  `sudo apt update`  
  `sudo apt install git`  
  Sur macOS, installe Homebrew d’abord (si pas fait) avec :  
  `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`  
  Puis :  
  `brew install git`  
  Vérifie avec :  
  `git --version`  
  (Tu devrais voir quelque chose comme "git version 2.34.1").  

- Installe Flutter : Pour développer ton app.  
  Va sur [flutter.dev](https://flutter.dev/docs/get-started/install).  
  Sur Ubuntu :  
  `cd ~/Downloads`  
  `wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.0-stable.tar.xz`  
  `tar xf flutter_linux_3.19.0-stable.tar.xz -C ~/`  
  `export PATH="$PATH:~/flutter/bin"`  
  `echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.bashrc`  
  `source ~/.bashrc`  
  Sur macOS :  
  `cd ~/Downloads`  
  `curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.19.0-stable.zip`  
  `unzip flutter_macos_3.19.0-stable.zip -d ~/`  
  `export PATH="$PATH:~/flutter/bin"`  
  `echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.zshrc`  
  `source ~/.zshrc`  
  Vérifie avec :  
  `flutter doctor`  
  (Corrige les erreurs signalées, comme installer Android Studio si besoin).  

- Installe Android SDK : Pour Android.  
  Télécharge Android Studio depuis [developer.android.com](https://developer.android.com/studio).  
  Installe-le, ouvre-le, va dans **SDK Manager** (icône engrenage), télécharge API 33.  
  Ajoute au PATH sur Ubuntu :  
  `echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.bashrc`  
  `echo 'export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"' >> ~/.bashrc`  
  `source ~/.bashrc`  
  Sur macOS, fais pareil dans `~/.zshrc`.  

- Installe Xcode (macOS uniquement) : Pour iOS.  
  Ouvre l’App Store, cherche "Xcode", installe (ça prend 13 Go, sois patient).  
  Ensuite, installe les outils avec :  
  `xcode-select --install`  

- Installe Ruby : Pour Fastlane.  
  Sur Ubuntu :  
  `sudo apt install ruby-full`  
  Sur macOS :  
  `brew install ruby`  
  Vérifie avec :  
  `ruby -v`  
  (ex. "ruby 3.0.0").  

- Installe Fastlane : Pour automatiser les déploiements.  
  Tape :  
  `sudo gem install fastlane -NV`  
  `fastlane --version`  
  (ex. "fastlane 2.221.1").  

## Sur GitHub  
- Crée un repo :  
  Va sur [github.com](https://github.com), connecte-toi.  
  Clique **New repository**.  
  Nom : `mon-projet`, coche "Public" ou "Private", "Add a README", puis **Create**.  
- Clone localement :  
  Copie l’URL (ex. `https://github.com/ton-user/mon-projet.git`).  
  Dans le terminal :  
  `git clone https://github.com/ton-user/mon-projet.git`  
  `cd mon-projet`  
  `mkdir app backend`  

# Étape 2 : Configurer ton projet Flutter  
Ton app sera dans `app/`, avec trois versions (flavors).  
Crée l’app avec :  
`cd app`  
`flutter create .`  
Ajoute les flavors comme suit :  
- Android :  
  Ouvre `app/android/app/build.gradle` dans un éditeur (ex. VS Code), ajoute sous `android {` :  
  `flavorDimensions "app" productFlavors { prod { dimension "app" applicationId "com.monapp.prod" } test { dimension "app" applicationId "com.monapp.test" } bigfeature { dimension "app" applicationId "com.monapp.bigfeature" } }`  
- iOS (macOS) :  
  Ouvre `app/ios/Runner.xcworkspace` dans Xcode.  
  Clique sur "Runner" (en haut), **Manage Schemes**, duplique "Runner" en "prod", "test", "bigfeature".  
  Pour chaque scheme : **Edit Scheme > Build Configuration > Release**,  
  puis dans `Info.plist`, change `Bundle identifier` en `com.monapp.prod`, `.test`, `.bigfeature`.  
- Dart :  
  Crée `app/lib/flavor_config.dart` avec :  
  `enum Flavor { prod, test, bigfeature } class FlavorConfig { static Flavor flavor = Flavor.prod; static void init(String f) { flavor = f == "prod" ? Flavor.prod : f == "test" ? Flavor.test : Flavor.bigfeature; } }`  
  Modifie `app/lib/main.dart` avec :  
  `import 'package:flutter/material.dart'; import 'flavor_config.dart'; void main() { FlavorConfig.init(const String.fromEnvironment('FLAVOR')); runApp(MyApp()); } class MyApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( title: 'Mon App', home: Scaffold( body: Center(child: Text('Flavor: ${FlavorConfig.flavor}')), ), ); } }`  
- Ajoute au Git :  
  `git add app/`  
  `git commit -m "Ajout de l’app Flutter avec flavors"`  
  `git push origin main`  

# Étape 3 : Workflow Git  
Organise ton code avec des branches.  
Crée les branches avec :  
`git checkout -b develop`  
`git push origin develop`  
`git checkout -b feature/big-feature`  
`git push origin feature/big-feature`  
Explications :  
`main` est la version stable en prod,  
`develop` est la version test sans la grosse feature,  
`feature/big-feature` est pour la grosse feature en cours.  
Exemple pour une petite feature :  
`git checkout develop`  
`git checkout -b feature/login`  
`[modifie app/lib/main.dart]`  
`git add .`  
`git commit -m "Ajout login"`  
`git push origin feature/login`  
Tu fusionneras plus tard dans `develop`.  

# Étape 4 : Configurer GitHub Actions avec un Self-Hosted Runner  
Automatise les builds sur ta machine.  
Ajoute un runner :  
Sur GitHub, va dans **Settings > Actions > Runners > New self-hosted runner**,  
choisis ton OS (ex. Ubuntu), puis télécharge avec :  
`mkdir ~/actions-runner`  
`cd ~/actions-runner`  
`curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz`  
`tar xzf actions-runner-linux-x64-2.317.0.tar.gz`  
Configure avec :  
`./config.sh --url https://github.com/ton-user/mon-projet --token TON_TOKEN_ICI`  
(Remplace `TON_TOKEN_ICI` par le token donné par GitHub).  
Lance avec :  
`./run.sh`  
(Garde le terminal ouvert).  
Pour un service permanent (optionnel) :  
`sudo ./svc.sh install`  
`sudo ./svc.sh start`  
Crée le workflow :  
Crée `mon-projet/.github/workflows/flutter_build.yml` avec :  
`name: Flutter CI with Fastlane`  
`on:`  
`  push:`  
`    branches: [main, develop, feature/big-feature]`  
`    paths: ['app/**']`  
`jobs:`  
`  deploy:`  
`    runs-on: self-hosted`  
`    defaults:`  
`      run:`  
`        working-directory: app`  
`    steps:`  
`      - uses: actions/checkout@v3`  
`      - run: flutter test`  
`      - name: Deploy Android`  
`        run: |`  
`          cd android`  
`          if [ "${{ github.ref }}" = "refs/heads/main" ]; then`  
`            bundle exec fastlane deploy_prod`  
`          elif [ "${{ github.ref }}" = "refs/heads/develop" ]; then`  
`            bundle exec fastlane deploy_test`  
`          else`  
`            bundle exec fastlane deploy_bigfeature`  
`          fi`  
`      - name: Deploy iOS`  
`        if: runner.os == 'macOS'`  
`        run: |`  
`          cd ios`  
`          if [ "${{ github.ref }}" = "refs/heads/main" ]; then`  
`            bundle exec fastlane deploy_prod`  
`          elif [ "${{ github.ref }}" = "refs/heads/develop" ]; then`  
`            bundle exec fastlane deploy_test`  
`          else`  
`            bundle exec fastlane deploy_bigfeature`  
`          fi`  
Pousse avec :  
`git add .github/`  
`git commit -m "Ajout workflow GitHub Actions"`  
`git push origin main`  

# Étape 5 : Configurer Fastlane pour Android  
Automatise les déploiements Android.  
Initialise avec :  
`cd app/android`  
`fastlane init`  
(Choisis "manual" si demandé).  
Édite `app/android/fastlane/Fastfile` avec :  
`platform :android do`  
`  lane :deploy_prod do`  
`    flutter_build(flavor: "prod")`  
`    upload_to_play_store(`  
`      track: "production",`  
`      package_name: "com.monapp.prod",`  
`      aab: "../../build/app/outputs/bundle/prodRelease/app-prod-release.aab",`  
`      json_key: "~/secrets/play_store_key.json"`  
`    )`  
`  end`  
`  lane :deploy_test do`  
`    flutter_build(flavor: "test")`  
`    upload_to_play_store(`  
`      track: "internal",`  
`      package_name: "com.monapp.test",`  
`      aab: "../../build/app/outputs/bundle/testRelease/app-test-release.aab",`  
`      json_key: "~/secrets/play_store_key.json"`  
`    )`  
`  end`  
`  lane :deploy_bigfeature do`  
`    flutter_build(flavor: "bigfeature")`  
`    upload_to_play_store(`  
`      track: "internal",`  
`      package_name: "com.monapp.bigfeature",`  
`      aab: "../../build/app/outputs/bundle/bigfeatureRelease/app-bigfeature-release.aab",`  
`      json_key: "~/secrets/play_store_key.json"`  
`    )`  
`  end`  
`  private_lane :flutter_build do |options|`  
`    sh("cd ../.. && flutter pub get")`  
`    sh("cd ../.. && flutter build appbundle --flavor #{options[:flavor]}")`  
`  end`  
`end`  
Clé Play Store :  
Va dans **Google Play Console > Ton app > Configuration > Signature d’app**,  
crée un compte de service, télécharge `play_store_key.json`, place-le avec :  
`mkdir ~/secrets`  
`mv ~/Downloads/play_store_key.json ~/secrets/`  

# Étape 6 : Configurer Fastlane et Match pour iOS (macOS)  
Automatise iOS avec certificats.  
Initialise Fastlane avec :  
`cd app/ios`  
`fastlane init`  
Édite `app/ios/fastlane/Fastfile` avec :  
`platform :ios do`  
`  lane :deploy_prod do`  
`    match(type: "appstore", app_identifier: "com.monapp.prod")`  
`    flutter_build(flavor: "prod")`  
`    build_ios_app(scheme: "Runner", export_method: "app-store", output_directory: "../../build/ios")`  
`    upload_to_app_store(app_identifier: "com.monapp.prod")`  
`  end`  
`  lane :deploy_test do`  
`    match(type: "appstore", app_identifier: "com.monapp.test")`  
`    flutter_build(flavor: "test")`  
`    build_ios_app(scheme: "Runner", export_method: "app-store", output_directory: "../../build/ios")`  
`    upload_to_testflight(app_identifier: "com.monapp.test", skip_waiting_for_build_processing: true)`  
`  end`  
`  lane :deploy_bigfeature do`  
`    match(type: "appstore", app_identifier: "com.monapp.bigfeature")`  
`    flutter_build(flavor: "bigfeature")`  
`    build_ios_app(scheme: "Runner", export_method: "app-store", output_directory: "../../build/ios")`  
`    upload_to_testflight(app_identifier: "com.monapp.bigfeature", skip_waiting_for_build_processing: true)`  
`  end`  
`  private_lane :flutter_build do |options|`  
`    sh("cd ../.. && flutter pub get")`  
`    sh("cd ../.. && flutter build ios --flavor #{options[:flavor]} --no-codesign")`  
`  end`  
`end`  
Configure Match :  
Crée un repo privé `match-repo` sur GitHub.  
Initialise avec :  
`cd app/ios`  
`fastlane match init`  
Édite `app/ios/fastlane/Matchfile` avec :  
`git_url("https://github.com/ton-user/match-repo.git")`  
`app_identifier(["com.monapp.prod", "com.monapp.test", "com.monapp.bigfeature"])`  
`username("ton_email@exemple.com")`  
Récupère ton certificat existant :  
Ouvre **Keychain Access** (Spotlight : "Keychain"),  
cherche "Apple Distribution" ou "iPhone Distribution",  
clic droit > **Exporter**, sauvegarde en `~/secrets/distribution.p12`, mets un mot de passe (ex. "1234"),  
importe avec :  
`fastlane match import --certificate ~/secrets/distribution.p12`  
Si perdu :  
`fastlane match appstore`  
(Crée un nouveau certificat, note la passphrase).  
Secrets :  
Crée `app/ios/.env` avec :  
`MATCH_PASSWORD=ma_passphrase`  
`FASTLANE_USER=ton_email@exemple.com`  
`FASTLANE_PASSWORD=ton_mot_de_passe_app_specific`  
Génère un mot de passe app-specific sur [appleid.apple.com](https://appleid.apple.com) si besoin.  

# Étape 7 : Gérer les certificats existants  
Réutilise tes certificats actuels.  
Android :  
Cherche `monapp.jks` dans `app/android/` ou sur ton ancienne machine.  
Si trouvé :  
`cp chemin/vers/monapp.jks ~/secrets/`  
Crée `app/android/key.properties` avec :  
`storeFile=/home/user/secrets/monapp.jks`  
`storePassword=ton_mot_de_passe`  
`keyPassword=ton_mot_de_passe`  
`keyAlias=ton_alias`  
Si perdu + App Signing activé :  
`keytool -genkeypair -v -keystore ~/secrets/new-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`  
Puis soumets à Play Console (**Signature d’app > Demander une nouvelle clé**).  
iOS :  
Utilise le `.p12` importé dans Match pour `com.monapp.prod`.  

# Étape 8 : Tester ton setup  
Vérifie que tout fonctionne.  
Localement :  
Android avec :  
`cd app/android`  
`bundle exec fastlane deploy_test`  
iOS avec :  
`cd app/ios`  
`bundle exec fastlane deploy_test`  
GitHub Actions :  
Modifie `app/lib/main.dart` (ex. change le texte), fais :  
`git add .`  
`git commit -m "Test"`  
`git push origin develop`  
Va dans **Actions** sur GitHub, regarde le job "deploy".  

# Étape 9 : Sécuriser tes secrets  
Protège tes fichiers sensibles.  
Édite `.gitignore` (racine) avec :  
`app/android/key.properties`  
`app/ios/.env`  
`~/secrets/*`  
Vérifie avec :  
`git status`  
(Assure-toi que ces fichiers ne sont pas ajoutés).  

# Étape 10 : Générer un PDF  
Conserve ce tutoriel.  
Copie ce texte :  
Clique au début (# Tutoriel Complet), `Shift` + clic à la fin (# Étape 10), `Ctrl + C` / `Cmd + C`.  
Colle dans Google Docs :  
[docs.google.com](https://docs.google.com), **Nouveau**, `Ctrl + V` / `Cmd + V`.  
Exporte :  
**Fichier > Télécharger > PDF**, sauvegarde sur ton bureau.  

# Résultat final  
- Git : Trois branches (main, develop, feature/big-feature).  
- GitHub Actions : Builds automatisés sur ton runner.  
- Fastlane : Déploiements Android (Play Store) et iOS (App Store/TestFlight).  
- Match : Certificats iOS gérés et réutilisés.  
- Mono-repo : `app/` et `backend/` ensemble.  

Si une étape échoue, dis-le-moi, je t’aiderai en détail !