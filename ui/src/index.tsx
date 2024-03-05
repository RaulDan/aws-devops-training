import React from "react";
import ReactDOM from "react-dom/client";
import reportWebVitals from "./reportWebVitals";
import { Provider } from "react-redux";
import { store } from "./store";
import { AppContainer } from "./app";

import "./index.css";
import "bulma/css/bulma.min.css";
import "font-awesome/css/font-awesome.min.css";
import { MessageContainer } from "./message";

const root = ReactDOM.createRoot(document.getElementById("root")!);
root.render(
    <section className="section">
        <div className="container">
            <React.StrictMode>
                <Provider store={store}>
                    <AppContainer />
                    <MessageContainer />
                </Provider>
            </React.StrictMode>
        </div>
    </section>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
