import React from 'react';
import Typewriter from 'typewriter-effect';

const MyComponent = () => {
  return (
    <div className="bg-green-100 text-6xl rounded-2xl p-4 text-center">
      <Typewriter
        options={{
          strings: ['Lets Study Together...'],
          autoStart: true,
          loop: true,
        }}
      />
    </div>
  );
};

export default MyComponent;
