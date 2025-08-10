import React from 'react'
import ChatbotComponent from './ChatBot/ChatBot'
import Timer from './Timer'
import Summary from './summary'

function Dashboard() {
  return (
    <div>
      <ChatbotComponent/>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 content-start sm:h-56 h-auto">
      <Timer/>
      <Summary/>
      </div>
    </div>
    
    )
}


export default Dashboard
