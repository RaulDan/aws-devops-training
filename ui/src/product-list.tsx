import React from "react";
import { connect } from "react-redux";
import { useNavigate, NavigateFunction } from "react-router-dom";
import {
    addProductToOrder,
    AppState,
    placeOrder,
    Product,
    selectBasket,
    selectProducts,
} from "./store";

interface ProductListProps {
    products: Product[];
    basket: Record<string, number>;
    onAddProduct: (product: string, quantity: number) => void;
    onPlaceOrder: (navigate: NavigateFunction) => void;
}

const ProductList: React.FC<ProductListProps> = ({
    products,
    basket,
    onAddProduct,
    onPlaceOrder,
}) => {
    const navigate = useNavigate();
    return (
        <div>
            <h1 className="title">Place an order</h1>
            {products
                .slice()
                .sort((a, b) => a.name.localeCompare(b.name))
                .map((product) => (
                    <div className="box" key={product.id}>
                        <article className="media">
                            <div className="media-left">
                                <input
                                    className="input is-primary"
                                    type="number"
                                    style={{ width: "100px" }}
                                    value={basket[product.id] || "0"}
                                    onChange={(e) =>
                                        onAddProduct(
                                            product.id,
                                            +e.target.value
                                        )
                                    }
                                />
                            </div>
                            <div className="media-content">
                                <div className="content">
                                    <strong>{product.name}</strong>
                                </div>
                            </div>
                        </article>
                    </div>
                ))}
            <div className="has-text-right">
                <button
                    className="button is-primary"
                    onClick={() => onPlaceOrder(navigate)}
                >
                    Place Order!
                </button>
            </div>
        </div>
    );
};

function mapStateToProps(state: AppState): ProductListProps {
    return {
        products: selectProducts(state),
        basket: selectBasket(state),
        onAddProduct: addProductToOrder,
        onPlaceOrder: (navigate) =>
            placeOrder((order) => navigate(`/orders/${order.id}`)),
    };
}

export const ProductContainer = connect(mapStateToProps)(ProductList);
