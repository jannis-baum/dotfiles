#!/usr/bin/env python3

import os, requests, json
ROOT_DIR = os.path.dirname(os.path.realpath(__file__))

sources = [
    ('annotations', 'https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-annotations-modern/annotations/en/annotations.json'),
    ('annotationsDerived', 'https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-annotations-derived-modern/annotationsDerived/en/annotations.json')
]

if __name__ == '__main__':
    characters = []
    for name, url in sources:
        data = requests.get(url).json()
        characters += [{
                'symbol': char,
                'title': value['tts'][0],
                'caption': ', '.join(value['default']) if 'default' in value else None
        } for char, value in data[name]['annotations'].items()]

    with open(os.path.join(ROOT_DIR, 'source.json'), 'w') as fp:
        json.dump(characters, fp)
