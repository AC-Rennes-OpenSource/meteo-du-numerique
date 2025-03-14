import {Link} from "react-router-dom";
import {privacyPolicyPath} from "../util/PagesPaths.ts";

export function Footer() {

    return (<>
        <footer className="text-muted">
            <div className="container">
                <div className="row">
                    <div className="col-sm">
                        <Link className="text-left text-secondary" to={privacyPolicyPath}>
                            Politique de confidentialité
                        </Link>
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
            <div className="d-lg-none align-self-center"><img src="/images/logo_academie.jpg" alt="Logo de l'académie de Rennes."
                                                              aria-description="Logo de l'académie de Rennes."/></div>
        </footer>
    </>)
}