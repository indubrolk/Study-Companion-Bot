import React from 'react'
import ChatbotComponent from './ChatBot/ChatBot'
import Timer from './Timer'
import Summary from './summary'

function Dashboard() {
  return (
    <div>
      <ChatbotComponent/>
      <div className="grid h-56 w-auto grid-cols-2 content-start gap-4">
      <Timer/>
      <Summary />
      </div>
    </div>
    
    )
}


export default Dashboard
