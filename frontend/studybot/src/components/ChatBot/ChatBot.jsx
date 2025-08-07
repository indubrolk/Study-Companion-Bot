import React, { useState } from 'react';
import { FaRobot } from 'react-icons/fa';
import Chatbot from 'react-chatbot-kit';
import 'react-chatbot-kit/build/main.css';
import config from './chatbotConfig';
import MessageParser from './MessageParser';
import ActionProvider from './ActionProvider';

function ChatbotComponent() {
  const [showChatbot, setShowChatbot] = useState(false);

  const toggleChatbot = () => {
    setShowChatbot(!showChatbot);
  };

  return (
    <div>
      <FaRobot size={40} style={{ cursor: 'pointer', position:'absolute',right:'20px', bottom:'20px'}} onClick={toggleChatbot} />
      {showChatbot && (
        <div style={{ position: 'fixed', bottom: '20px', right: '80px', zIndex: 1000 }}>
          <Chatbot 
            config={config} 
            messageParser={MessageParser} 
            actionProvider={ActionProvider} 
          />
        </div>
      )}
    </div>
  );
}

export default ChatbotComponent;
