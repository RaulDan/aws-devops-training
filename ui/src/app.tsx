import React, { useEffect, useState } from "react";
import { RouterProvider } from "react-router-dom";
import { connect } from "react-redux";
import { AppState, checkLoggedIn, selectUser, User } from "./store";
import { getRouter } from "./router";
import { Login } from "./login";
import { Loader } from "./loader";

interface AppProps {
    user: User | null;
    onInit: () => void;
}

const App: React.FC<AppProps> = ({ user }) => {
    const [loaded, setLoaded] = useState(false);
    useEffect(() => {
        checkLoggedIn().then(() => setLoaded(true));
    }, [setLoaded]);
    if (!loaded) {
        return <Loader />;
    } else if (!user) {
        return <Login />;
    } else {
        return <RouterProvider router={getRouter()} />;
    }
};

const mapStateToProps = (state: AppState): AppProps => ({
    user: selectUser(state),
    onInit: checkLoggedIn,
});

export const AppContainer = connect(mapStateToProps)(App);
