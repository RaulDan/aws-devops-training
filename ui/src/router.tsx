import { createBrowserRouter } from "react-router-dom";
import { OrderContainer } from "./order";
import { ProductContainer } from "./product-list";
import { loadOrder, loadProducts } from "./store";

let router: any = undefined;

export const getRouter = () => {
    if (router) {
        return router;
    } else {
        router = createBrowserRouter([
            {
                path: "/",
                element: <ProductContainer />,
                loader: async () => {
                    await loadProducts();
                    return null;
                },
            },
            {
                path: "/orders/:id",
                element: <OrderContainer />,
                loader: async ({ params }) => {
                    await loadOrder(params.id!);
                    return null;
                },
            },
        ]);
        return router;
    }
};
