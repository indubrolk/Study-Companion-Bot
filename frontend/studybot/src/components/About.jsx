import React from 'react';

const About = () => {
  return (
    <div style={styles.container}>
      <div style={styles.content}>
        <h1 style={styles.heading}>About Smart Study</h1>
        <p style={styles.paragraph}>
          <strong>Smart Study</strong> is a modern study companion designed to help students stay organized, focused, and productive. Whether you're preparing for competitive exams, managing class notes, or tracking your learning progress, Smart Study gives you the tools to succeed—all in one place.
        </p>
        <p style={styles.paragraph}>
          Built using <strong>React</strong> and <strong>Vite</strong>, this app delivers fast performance and a seamless user experience. Our mission is to make learning efficient and enjoyable by combining smart features with a clean, distraction-free interface.
        </p>
        <p style={styles.paragraph}>
          Explore dashboards, manage tasks, and stay on top of your goals. With Smart Study, you're not just studying—you're studying smarter.
        </p>
      </div>
    </div>
  );
};

const styles = {
  container: {
    minHeight: '100vh',
    backgroundColor: '#f9f9f9',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    padding: '2rem',
  },
  content: {
    maxWidth: '800px',
    backgroundColor: '#fff',
    padding: '3rem',
    borderRadius: '12px',
    boxShadow: '0 10px 25px rgba(0, 0, 0, 0.1)',
    textAlign: 'left',
  },
  heading: {
    fontSize: '2.5rem',
    marginBottom: '1.5rem',
    color: '#2c3e50',
  },
  paragraph: {
    fontSize: '1.1rem',
    lineHeight: '1.7',
    color: '#34495e',
    marginBottom: '1rem',
  },
};

export default About;
