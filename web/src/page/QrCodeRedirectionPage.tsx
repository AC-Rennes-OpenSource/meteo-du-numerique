import {urls} from "../api/Endpoints.ts";
import {useEffect} from "react";

export function QrCodeRedirectionPage() {
    useEffect(() => {
        const device = detectDevice()
        // noinspection UnnecessaryLocalVariableJS
        const urlApplicationStore = urls[device];
        window.location.href = urlApplicationStore
    }, []);


    return null
}

const detectDevice = () => {
    const userAgent = navigator.userAgent

    if (/android/i.test(userAgent)) {
        return "android";
    } else if (/iPad|iPhone|iPod/.test(userAgent)) {
        return "ios";
    } else {
        return "fallback";
    }
}