#!/usr/bin/env -S python3 -u

# `-u` flag in order to ensure that stdin and stdout are opened in binary,
# rather than text, mode.

import json
import os
import struct
import subprocess
import sys

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

while True:
    tabs = getMessage()
    titles = [get_title(tab) for tab in tabs]

    fixed_env = os.environ.copy()
    fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
    subprocess.run(
        [os.path.expanduser('~/.config/sketchybar/scripts/set-sketchytabs.zsh'), 'Zen'],
        input='\n'.join(titles) + '\n',
        text=True,
        env=fixed_env
    )
