#!/usr/bin/env -S python3 -u

# `-u` flag in order to ensure that stdin and stdout are opened in binary,
# rather than text, mode.

import base64
import json
import mimetypes
import os
import shutil
import struct
import subprocess
import sys
from urllib.parse import unquote

browser_name = 'Zen'

# read a message from stdin and decode it.
def getMessage():
    rawLength = sys.stdin.buffer.read(4)
    if len(rawLength) == 0:
        sys.exit(0)
    messageLength = struct.unpack('@I', rawLength)[0]
    message = sys.stdin.buffer.read(messageLength).decode('utf-8')
    return json.loads(message)

def get_line(tab, image_path):
    return f'{"1" if tab["active"] else ""}:{image_path}:{tab["title"]}'

sketchytabs_dir = os.path.join('/Volumes', 'sketchytabs', browser_name)
def reset_sketchytabs_dir():
    if os.path.exists(sketchytabs_dir):
        shutil.rmtree(sketchytabs_dir)
    os.mkdir(sketchytabs_dir)

# need index because tab['index'] is not consistent
def write_image(tab, index) -> str | None:
    if 'favIconUrl' not in tab: return
    try:
        header, encoded = tab['favIconUrl'].split(',')
        # header is e.g. "data:image/svg+xml;base64"
        split_header = header.split(';')
        mime_type = split_header[0].split(':')[1]
        extension = mimetypes.guess_extension(mime_type)
        path = os.path.join(sketchytabs_dir, f'{index + 1}{extension}')

        if len(split_header) == 2 and split_header[1] == 'base64':
            data = base64.b64decode(encoded)
        elif len(split_header) == 1:
            data = unquote(encoded).encode('utf-8')
        else: return

        with open(path, 'wb') as fp:
            fp.write(data)
            return path
    except:
        pass

if __name__ == '__main__':
    tabs = getMessage()
    reset_sketchytabs_dir()
    icon_paths = [write_image(tab, index) for index, tab in enumerate(tabs)]
    lines = [get_line(tab, icon_path) for (tab, icon_path) in zip(tabs, icon_paths)]

    # tab info for Synapse
    with open(os.path.join(sketchytabs_dir, 'tabs.json'), 'w') as fp:
        json.dump([{
            'title': tab['title'], 'caption': tab['url'], 'iconPath': icon_paths[index]
        } for index, tab in enumerate(tabs)], fp)

    fixed_env = os.environ.copy()
    fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
    subprocess.run(
        ['/opt/homebrew/bin/luajit', os.path.expanduser('~/.config/sketchybar/scripts/set-sketchytabs.lua'), browser_name],
        input='\n'.join(lines) + '\n',
        text=True,
        env=fixed_env
    )
