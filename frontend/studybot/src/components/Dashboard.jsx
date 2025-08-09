import React from 'react'
import Timer from './Timer'
import LearningAssistant from './ChatBot/ChatBot'

function Dashboard() {
  return (
    <div>
      <div className="grid h-56 grid-cols-3 content-start gap-4">
      <Timer/>
      <LearningAssistant/>
      </div>
    </div>
    
    )
}


export default Dashboard