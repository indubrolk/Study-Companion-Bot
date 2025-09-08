import React from "react";
import { NavLink } from "react-router-dom";

const Footer = () => {
  return (
    <footer className="bg-gradient-to-r from-green-500 via-emerald-600 to-green-700 text-white py-8 mt-10 shadow-lg">
      <div className="max-w-7xl mx-auto px-4 flex flex-col md:flex-row justify-between items-center gap-4">
        <div className="flex items-center gap-2">
          <svg
            className="w-8 h-8 text-white"
            fill="none"
            stroke="currentColor"
            strokeWidth={2}
            viewBox="0 0 24 24"
          >
            <path
              d="M12 4v16m8-8H4"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          <span className="text-2xl font-extrabold tracking-wide drop-shadow">
            Smart Study
          </span>
        </div>
        <nav className="flex gap-6 mt-4 md:mt-0">
          <NavLink
            to="/"
            className="hover:text-yellow-300 transition-colors duration-200"
          >
            Home
          </NavLink>
          <NavLink
            to="/dashboard"
            className="hover:text-yellow-300 transition-colors duration-200"
          >
            Dashboard
          </NavLink>
          <NavLink
            to="/about"
            className="hover:text-yellow-300 transition-colors duration-200"
          >
            About
          </NavLink>
        </nav>
        <div className="text-xs text-gray-100 mt-4 md:mt-0">
          © {new Date().getFullYear()} <span className="font-semibold">Smart Study</span>. All rights reserved.
        </div>
      </div>
    </footer>
  );
};

export default Footer;
