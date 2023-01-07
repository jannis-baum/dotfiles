const head = document.getElementsByTagName('head')[0];

const existing = document.querySelectorAll('meta[name="theme-color"]')
for (const tag of existing) {
    head.removeChild(tag);
}

const tag = document.createElement('meta');
tag.name = "theme-color";
tag.content = "#000";
head.appendChild(tag);
