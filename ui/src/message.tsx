import React from "react";
import { connect } from "react-redux";
import { AppState, hideMessage, Message, selectMessage } from "./store";

interface MessageProps {
    message: Message | null;
    onDismiss: () => void;
}

const MessageInner: React.FC<MessageProps> = ({ message, onDismiss }) => (
    <div
        className={
            "message-container notification " +
            (message ? "active " : "") +
            (message?.type ? "is-" + message.type : "")
        }
    >
        <button className="delete" onClick={onDismiss} />
        {message?.text ?? ""}
    </div>
);

function mapStateToProps(state: AppState): MessageProps {
    return {
        message: selectMessage(state),
        onDismiss: hideMessage,
    };
}

export const MessageContainer = connect(mapStateToProps)(MessageInner);
