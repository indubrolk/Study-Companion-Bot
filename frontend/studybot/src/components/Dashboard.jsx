import React from 'react'
import Timer from './Timer'

function Dashboard() {
  return (
      <div className="flex h-56 grid-cols-3 content-start gap-4">
    <Timer/>
      </div>

  )
}

export default Dashboard