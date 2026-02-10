#!/usr/bin/env -S python3 -u

# `-u` flag in order to ensure that stdin and stdout are opened in binary,
# rather than text, mode.

import base64
import http.server
import json
import mimetypes
import os
import shutil
import socketserver
import struct
import subprocess
import sys
import threading
from typing import Optional
from urllib.parse import unquote, urlparse, parse_qs

browser_name = 'Zen'
port = 11912
script_dir = os.path.expanduser("~/.config/sketchybar/scripts")

# read a message from stdin and decode it.
def get_message():
    raw_length = sys.stdin.buffer.read(4)
    if len(raw_length) == 0:
        sys.exit(0)
    message_length = struct.unpack('@I', raw_length)[0]
    message = sys.stdin.buffer.read(message_length).decode('utf-8')
    return json.loads(message)

# send an encoded message to stdout
def send_message(content):
    # specify separators (',', ':') to eliminate whitespace and get most
    # compact representation because browser rejects messages > 1 MB
    message = json.dumps(content, separators=(',', ':')).encode('utf-8')
    length = struct.pack('@I', len(message))
    sys.stdout.buffer.write(length)
    sys.stdout.buffer.write(message)
    sys.stdout.buffer.flush()

def listen_to_updates():
    def get_line(tab, image_path, switchto_path):
        return f'{"1" if tab["active"] else ""}:{image_path or ""}:{switchto_path or ""}:{tab["title"]}'

    sketchytabs_dir = os.path.join('/Volumes', 'sketchytabs', browser_name)
    def reset_sketchytabs_dir():
        if os.path.exists(sketchytabs_dir):
            shutil.rmtree(sketchytabs_dir)
        os.mkdir(sketchytabs_dir)

    # need index because tab['index'] is not consistent
    def write_image(tab, index) -> Optional[str]:
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

    while True:
        tabs = get_message()
        reset_sketchytabs_dir()
        icon_paths = [write_image(tab, index) for index, tab in enumerate(tabs)]
        switchto_cmds = [f"TAB_ID={tab['id']} {os.path.join(script_dir, 'mozilla-sketchytab-click.zsh')}" for tab in tabs]
        lines = [
            get_line(tab, icon_path, switchto_cmd)
            for (tab, icon_path, switchto_cmd) in zip(tabs, icon_paths, switchto_cmds)
        ]

        # tab info for Synapse
        with open(os.path.join(sketchytabs_dir, 'tabs.json'), 'w') as fp:
            json.dump([{
                'title': tab['title'], 'caption': tab['url'], 'iconPath': icon_paths[index],
                'userInfo': TabSwitchServer.get_url_switchto(tab),
            } for index, tab in enumerate(tabs)], fp)

        fixed_env = os.environ.copy()
        fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
        subprocess.run(
            ['/opt/homebrew/bin/luajit', os.path.join(script_dir, 'set-sketchytabs.lua'), browser_name],
            input='\n'.join(lines) + '\n',
            text=True,
            env=fixed_env
        )

class TabSwitchServer(http.server.BaseHTTPRequestHandler):
    @staticmethod
    def get_url_switchto(tab) -> str:
        return f'http://localhost:{port}/?switchto={tab['id']}'

    def do_GET(self):
        parsed_url = urlparse(self.path)
        query_params = parse_qs(parsed_url.query)
        switchto = query_params.get("switchto", [None])[0]
        close = query_params.get("close", [None])[0]

        if switchto:
            try:
                send_message({ "switchTo": int(switchto) })
            except: pass

        if close:
            try:
                send_message({ "close": int(close) })
            except: pass

        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()

if __name__ == '__main__':
    listener = threading.Thread(target=listen_to_updates, daemon=True)
    listener.start()

    with socketserver.TCPServer(("", port), TabSwitchServer) as httpd:
        httpd.serve_forever()
