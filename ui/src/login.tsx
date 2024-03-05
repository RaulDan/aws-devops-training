import React, { useState, useCallback, FormEvent } from "react";
import { login } from "./store";

interface LoginProps {}

export const Login: React.FC<LoginProps> = () => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    const onLogin = useCallback(
        (e: FormEvent) => {
            login(username, password);
            e.preventDefault();
        },
        [username, password]
    );

    return (
        <form onSubmit={onLogin}>
            <h1 className="title">Login</h1>
            <div className="box">
                <div className="field">
                    <p className="control has-icons-left has-icons-right">
                        <input
                            className="input"
                            placeholder="Username"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                        />
                        <span className="icon is-small is-left">
                            <i className="fa fa-envelope"></i>
                        </span>
                    </p>
                </div>
                <div className="field">
                    <p className="control has-icons-left">
                        <input
                            className="input"
                            type="password"
                            placeholder="Password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                        <span className="icon is-small is-left">
                            <i className="fa fa-lock"></i>
                        </span>
                    </p>
                </div>
                <div className="field">
                    <p className="control">
                        <button className="button is-success" type="submit">
                            Login
                        </button>
                    </p>
                </div>
            </div>
        </form>
    );
};
