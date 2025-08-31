import React from "react";
import { NavLink } from "react-router-dom";

const Footer = () => {
  return (
    <footer className="bg-green-600 text-white py-4">
      <div className="container mx-auto px-4 flex flex-col sm:flex-row items-center justify-between">
        <p className="text-lg">&copy; {new Date().getFullYear()} Smart Study</p>
        <nav className="flex space-x-6 mt-2 sm:mt-0">
          <NavLink
            to="/home"
            className="hover:text-white text-lg"
          >
            Home
          </NavLink>
          <NavLink
            to="/about"
            className="hover:text-white text-lg"
          >
            About
          </NavLink>
          <NavLink
            to="/dashboard"
            className="hover:text-white text-lg"
          >
            Dashboard
          </NavLink>
        </nav>
      </div>
    </footer>
  );
};

export default Footer;
