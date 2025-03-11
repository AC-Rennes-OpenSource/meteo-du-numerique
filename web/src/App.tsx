import {MainPage} from "./page/MainPage.tsx";
import {QueryClient, QueryClientProvider} from "@tanstack/react-query";

function App() {

    const queryClient = new QueryClient({
        defaultOptions: {
            queries: {
                //refetchOnWindowFocus: false, // default: true
                retry: false,
            },
        },
    })


    return (
        <>
            <QueryClientProvider client={queryClient}>
                <MainPage/>
            </QueryClientProvider>
        </>
    )
}

export default App
