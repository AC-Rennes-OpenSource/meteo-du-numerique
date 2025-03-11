import {Service} from "../type/entity/Service.ts";

export function Header({services}: { services: Service [] }) {

    const latestUpdate = new Date(Math.max(...services.map((e) => new Date(e.updated_at).getTime())))

    return (<>
        <section className="text-center">
            <div className="container">
                <div className="row">
                    <div className="d-none d-lg-block col-lg-2 align-self-center">
                          <img src="/images/logo_academie.jpg" alt="Logo de l'académie de Rennes." aria-description="Logo de l'académie de Rennes."/>
                    </div>
                    <div className="col-lg-8 align-self-center">
                        <img src="/images/meteo-icon.png" style={{width: '96px'}} alt="Logo de la météo numérique."
                             aria-description="Logo de la météo numérique."/>
                        <h1>Météo du numérique</h1>
                        <p className="text-muted">
                            {"Retrouvez en continu la météo des principaux services numériques de l'académie."}
                        </p>
                        <p className="text-muted"></p>
                        {services && <div id="modification">
                            {"Dernière mise à jour : " + latestUpdate.toLocaleString('fr-fr')}
                            {/*    //todo fix latest update */}
                        </div>}
                        <p></p>
                    </div>
                    <div className="col-lg-2 align-self-left text-muted" style={{marginTop: '10px'}}>
                        <p className="text-muted">Application disponible sur Android et iOS<br/>
                            <img src="/images/qrcode.png" style={{width: "150px"}} alt="Qrcode pour accéder à l'application météo numérique"
                                 aria-description="Qrcode pour accéder à l'application météo numérique"/>
                        </p>
                    </div>
                </div>
            </div>
        </section>
    </>)
}