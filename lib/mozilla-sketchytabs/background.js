// get 32x32 PNG data for arbitrary dataURLs to export favicons
async function getPNGData(dataURL, width = 32, height = 32) {
    // dataURL could also e.g. start with `chrome:` for internal stuff which is
    // not allowed to be used here for security
    if (!dataURL.startsWith('data:')) return '';
    return new Promise((resolve) => {
        // create canvas element
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');

        // create image element to load the data URL
        const img = new Image();

        // when the image has loaded, draw it on the canvas, resize it, and convert to PNG
        img.onload = function() {
            // Set canvas dimensions to the desired size
            canvas.width = width;
            canvas.height = height;

            // draw the image onto the canvas, resizing it to fit the canvas size
            ctx.drawImage(img, 0, 0, width, height);

            // get the PNG data URL from the canvas & resolve promise
            const pngDataURL = canvas.toDataURL('image/png');
            resolve(pngDataURL)
        };

        // set the image source to the data URL
        img.src = dataURL;
    })
}

const events = [
    browser.tabs.onCreated,
    browser.tabs.onActivated,
    browser.tabs.onRemoved,
    browser.tabs.onUpdated,
    browser.tabs.onMoved
];

events.forEach((event) => {
    event.addListener(async () => {
        try {
            let tabs = await browser.tabs.query({});
            const pngs = await Promise.all(tabs.map((tab) => getPNGData(tab['favIconUrl'])))
            tabs = tabs.map((tab, idx) => {
                return {
                    ...tab,
                    favIconUrl: pngs[idx]
                }
            })
            await browser.runtime.sendNativeMessage('sketchytabs', tabs)
        } catch (error) {
            console.error(error)
        }
    })
})
