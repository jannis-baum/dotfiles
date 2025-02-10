export const command = `
    ~/.bin/battery
    ~/.bin/battery --percentage
    date +%l:%M
    date +%m/%d
    date +%l:%M:%S
`;
export const refreshFrequency = 1000;
export const className =`
    box-sizing: border-box;
    top: 0; left: 12px; right: 12px; height: 32px;

    color: #bbb;
    font-family: "Poiret One", -apple-system;
    font-size: 18px;

    .container {
        display: flex;
        justify-content: space-between;
    }

    .left {
        display: flex;
        gap: 0.5em;
    }
    .right {
        display: flex;
        margin-left: auto;
        gap: 0.5em;
    }

    span.box {
        padding: 2px 6px;
        background-color: #101010;
        border-radius: 6px;
        border: 1px solid #333;
        display: block;
    }
    span.hover-container {
        display: flex;
        gap: 0.25em;
    }
    span.hover-container > span.alt { display: none }
    span.hover-container:hover > span.main { display: none }
    span.hover-container:hover > span.alt { display: block }
`

export const render = ({output}) => {
    const [battery, batteryPercent, time, date, timeSeconds] = output.split('\n');
    return (
        <div className="container">
            <div className="left">
            </div>
            <div className="right">
                <span class="hover-container">
                    <span class="main box">{battery}</span>
                    <span class="alt box">{batteryPercent}</span>
                </span>
                <span class="hover-container">
                    <span class="main box">{time}</span>
                    <span class="alt box">{date}</span>
                    <span class="alt box">{timeSeconds}</span>
                </span>
            </div>
        </div>
    );
}

