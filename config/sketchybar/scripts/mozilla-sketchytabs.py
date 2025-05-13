#!/usr/bin/env -S python3 -u

# `-u` flag in order to ensure that stdin and stdout are opened in binary,
# rather than text, mode.

import base64
import json
import math
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
    if max_length == 0: return ''
    string = string.strip()
    if len(string) <= max_length:
        return string
    if max_length > 10:
        return string[:max_length - 1].rstrip() + '…'
    return string[:max_length]

def get_title(tab, active_len, inactive_len):
    if tab['active']:
        return ellipse_string(tab['title'], active_len)
    return f'FAINT {ellipse_string(tab["title"], inactive_len)}'

icon_dir = os.path.join('/Volumes', 'sketchytabs-icons', browser_name)
def reset_icon_dir():
    if os.path.exists(icon_dir):
        shutil.rmtree(icon_dir)
    os.mkdir(icon_dir)

# need index because tab['index'] is not consistent
def write_image(tab, index):
    if 'favIconUrl' not in tab: return
    try:
        header, encoded = tab['favIconUrl'].split(',')
        # header is e.g. "data:image/svg+xml;base64"
        split_header = header.split(';')
        mime_type = split_header[0].split(':')[1]
        extension = mimetypes.guess_extension(mime_type)
        path = os.path.join(icon_dir, f'{index + 1}{extension}')

        if len(split_header) == 2 and split_header[1] == 'base64':
            data = base64.b64decode(encoded)
        elif len(split_header) == 1:
            data = unquote(encoded).encode('utf-8')
        else: return

        with open(path, 'wb') as fp:
            fp.write(data)
    except:
        pass

# find number of chars tab bar can show:
# echo '0_2345678_1_2345678_2_2345678_3_2345678_4_2345678_5_2345678_6_2345678_7_2345678_8_2345678_9_2345678_' \
#     | config/sketchybar/scripts/set-sketchytabs.zsh Finder
_max_chars = 74 # max chars displayable in tab bar
# for these take a screenshot & compare widths
_icon_w = 3     # approx. how wide an icon is
_gap_w = 1.5    # approx. how wide the gap is
# compute good lengths for titles (active, inactive)
def title_lengths(tab_count: int) -> tuple[int, int]:
    icons = _icon_w * tab_count
    gaps = _gap_w * (tab_count - 1)
    free_space = _max_chars - gaps - icons
    # free_space = (tab_count - 1) * inactive + active
    # free_space = (tab_count - 1) * inactive + 3 * inactive
    # free_space = inactive * (tab_count - 1 + 3)
    # free_space = inactive * (tab_count + 2)
    # inactive = free_space / (tab_count + 2) -> floor & max(0, _)
    inactive = max(0, math.floor(free_space / (tab_count + 2)))
    active = max(0, math.floor(free_space - inactive * (tab_count - 1)))
    return (active, inactive)

while True:
    tabs = getMessage()
    active_len, inactive_len = title_lengths(len(tabs))
    titles = [get_title(tab, active_len, inactive_len) for tab in tabs]
    reset_icon_dir()
    for index, tab in enumerate(tabs): write_image(tab, index)

    fixed_env = os.environ.copy()
    fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
    subprocess.run(
        [os.path.expanduser('~/.config/sketchybar/scripts/set-sketchytabs.zsh'), browser_name],
        input='\n'.join(titles) + '\n',
        text=True,
        env=fixed_env
    )
