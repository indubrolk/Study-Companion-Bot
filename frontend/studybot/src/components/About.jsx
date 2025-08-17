import React, { useEffect, useState } from 'react';

const About = () => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    // Trigger animation when component mounts
    setTimeout(() => setVisible(true), 100);
  }, []);

  return (
    <div style={styles.container}>
      <div
        style={{
          ...styles.content,
          opacity: visible ? 1 : 0,
          transform: visible ? 'translateY(0)' : 'translateY(20px)',
          transition: 'all 0.8s ease-out',
        }}
      >
        <h1 style={styles.heading}>About <span style={styles.gradientText}>Smart Study</span></h1>

        <p style={styles.paragraph}>
          <strong>Smart Study</strong> is your modern, all-in-one learning assistant. It helps students stay organized, track their study progress, and manage tasks efficiently.
        </p>

        <p style={styles.paragraph}>
          Built with the speed of <strong>Vite</strong> and the power of <strong>React</strong>, our platform is designed for performance, simplicity, and productivity.
        </p>

        <p style={styles.paragraph}>
          Whether you're studying for school, college, or competitive exams, <strong>Smart Study</strong> empowers you to learn smarter, not harder.
        </p>
      </div>
    </div>
  );
};

const styles = {
  container: {
    minHeight: '100vh',
    backgroundColor: '#f0f4f8',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    padding: '2rem',
  },
  content: {
    maxWidth: '800px',
    backgroundColor: '#ffffff',
    padding: '3rem',
    borderRadius: '16px',
    boxShadow: '0 15px 40px rgba(0, 0, 0, 0.1)',
    textAlign: 'left',
  },
  heading: {
    fontSize: '3rem',
    marginBottom: '1.5rem',
    color: '#2d3436',
    fontWeight: 'bold',
  },
  gradientText: {
    background: 'linear-gradient(to right, #00c6ff, #0072ff)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
  },
  paragraph: {
    fontSize: '1.1rem',
    lineHeight: '1.8',
    color: '#2d3436',
    marginBottom: '1.2rem',
    transition: 'color 0.3s ease',
    cursor: 'default',
  },
};

export default About;
