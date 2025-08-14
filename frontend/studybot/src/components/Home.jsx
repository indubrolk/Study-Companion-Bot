import React from 'react'
import home from '../assets/Home.png'

function Home() {
  return (
    <div className='grid grid-cols-1 sm:grid-cols-2'>
      <div className=''>
        <img src={home} alt="" className='w-full h-auto object-cover block rounded-2xl m-4' />
      </div>
      <div className='bg-green-100 text-4xl rounded-2xl m-4 text-center'>Lets Study with us</div>

    </div>
  )
}

export default Home