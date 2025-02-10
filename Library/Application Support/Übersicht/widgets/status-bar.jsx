export const command = `
    ~/.bin/battery
    date +%m/%d
    date +%l:%M
`;
export const refreshFrequency = 1000;
export const className =`
    box-sizing: border-box;
    top: 0; left: 12px; right: 12px; height: 32px;

    color: #aaa;
    font-family: "Poiret One", -apple-system;
    font-size: 20px;

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

    span {
        padding: 2px 6px;
        background-color: #101010;
        border-radius: 6px;
        border: 1px solid #333;
    }
`

export const render = ({output}) => {
    const [battery, date, time] = output.split('\n');
    return (
        <div className="container">
            <div className="left">
            </div>
            <div className="right">
                <span>{battery}</span>
                <span>{date}</span>
                <span>{time}</span>
            </div>
        </div>
    );
}

