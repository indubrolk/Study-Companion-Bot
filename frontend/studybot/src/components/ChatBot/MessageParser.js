class MessageParser {
  constructor(actionProvider) {
    this.actionProvider = actionProvider;
  }

  parse(message) {
    if (message.includes('hello')) {
      this.actionProvider.greet();
    }
  }
}

export default MessageParser;
