import React from 'react'

const Navbar = () => {
   
  return (
   <nav className='bg-green-600'>
        <div className='h-16 items-center flex justify-between ' >
            <div className='text-3xl text-white font-semibold px-5 ml-4  '>Smart Study</div>
            <div className='hidden sm:block'>
                <a href="" className='text-purple-100 text-2xl px-4'>Home</a>
                <a href=""className='text-purple-100 text-2xl px-4'>Dashboard</a>
                <a href=""className='text-purple-100 text-2xl px-4 mr-4'>About</a>   
            </div>  
        </div>
         <div className='block sm:hidden bg-gray-300 py-4'>
                <a href="" className='text-black text-2xl px-4 block py-2 text-center'>Home</a>
                <a href=""className='text-black text-2xl px-4 block py-2 text-center'>Dashboard</a>
                <a href=""className='text-black text-2xl px-4 block py-2 text-center'>About</a>   
            </div>
   </nav>
  )
}

export default Navbar
