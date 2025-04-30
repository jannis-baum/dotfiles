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

def ellipse_string(string, max_length):
    return string if len(string) < max_length else string[:max_length] + '…'

def get_title(tab):
    if tab['active']:
        return ellipse_string(tab['title'], 32)
    return f'FAINT {ellipse_string(tab["title"], 8)}'

icon_dir = os.path.join('/Volumes', 'sketchytabs-icons', browser_name)
def reset_icon_dir():
    if os.path.exists(icon_dir):
        shutil.rmtree(icon_dir)
    os.mkdir(icon_dir)

def write_image(tab):
    if 'favIconUrl' not in tab: return
    header, encoded = tab['favIconUrl'].split(',')
    # header is e.g. "data:image/svg+xml;base64"
    split_header = header.split(';')
    mime_type = split_header[0].split(':')[1]
    extension = mimetypes.guess_extension(mime_type)
    path = os.path.join(icon_dir, f'{tab["index"] + 1}{extension}')

    if len(split_header) == 2 and split_header[1] == 'base64':
        data = base64.b64decode(encoded)
    elif len(split_header) == 1:
        data = unquote(encoded).encode('utf-8')
    else: return

    with open(path, 'wb') as fp:
        fp.write(data)

while True:
    tabs = getMessage()
    titles = [get_title(tab) for tab in tabs]
    reset_icon_dir()
    for tab in tabs: write_image(tab)

    fixed_env = os.environ.copy()
    fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
    subprocess.run(
        [os.path.expanduser('~/.config/sketchybar/scripts/set-sketchytabs.zsh'), browser_name],
        input='\n'.join(titles) + '\n',
        text=True,
        env=fixed_env
    )
