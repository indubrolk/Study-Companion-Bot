import React from 'react'
import Timer from './Timer'
import LearningAssistant from './ChatBot/ChatBot'
import Summary from './summary'


function Dashboard() {
  return (
    <div>
      <div className="grid h-56 grid-cols-2 content-start gap-4">
          <Timer/>
          <Summary/>
        </div>
        
      <LearningAssistant/>
    </div>
  )
}

export default Dashboard
