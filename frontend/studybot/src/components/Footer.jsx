// Footer.jsx
export default function Footer() {
  return (
    <footer className="bg-green-600 text-white py-6 mt-10">
      <div className="max-w-7xl mx-auto px-4 flex flex-col md:flex-row justify-between items-center">
        
      
        <div className="text-lg font-bold">Smart Study</div>

      
        <div className="flex space-x-6 my-4 md:my-0">
          <a href="/home" className="hover:text-gray-200">Home</a>
          <a href="/dashboard" className="hover:text-gray-200">Dashboard</a>
          <a href="/about" className="hover:text-gray-200">About</a>
        </div>

       
        <div className="text-sm">
          © {new Date().getFullYear()} Smart Study. All rights reserved.
        </div>
      </div>
    </footer>
  );
}
