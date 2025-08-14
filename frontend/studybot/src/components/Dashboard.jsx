import React from 'react'
import Timer from './Timer'
import LearningAssistant from './ChatBot/ChatBot'
import Summary from './summary'


function Dashboard() {
  return (
    <div>
      <div className="grid  h-100% sm:grid-cols-2 content-start gap-4 bg-gradient-to-br from-blue-50 to-indigo-100">
      <Timer/>
      <Summary />
      </div>
    </div>
  )
}

export default Dashboard
