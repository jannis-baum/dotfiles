function normalizeURL(url) {
    return url.replace(/^https?:\/\//, '');
}

async function reuseTab(url, id) {
    const targetURL = normalizeURL(url);

    const tabs = await browser.tabs.query({});
    for (let tab of tabs) {
        if (tab.id == id) continue;

        const tabURL = normalizeURL(tab.url);
        if (tabURL != targetURL) continue;

        await browser.tabs.remove(id);
        await browser.tabs.update(tab.id, { active: true });
        return;
    }
}

browser.tabs.onCreated.addListener(async (newTab) => {
    // target URL is in title for new loading tab
    await reuseTab(newTab.title, newTab.id);
});

browser.tabs.onUpdated.addListener(async (tabID, changeInfo) => {
    await reuseTab(changeInfo.url, tabID);
}, { properties: ['url'] });
