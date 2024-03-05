import React from "react";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import { AppState, Order } from "./store";

interface OrderProps {
    order: Order | null;
}

const OrderInner: React.FC<OrderProps> = ({ order }) => (
    <>
        <h1 className="title">Order</h1>
        <div className="box">
            <p>
                <strong>Order ID: </strong>
                {order?.id ?? "unknown"}
            </p>
            <p>
                <strong>Customer: </strong>
                {order?.customer ?? "unknown"}
            </p>
            <p>
                <strong>Date: </strong>
                {order?.dateTime ?? "unknown"}
            </p>
        </div>
        <div className="has-text-right">
            <Link to="/" className="button is-primary">
                Place another order!
            </Link>
        </div>
    </>
);

function mapStateToProps(state: AppState): OrderProps {
    return {
        order: state.order,
    };
}

export const OrderContainer = connect(mapStateToProps)(OrderInner);
