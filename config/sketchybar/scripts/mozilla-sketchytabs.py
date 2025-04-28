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

# encode a message for transmission, given its content.
def encodeMessage(messageContent):
    # https://docs.python.org/3/library/json.html#basic-usage
    # to get the most compact JSON representation, you should specify
    # (',', ':') to eliminate whitespace.
    # we want the most compact representation because the browser rejects
    # messages that exceed 1 MB.
    encodedContent = json.dumps(messageContent, separators=(',', ':')).encode('utf-8')
    encodedLength = struct.pack('@I', len(encodedContent))
    return {'length': encodedLength, 'content': encodedContent}

# send an encoded message to stdout
def sendMessage(encodedMessage):
    sys.stdout.buffer.write(encodedMessage['length'])
    sys.stdout.buffer.write(encodedMessage['content'])
    sys.stdout.buffer.flush()

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
        [os.path.expanduser('~/.config/sketchybar/scripts/set-app-items.zsh'), 'Zen'],
        input='\n'.join(titles) + '\n',
        text=True,
        env=fixed_env
    )
