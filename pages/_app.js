import "../styles/globals.css";

import original from "react95/dist/themes/original";
import { ThemeProvider } from "styled-components";

function MyApp({ Component, pageProps }) {
  return (
    <ThemeProvider theme={original}>
        <Component {...pageProps} />
    </ThemeProvider>
  );
}

export default MyApp;
