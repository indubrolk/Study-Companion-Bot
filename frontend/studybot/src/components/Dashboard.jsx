import React from 'react'
import Timer from './Timer'
import ChatBot from './ChatBot/ChatBot'
import Quiz from './Quiz'
import Summary from './summary'


function Dashboard() {
  return (
    <div>
      
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 content-start sm:h-56 h-auto">
      <Timer/>
      <Summary />
      <ChatBot/>
      <Quiz/>
      </div>
    </div>
  )
}

export default Dashboard
