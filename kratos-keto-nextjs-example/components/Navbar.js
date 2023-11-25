import React from "react";
import { useRouter } from "next/router";
function Navbar({ logout }) {
  const router = useRouter();
  const handleClick = () => {
    router.push(logout);
  };
  return (
    <div className=" mx-auto flex bg-yellow-500 justify-between p-3">
      <div className="flex items-center text-2xl font-extrabold font-serif">
        <h1>ADMIN PAGE</h1>
      </div>
      <div>
        <button onClick={handleClick} className="bg-red-500 px-4 py-1 rounded-md">
          logout
        </button>
      </div>
    </div>
  );
}

export default Navbar;
