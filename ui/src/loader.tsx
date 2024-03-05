import React from "react";

export const Loader: React.FC = () => (
    <div className="has-text-centered">
        <button className="button is-loading is-large" disabled>
            Loading
        </button>
    </div>
);
