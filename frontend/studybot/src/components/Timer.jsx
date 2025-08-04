import React, {useState, useEffect} from "react";

function Timer() {
    const [time, setTime] = useState(25 * 60);
    const [isRunning, setIsRunning] = useState(false);
    const [mode, setMode] = useState("focus");
    const [cycles, setCycles] = useState(0);

    useEffect(() => {
        let timer;
        if (isRunning) {
            timer = setInterval(() => {
                setTime((prev) => {
                    if (prev === 1) {
                        handleTimerEnd();
                        return 0;
                    }
                    return prev - 1;
                });
            }, 1000);
        }
        return () => clearInterval(timer);
    }, [isRunning]);

    const handleTimerEnd = () => {
        setIsRunning(false);
        if (mode === "focus") {
            setMode("break");
            setTime(5 * 60);
        } else {
            setMode("focus");
            setTime(25 * 60);
            setCycles((c) => c + 1);
        }
    };

    const formatTime = () => {
        const mins = Math.floor(time / 60);
        toString()
            .padStart(2, "0");

        const secs = (time % 60).toString().padStart(2, "0");
        return `${mins}:${secs}`;
    };

    const handleReset = () => {
        setIsRunning(false);
        setTime(mode === "focus" ? 25 * 60 : 5 * 60);
    };
    return (
        <div className = "min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
        <div className="bg-white rounded-3xl shadow-2xl p-8 w-full max-w-md">
        <div className="text-center">
            <h1 className="text-3xl font-bold text-gray-800 mb-2">
                Pomodoro Timer
            </h1>
            <h2>{mode === "focus" ? "🍅 Focus Time" : "☕ Break Time"}</h2>
            <div>{formatTime()}</div>
            <div className="flex gap-4 justify-center mb-6">
                <button onClick={() => setIsRunning(!isRunning)}
                        className={`px-8 py-3 rounded-full font-semibold text-white transition-all duration-200 transform hover:scale-105 ${
                            isRunning
                            ? "bg-orange-500 hover:bg-orange-600"
                                : "bg-green-500 hover:bg-green-600"
                        }`}
                >
                    {isRunning ? "Pause" : "Start"}
                </button>
                <button onClick={handleReset} className="px-8 py-3 bg-gray-500 hover:bg-gray-600 text-white rounded-full font-semibold transition-all duration-200 transform hover:scale-105 ">Reset</button>
            </div>
            <p>Pomodoros Completed: {cycles}</p>
        </div>
        </div>
        </div>
    );
};
export default Timer;