export function Footer() {
    return (<>
        <footer className="text-muted">
            <div className="container">
                <div className="row">
                    <div className="col-sm">
                        <a href="https://meteo-du-numerique.ac-rennes.fr/politique-de-confidentialite"
                           target="_blank"
                           className="text-left text-secondary">Politique
                            de confidentialité</a>
                    </div>
                    <div className="col-sm">
                        <p className="text-center">&copy; Acad&eacute;mie de Rennes</p>
                    </div>
                    <div className="col-sm">
                        <p className="text-right">
                            <a href="#">Retour en haut de page</a>
                        </p>
                    </div>
                </div>
            </div>
            <div className="d-lg-none align-self-center"><img src="/images/logo_academie.jpg"/></div>
        </footer>
    </>)
}