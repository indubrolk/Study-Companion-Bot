import React, { useState, useEffect } from "react";

function Timer() {
    const [time, setTime] = useState(0);
    const [isRunning, setIsRunning] = useState(false);
    const [mode, setMode] = useState("focus");
    const [cycles, setCycles] = useState(0);

    useEffect(() => {
        let timer;
        if (isRunning) {
            timer = setInterval(() => {
                setTime((prev) => prev + 1);
            }, 1000);
        }
        return () => clearInterval(timer);
    }, [isRunning]);

    const handleTimerEnd = () => {
        setIsRunning(false);
        if (mode === "focus" && time >= 25 * 60) {
            setMode("break");
            setTime(0);
        } else if (mode === "break" && time >= 5 * 60) {
            setMode("focus");
            setTime(0);
            setCycles((c) => c + 1);
        }
    };

    const formatTime = () => {
        const mins = Math.floor(time / 60).toString().padStart(2, "0");
        const secs = (time % 60).toString().padStart(2, "0");
        return `${mins}:${secs}`;
    };

    const handleReset = () => {
        setIsRunning(false);
        setTime(0);
    };

    const progress = mode === "focus"
        ? Math.min((time / (25 * 60)) * 100, 100)
        : Math.min((time / (5 * 60)) * 100, 100);

    return (
        <div className="min-h-screen flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl shadow-xl shadow-green-500  p-8 w-full max-w-md">
                <div className="text-center">
                    <h1 className="text-3xl font-bold text-gray-800 mb-2">
                        Lets Start
                    </h1>

                    <div className={`inline-block px-4 py-2 rounded-full text-sm font-semibold mb-6 ${
                        mode === "focus"
                            ? "bg-red-100 text-red-700"
                            : "bg-green-100 text-green-700"
                    }`}>
                        {mode === "focus" ? "🍅 Focus Time" : "☕ Break Time"}
                    </div>

                    {/* Progress Ring */}
                    <div className="relative w-48 h-48 mx-auto mb-8">
                        <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                            {/* Background circle */}
                            <circle
                                cx="50"
                                cy="50"
                                r="45"
                                stroke="currentColor"
                                strokeWidth="8"
                                fill="none"
                                className="text-gray-200"
                            />
                            {/* Progress circle */}
                            <circle
                                cx="50"
                                cy="50"
                                r="45"
                                stroke="currentColor"
                                strokeWidth="8"
                                fill="none"
                                strokeDasharray={`${2 * Math.PI * 45}`}
                                strokeDashoffset={`${2 * Math.PI * 45 * (1 - progress / 100)}`}
                                className={`transition-all duration-1000 ${
                                    mode === "focus" ? "text-red-500" : "text-green-500"
                                }`}
                                strokeLinecap="round"
                            />
                        </svg>
                        {/* Timer display */}
                        <div className="absolute inset-0 flex items-center justify-center">
                            <div className="text-center">
                                <div className="text-4xl font-mono font-bold text-gray-800">
                                    {formatTime()}
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Control buttons */}
                    <div className="flex gap-4 justify-center mb-6">
                        <button
                            onClick={() => setIsRunning(!isRunning)}
                            className={`px-8 py-3 rounded-full font-semibold text-white transition-all duration-200 transform hover:scale-105 ${
                                isRunning
                                    ? "bg-orange-500 hover:bg-orange-600"
                                    : "bg-green-500 hover:bg-green-600"
                            }`}
                        >
                            {isRunning ? "⏸️ Pause" : "▶️ Start"}
                        </button>

                        <button
                            onClick={handleReset}
                            className="px-8 py-3 bg-gray-500 hover:bg-gray-600 text-white rounded-full font-semibold transition-all duration-200 transform hover:scale-105"
                        >
                            🔄 Reset
                        </button>
                    </div>

                    {/* Cycles counter */}
                    <div className="bg-gray-50 rounded-2xl p-4">
                        <div className="flex items-center justify-center gap-2">
                            <span className="text-2xl">🏆</span>
                            <span className="text-lg font-semibold text-gray-700">
                                Pomodoros Completed:
                            </span>
                            <span className="text-xl font-bold text-indigo-600">
                                {cycles}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Timer;