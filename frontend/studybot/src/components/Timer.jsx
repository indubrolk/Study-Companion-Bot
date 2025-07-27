import React, {useState, useEffect} from "react";

function Timer() {
    const [time, setTime] = useState(25 * 60);
    const [isRunning, setIsRunning] = useState(false);
    const [mode, setMode] = useState("focus");
    const [cycles, setCycles] = useState(0);

    useEffect(() => {
        let timer;
        if (isRunning){
            timer = setInterval(() => {
                setTime((prev) => {
                    if (prev === 1){
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
            if(mode === "focus"){
                setMode("break");
                setTime(5 * 60);
            } else{
                setMode("focus");
                setTime(25 * 60);
                setCycles((c) => c + 1);
            }
        };

        const formatTime = () => {
            const mins = Math.floor(time / 60);
            .toString()
                .padStart(2,"0");

            const secs = (time % 60).toString().padStart(2, "0");
            return `${mins}:${secs}`;
        };

        const handle

    )
}

export default Timer;