const events = [
    browser.tabs.onCreated,
    browser.tabs.onActivated,
    browser.tabs.onRemoved,
    browser.tabs.onUpdated,
    browser.tabs.onMoved
];

events.forEach((event) => {
    event.addListener(async () => {
        const tabs = await browser.tabs.query({});
        try {
            await browser.runtime.sendNativeMessage('sketchytabs', tabs)
        } catch (error) {
            console.error(error)
        }
    })
})
