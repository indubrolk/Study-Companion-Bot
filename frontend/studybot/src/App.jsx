import { useState } from 'react'
import { Routes, Route } from 'react-router-dom'
import './App.css'
import Navbar from './components/Navbar'
import Dashboard  from './components/Dashboard'
import About from './components/About'
import Home from './components/Home'
import Quiz from "./components/Quiz.jsx";
import Footer from './components/Footer.jsx'


function App() {
    const [count, setCount] = useState(0)

    return (
        <>

            
            <Navbar/>
            <Routes>

                <Route path='/' element={<Home/>} />
                <Route path="/home" element={<Home/>} />
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/about" element={<About />} />
                <Route path="/quiz" element={<Quiz/>} />
            </Routes>
            <Footer/>

        </>



    )

}

export default App