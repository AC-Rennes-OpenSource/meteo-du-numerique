import {QueryClient, QueryClientProvider, useQuery} from "@tanstack/react-query";
import {createBrowserRouter, Outlet, RouterProvider} from "react-router-dom";
import {MainPage} from "./page/MainPage.tsx";
import {PrivacyPolicyPage} from "./page/PrivacyPolicyPage.tsx";
import {privacyPolicyPath} from "./util/PagesPaths.ts";
import {Header} from "./component/Header.tsx";
import {LATEST_UPDATE_ENDPOINT} from "./api/Endpoints.ts";
import {LatestUpdate} from "./type/strapi/v3/LatestUpdate.ts";
import {Footer} from "./component/Footer.tsx";
import {QrCodeRedirectionPage} from "./page/QrCodeRedirectionPage.tsx";


function App() {

    const queryClient = new QueryClient({
        defaultOptions: {
            queries: {
                //refetchOnWindowFocus: false, // default: true
                retry: false,
            },
        },
    })


    const router = createBrowserRouter([
        {
            Component() {
                const {data} = useQuery({
                    queryKey: ["latestUpdate"],
                    queryFn: (): Promise<LatestUpdate> =>
                        fetch(LATEST_UPDATE_ENDPOINT)
                            .then(response => response.json())
                            .then(value => value[0])
                })

                const latestUpdate = data ? new Date(data.updated_at) : undefined

                return (
                    <>
                        <Header latestUpdate={latestUpdate}/>
                        <Outlet/>
                        <Footer/>
                    </>
                );
            },
            children: [
                {
                    path: "/",
                    element: <MainPage/>,
                },
                {
                    path: privacyPolicyPath,
                    element: <PrivacyPolicyPage/>
                },
                {
                    path: "/mobile-app",
                    element: <QrCodeRedirectionPage/>
                }
            ]
        }
    ])


    return (
        <>
            <QueryClientProvider client={queryClient}>
                <RouterProvider router={router}/>
            </QueryClientProvider>
        </>
    )
}

export default App
