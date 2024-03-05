import { legacy_createStore as createStore } from "redux";

export interface Product {
    id: string;
    name: string;
}

export interface User {
    username: string;
}

export interface Message {
    text: string;
    type: "success" | "danger";
}

export interface Order {
    id: string;
    customer: string;
    dateTime: string;
}

export interface AppState {
    products: Product[];
    basket: Record<string, number>;
    user: User | null;
    message: Message | null;
    order: Order | null;
}

interface SetProductsAction {
    type: "set-products";
    data: Product[];
}

interface SetAuthenticated {
    type: "set-authenticated";
    data: User;
}

interface AddProductToBasket {
    type: "add-product-to-basket";
    productId: string;
    quantity: number;
}

interface ShowMessage {
    type: "show-message";
    message: Message;
}

interface HideMessage {
    type: "hide-message";
}

interface SetOrder {
    type: "set-order";
    data: Order;
}

interface ClearBasket {
    type: "clear-basket";
}

type Action =
    | SetProductsAction
    | SetAuthenticated
    | AddProductToBasket
    | ClearBasket
    | ShowMessage
    | HideMessage
    | SetOrder;

const defaultState: AppState = {
    products: [],
    user: null,
    message: null,
    basket: {},
    order: null,
};

function reducer(state = defaultState, action: Action): AppState {
    switch (action.type) {
        case "set-products":
            return { ...state, products: action.data };
        case "set-authenticated":
            return { ...state, user: action.data };
        case "add-product-to-basket":
            return {
                ...state,
                basket: {
                    ...state.basket,
                    [action.productId]: action.quantity,
                },
            };
        case "clear-basket":
            return { ...state, basket: {} };
        case "show-message":
            return { ...state, message: action.message };
        case "hide-message":
            return { ...state, message: null };
        case "set-order":
            return { ...state, order: action.data };
        default:
            return state;
    }
}

export const selectProducts = (state: AppState): Product[] => state.products;
export const selectUser = (state: AppState): User | null => state.user;
export const selectMessage = (state: AppState): Message | null => state.message;
export const selectBasket = (state: AppState): Record<string, number> =>
    state.basket;

const BASE_URL = process.env.REACT_APP_BASE_URL ?? "";

export const store = createStore(reducer);

const dispatch = store.dispatch.bind(store);

export function addProductToOrder(productId: string, quantity: number): void {
    dispatch({ type: "add-product-to-basket", productId, quantity });
}

export async function checkLoggedIn(): Promise<boolean> {
    try {
        const response = await fetch(`${BASE_URL}/api/v1/me`, {
            method: "GET",
            credentials: "include",
        });
        const data: User = await response.json();
        dispatch({ type: "set-authenticated", data });
        return true;
    } catch (e) {
        return false;
    }
}

export function hideMessage() {
    dispatch({ type: "hide-message" });
}

export async function showMessage(
    message: Message & { duration?: number }
): Promise<void> {
    dispatch({ type: "show-message", message });
    await new Promise((resolve) =>
        setTimeout(resolve, message.duration || 5000)
    );
    hideMessage();
}

export async function login(username: string, password: string): Promise<void> {
    try {
        const data = new FormData();
        data.append("username", username);
        data.append("password", password);
        await fetch(`${BASE_URL}/login`, {
            method: "POST",
            credentials: "include",
            body: data,
        });
        if (!(await checkLoggedIn())) {
            await showMessage({ text: "Unable to login!", type: "danger" });
        }
    } catch (e) {
        await showMessage({ text: "Error while logging in!", type: "danger" });
    }
}

export async function loadProducts(): Promise<void> {
    try {
        const response = await fetch(`${BASE_URL}/api/v1/products`, {
            method: "GET",
            credentials: "include",
        });
        const data = await response.json();
        dispatch({ type: "set-products", data });
    } catch (e) {
        await showMessage({ text: "Error retrieving products.", type: "danger" });
    }
}

export async function placeOrder(onSuccess = (order: Order) => {}): Promise<void> {
    try {
        const response = await fetch(`${BASE_URL}/api/v1/orders`, {
            method: "POST",
            credentials: "include",
            body: JSON.stringify(selectBasket(store.getState())),
            headers: {
                "Content-Type": "application/json"
            }
        });
        const data = await response.json();
        dispatch({ type: "set-order", data });
        onSuccess(data);
    } catch (e) {
        await showMessage({ text: "Error retrieving products.", type: "danger" });
    }
}

export async function loadOrder(id: string): Promise<void> {
    try {
        const response = await fetch(`${BASE_URL}/api/v1/orders/${id}`, {
            method: "GET",
            credentials: "include",
        });
        const data = await response.json();
        dispatch({ type: "set-order", data });
        dispatch({ type: "clear-basket" });
    } catch (e) {
        await showMessage({ text: "Error retrieving order.", type: "danger" });
    }
}
