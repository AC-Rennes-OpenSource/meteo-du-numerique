import {ServiceStatusEntity} from "../../type/entity/ServiceStatusEntity.ts";
import AsUsualStatusIcon from "./svg/as_usual_status_icon.svg?react";
import PerturbationsStatusIcon from "./svg/perturbations_status_icon.svg?react";
import BlockedStatusIcon from "./svg/blocked_status_icon.svg?react";
import UnknownStatusIcon from "./svg/default_status_icon.svg?react";


export function ServiceStatus({serviceStatus}: { serviceStatus: ServiceStatusEntity }) {
    switch (serviceStatus.libelle) {
        case "Fonctionnement habituel":
            return <AsUsualStatusIcon/>;
        case "Perturbations":
            return <PerturbationsStatusIcon/>;
        case "Dysfonctionnement bloquant":
            return <BlockedStatusIcon/>;
        default:
            return <UnknownStatusIcon/>;
    }
}