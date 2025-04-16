export const command = `
    ~/.local/bin/widgets
    printf "\\0"
    ~/.local/bin/battery
    ~/.local/bin/battery --percentage
    date +%l:%M
    date +%m/%d
    date +%l:%M:%S
`;
export const refreshFrequency = 1000;
export const className =`
    box-sizing: border-box;
    /* left/right to avoid hitting rounded corners */
    top: 0; left: 8px; right: 8px; height: 32px;

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
        padding: 2px 8px;
        background-color: #101010;
        border-radius: 12px;
        border: 1px solid #444;
        display: block;
    }
    span.faint {
        color: #888;
        border: 1px solid #222;
    }
    span.hover-container {
        display: flex;
        gap: 0.25em;
    }
    span.hover-container > span.alt { display: none }
    span.hover-container:hover > span.main { display: none }
    span.hover-container:hover > span.alt { display: block }
`

const getItems = (string) => string.split('\n');
const parseItems = (items) => items.map((item) => {
    // e.g. `class="my_class" my_title`
    const groups = /(class="(?<class>.+)"\s*)?(?<title>.+)/.exec(item)?.groups;
    if (!groups) return null;
    return {
        class: groups['class'],
        title: groups['title']
    }
}).filter((item) => item);

export const render = ({output}) => {
    const [left, right] = output.split('\0');
    const dynamicWidgets = parseItems(getItems(left));
    const [battery, batteryPercent, time, date, timeSeconds] = getItems(right);
    return (
        <div className="container">
            <div className="left">
                {dynamicWidgets.map((widget) =>
                    <span class={'box ' + (widget['class'] ?? '')}>{widget['title']}</span>
                )}
            </div>
            <div className="right">
                <span class="hover-container">
                    {battery !== '' && <span class="main box">{battery}</span>}
                    {batteryPercent !== '' && <span class="alt box">{batteryPercent}</span>}
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

