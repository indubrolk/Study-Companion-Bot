import React from 'react'
import home from '../assets/Home.png'
import MyComponent from './typewriter'

function Home() {
  return (
    <div className='grid grid-cols-1 sm:grid-cols-2 place-items-center bg-gray-100'>
      <div className=''>
        <img src={home} alt="" className=' w-full h-auto object-cover block rounded-2xl m-4' />
      </div>
      <div className=''>
        <MyComponent/>
        </div>


    </div>
  )
}

export default Home