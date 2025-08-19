import React, { useState } from 'react'
import { CiMenuBurger } from "react-icons/ci";
import { Link } from 'react-router-dom';
import Home from  './Home'

const Navbar = () => {
   const [isOpen, setIsOpen] = useState(false)
  return (

    <>
        <nav className='bg-green-600'>
            
                <div className='h-16 items-center flex justify-between ' >
                    <div className='text-3xl text-white font-semibold px-5 ml-4  '>
                        <h2>Smart Study</h2>
                    </div>
                    <div className='hidden sm:block'>
                        <Link to="/home" className='text-purple-100 text-2xl px-4 hover:text-emerald-900 hover:font-bold '>Home</Link>
                        <Link to="/dashboard" className='text-purple-100 text-2xl px-4 hover:text-emerald-900 hover:font-bold'>Dashboard</Link>
                        <Link to="/about" className='text-purple-100 text-2xl px-4 mr-2 hover:text-emerald-900 hover:font-bold'>About</Link>   
                    </div> 
                    <button onClick={() => setIsOpen(!isOpen)} className='block sm:hidden pr-4 text-white text-2xl hover:text-green-900 '><CiMenuBurger /></button>
                </div>
                
                <div className={`${isOpen ? "block" : "hidden"} sm:hidden bg-gray-300 py-4`}>
                    <Link to="/home" className='text-black text-2xl px-4 block py-2 text-center hover:text-white'>Home</Link>
                    <Link to="/dashboard" className='text-black text-2xl px-4 block py-2 text-center hover:text-white '>Dashboard</Link>
                    <Link to="/about" className='text-black text-2xl px-4 block py-2 text-center hover:text-white '>About</Link>   
                </div>
        </nav>

    </>
   
  )
}

export default Navbar
