class ActionProvider {
  constructor(createChatBotMessage, setStateFunc) {
    this.createChatBotMessage = createChatBotMessage;
    this.setState = setStateFunc;
  }

  greet() {
    const message = this.createChatBotMessage("Hello! How can I assist you?");
    this.setState((prev) => ({ ...prev, messages: [...prev.messages, message] }));
  }
}

export default ActionProvider;
