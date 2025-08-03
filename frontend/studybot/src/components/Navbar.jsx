import React, { useState } from 'react'
import { CiMenuBurger } from "react-icons/ci";

const Navbar = () => {
   const [isOpen, setIsOpen] = useState(false)
  return (
   <nav className='bg-purple-950'>
        <div className='h-16 items-center flex justify-between ' >
            <div className='text-3xl text-white font-semibold px-5 ml-4  '>Smart Study</div>
            <div className='hidden sm:block'>
                <a href="" className='text-purple-100 text-2xl px-4 hover:text-emerald-900 hover:font-bold '>Home</a>
                <a href=""className='text-purple-100 text-2xl px-4 hover:text-emerald-900 hover:font-bold'>Dashboard</a>
                <a href=""className='text-purple-100 text-2xl px-4 mr-2 hover:text-emerald-900 hover:font-bold'>About</a>   
            </div> 
            <button onClick={() => setIsOpen(!isOpen)} className='block sm:hidden pr-4 text-white text-2xl hover:text-green-900 '><CiMenuBurger /></button>
        </div>
        
         <div className={`${isOpen ? "block" : "hidden"} sm:hidden bg-gray-300 py-4`}>
            <a href="" className='text-black text-2xl px-4 block py-2 text-center hover:text-white'>Home</a>
            <a href=""className='text-black text-2xl px-4 block py-2 text-center hover:text-white '>Dashboard</a>
            <a href=""className='text-black text-2xl px-4 block py-2 text-center hover:text-white '>About</a>   
        </div>
   </nav>
  )
}

export default Navbar
