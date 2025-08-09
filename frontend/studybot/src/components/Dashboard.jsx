import React from 'react'
import Timer from './Timer'
import LearningAssistant from './ChatBot/ChatBot'
import Summary from './summary'


function Dashboard() {
  return (
    <div>
      <div className="grid h-56 grid-cols-3 content-start gap-4">
          <Timer/>
          <LearningAssistant/>
       </div>
          <div className="grid h-56 w-auto grid-cols-2 content-start gap-4">
            <Summary/>
          </div>
    </div>
  )
}

export default Dashboard
