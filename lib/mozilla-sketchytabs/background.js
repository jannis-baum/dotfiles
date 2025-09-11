const iconW = 32;
const iconH = 32;

// circle as placeholder for missing favicons
function getFaviconPlaceholder(color) {
    const canvas = document.createElement('canvas');
    canvas.width = iconW;
    canvas.height = iconH;
    const centerX = iconW / 2;
    const centerY = iconH / 2;
    const radius = Math.min(centerX, centerY) * 0.8;

    const ctx = canvas.getContext('2d');
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
    ctx.strokeStyle = color;
    ctx.lineWidth = radius * 0.2;
    ctx.stroke();

    return canvas.toDataURL('image/png');
}
const placeholderActive = getFaviconPlaceholder('#bbbbbb');
const placeholderInactive = getFaviconPlaceholder('#808080');

// get 32x32 PNG data for arbitrary dataURLs to export favicons
async function getPNGFavicon(tab) {
    const dataURL = tab['favIconUrl'];
    const active = tab['active']
    // dataURL could also e.g. start with `chrome:` for internal stuff which is
    // not allowed to be used here for security
    if (!dataURL || !dataURL.startsWith('data:')) {
        return active ? placeholderActive : placeholderInactive;
    }

    return new Promise((resolve) => {
        // create canvas element
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');

        // create image element to load the data URL
        const img = new Image();

        // when the image has loaded, draw it on the canvas, resize it, and convert to PNG
        img.onload = function() {
            // Set canvas dimensions to the desired size
            canvas.width = iconW;
            canvas.height = iconH;

            // draw the image onto the canvas, resizing it to fit the canvas size
            ctx.drawImage(img, 0, 0, iconW, iconH);
            // grayscale image & darken if not active
            let imgData = ctx.getImageData(0, 0, ctx.canvas.width, ctx.canvas.height);
            let pixels = imgData.data;
            for (var i = 0; i < pixels.length; i += 4) {
                let lightness = parseInt((pixels[i] + pixels[i + 1] + pixels[i + 2]) / 3);
                if (!active) lightness *= 0.7;
                pixels[i] = lightness;
                pixels[i + 1] = lightness;
                pixels[i + 2] = lightness;
            }
            ctx.putImageData(imgData, 0, 0);

            // get the PNG data URL from the canvas & resolve promise
            resolve(canvas.toDataURL('image/png'))
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

async function updateTabs() {
    try {
        let tabs = await browser.tabs.query({});
        const pngs = await Promise.all(tabs.map((tab) => getPNGFavicon(tab)))
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
}


let debounceTimeout;
// TODO: remove when https://bugzilla.mozilla.org/show_bug.cgi?id=1987397 is fixed
let bugFixTimeout;

events.forEach((event) => {
    event.addListener(() => {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(updateTabs, 20)
        clearTimeout(bugFixTimeout);
        bugFixTimeout = setTimeout(updateTabs, 100)
    })
})
