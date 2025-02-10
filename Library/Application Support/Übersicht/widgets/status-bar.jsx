export const command = `
    ~/.bin/battery
    date +%m/%d
    date +%l:%M
`;
export const refreshFrequency = 1000;
export const className =`
    top: 0px; right: 0px; left: 0px; height: 32px;
    padding: 6px 10px;

    color: #ddd;
    font-family: "Poiret One", -apple-system;
    font-size: 20px;

    .container {
        display: flex;
        justify-content: space-between;
    }

    .left {
        display: flex;
    }
    .right {
        display: flex;
        margin-left: auto;
        gap: 1em;
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

