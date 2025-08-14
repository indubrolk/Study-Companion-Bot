import React from 'react'
import home from '../assets/Home.png'

function Home() {
  return (
    <div className='grid grid-cols-1 sm:grid-cols-2'>
      <div className=''>
        <img src={home} alt="" className='w-full h-auto object-cover block' />
      </div>
      <div className='bg-green-100'></div>

    </div>
  )
}

export default Home