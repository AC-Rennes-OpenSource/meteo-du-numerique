import {Service} from "../type/entity/Service.ts";
import {ServiceStatus} from "./status/ServiceStatus.tsx";
import Markdown from 'marked-react';
import "./Tuile.css"

export function ServiceCard({service}: { service: Service }) {
    const serviceQualityKey = service.qualiteDeService.key;

    return (
        <>
            <div className="col-lg-3">
                <div className={`tuile tuile-${serviceQualityKey} h-100`}>
                    <div className={`tuile-inner-${serviceQualityKey} h-100`}>
                        <div className="row">
                            <div className="col-md-12 text-center">
                                <ServiceStatus serviceStatus={service.qualiteDeService}/>
                            </div>
                        </div>

                        <div className="row">
                            <div className="col-md-12 text-center">
                                <h3>{service.libelle}</h3>
                            </div>
                        </div>

                        <div className="row">
                            <div className={`col-md-12 text-center tuile-qos-${serviceQualityKey}`}>
                                <span>{service.qualiteDeService.libelle}</span>
                            </div>
                        </div>

                        <div className="row">
                            <div className="col-md-12">
                                <div className="card-text">
                                    <Markdown>
                                        {
                                            service.description ?? ""
                                        }
                                    </Markdown>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}