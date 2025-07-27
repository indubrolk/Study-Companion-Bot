import React, {useState, useEffect} from "react";

function Timer() {
    const [time, setTime] = useState(25 * 60);
    const [isRunning, setIsRunning] = useState(false);
    const [mode, setMode] = useState("focus");
    const [cycles, setCycles] = useState(0);

    useEffect{() => {
        let timer;
        if (isRunning){

        }
    }}
}

export default Timer;