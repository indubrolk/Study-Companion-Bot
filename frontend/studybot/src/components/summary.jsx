import React, { useState } from 'react';
import axios from 'axios';

const Summary = () => {
  const [input, setInput] = useState('');
  const [summary, setSummary] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSummarize = async () => {
    if (!input.trim()) {
      setError('Please enter some text to summarize.');
      return;
    }

    setLoading(true);
    setError('');
    setSummary('');

    try {
      const res = await axios.post('http://localhost:9090/study/summarize', input, {
        headers: {
          'Content-Type': 'text/plain',
        },
      });
      setSummary(res.data.summary);
    } catch (err) {
      setError('Failed to fetch summary. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className='min-h-screen  flex items-center justify-center '>
    <div className="bg-white rounded-3xl shadow-xl shadow-green-500  p-8 w-full max-w-md ">
      <h2 className="text-2xl font-bold mb-4 text-center text-black">Text Summarizer</h2>

      <textarea
        className="w-full h-90 border  border-gray-300 rounded-md p-3 mb-4 focus:outline-none focus:ring-2 focus:ring-red-300"
        rows="6"
        placeholder="Paste or write your text here..."
        value={input}
        onChange={(e) => setInput(e.target.value)}
      />

      <button
        onClick={handleSummarize}
        className="w-full bg-green-500 text-white py-2 rounded-md hover:bg-green-600 transition"
        disabled={loading}
      >
        {loading ? 'Summarizing...' : 'Summarize'}
      </button>

      {error && <p className="text-green-500 mt-3 text-center">{error}</p>}

      {summary && (
        <div className="mt-6">
          <h3 className="text-lg font-semibold mb-2">Summary:</h3>
          <p className="bg-gray-100 p-4 rounded-md text-gray-800 whitespace-pre-wrap">{summary}</p>
        </div>
      )}
    </div>
    </div>
  );
};

export default Summary;
