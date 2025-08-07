import React from 'react'
import ChatbotComponent from './ChatBot/ChatBot'
import Timer from './Timer'

function Dashboard() {
  return (
    <div>
      <ChatbotComponent/>
      <div className="grid h-56 grid-cols-3 content-start gap-4">
      <Timer/>
      </div>
    </div>
    
    )
}


export default Dashboard
