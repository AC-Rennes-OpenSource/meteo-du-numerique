import {Service} from "../type/entity/Service.ts";
import {useQuery} from "@tanstack/react-query";
import {ServiceCard} from "../component/ServiceCard.tsx";
import {API_SERVICES_ENDPOINT} from "../api/Endpoints.ts";


export function MainPage() {

    const {isLoading, data} = useQuery({
        queryKey: ["services"],
        queryFn: (): Promise<Service[]> =>
            fetch(API_SERVICES_ENDPOINT)
                .then(response => response.json()),
        refetchOnWindowFocus: true,
        refetchInterval: 10_000 // 10 seconds
    });

    if (isLoading) {
        return null //todo
    }


    const services = (data ?? [])
        .sort((a, b) => a.libelle.localeCompare(b.libelle))
        .sort((a, b) => b.qualiteDeService.key - a.qualiteDeService.key)


    return (
        <>
            <div id="meteo-inner" className="row" style={{margin: "0px"}}>
                {services.map(service =>
                    <ServiceCard key={service.id} service={service}/>
                )}
            </div>
        </>
    )

}