export function PrivacyPolicyPage() {

    return <div className="p-5">

        <div>
            <h1 className="pb-5 text-center">Politique de confidentialité de l'application mobile "Météo du
                numérique"</h1>
            <div className="text-wrapper">
                <p>Le présent document expose les principes et règles mis en œuvre par le rectorat de
                    l'académie de Bretage
                    en matière de collecte et de traitement des données lors de l’utilisation de
                    l’application Météo du
                    numérique
                </p>
            </div>

            <h3>1. Données personnelles et autres renseignements collectés</h3>
            <div className="text-wrapper">
                <p>Les données personnelles ou autres renseignements vous concernant que nous pouvons
                    collecter à partir de
                    l’Application font partie des différentes catégories exposées ci-après :</p>

                <p><strong><u>Données collectées automatiquement lors de l’utilisation de
                    l’Application</u></strong></p>

                <p>Lorsque vous utilisez l’Application, votre appareil mobile transfère automatiquement
                    diverses
                    informations techniques vers notre serveur, sans action de votre part.</p>

                <p>Ces informations sont nécessaires au fonctionnement correct de l’Application et vous
                    permettent d’accéder
                    aux services proposés.</p>

                <p>Plus précisément, les informations concernent les données suivantes :</p>

                <ul>
                    <li>Type et version de votre appareil mobile (iPhone 14, iOS 17.1…)</li>
                    <li>Numéro de version de l’Application</li>
                </ul>

                <p><strong><u>Cas spécifique "Firebase"</u></strong></p>

                <p>L’Application utilise "Firebase Services" qui est un service d’analyse
                    de Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Ireland.</p>

                <p><u>Firebase Cloud Messaging</u></p>

                <p>"Firebase Cloud Messaging" est utilisé pour transmettre des notifications-push ou des
                    messages dits
                    In-app (messages qui ne sont affichés que dans l’Application). Une référence Push
                    pseudonyme est
                    attribuée à l’appareil mobile, qui sert de cible pour les messages Push ou les
                    messages In-app. Vous
                    trouverez plus d’informations dans la section ‘Autorisation volontaire de
                    l’utilisateur : les
                    notifications-push" décrite ci-après.</p>

                <p>Pour plus d’informations sur la protection de la vie privée sur Google et Firebase,
                    se référer à <a
                        href="https://www.google.com/policies/privacy">https://www.google.com/policies/privacy</a>
                    et <a
                        href="https://firebase.google.com/support/privacy/">https://firebase.google.com/support/privacy/</a>.
                </p>
            </div>

            <h3>2. Autorisations de l’Application sur l’appareil mobile</h3>

            <div className="text-wrapper">
                <p><strong><u>Autorisation volontaire de l’utilisateur : les
                    notifications-push</u></strong></p>

                <p>L’Application peut vous proposer des notifications-push sur toute information en lien
                    avec la
                    disponibilité des services numériques de l'académie, y compris lorsque vous
                    n’utilisez pas activement
                    l’Application, sous réserve que vous les ayez
                    expressément activées. Ces notifications-push vous sont donc adressées sur la base
                    juridique de votre
                    consentement (art. 6-1-a et 7 du RGPD).</p>

                <p>Plus précisément, lorsque vous activez le service de notifications-push, votre
                    appareil reçoit un
                    Device-Token d’Apple ou un Registration-ID de Google qui sont des identifiants
                    correspondant uniquement
                    à des nombres cryptés générés au hasard.</p>

                <p>Nous utilisons ces identifiants uniquement pour vous fournir le service de
                    notification-push souhaité.
                    Sans le Device-Token d’Apple ou le Registration-ID de Google, il est impossible
                    techniquement de vous
                    envoyer des notifications-push.</p>

                <p><strong><u>Autorisations automatiques</u></strong></p>

                <p>Suite à l’installation de l’Application, celle-ci aura accès automatiquement aux
                    fonctionnalités de votre
                    appareil mobile suivantes :</p>

                <ul>
                    <li>Voir les connexions réseaux;</li>
                    <li>Accéder aux réseaux;</li>
                    <li>Recevoir des données via internet;</li>
                </ul>

                <p><strong><em>Version mise à jour au 13/11/2023.</em></strong></p>
            </div>

        </div>
    </div>
}