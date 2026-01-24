# pyright: reportMissingImports=false

import os
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

import subprocess, atexit, os


def _get_cwd(boss) -> str | None:
    tm = boss.active_tab_manager
    if tm is None: return
    w = tm.active_window
    if w is None: return
    return w.cwd_of_child

def _get_mount(path: str) -> str | None:
    while path != "/":
        if os.path.ismount(path):
            return path
        path = os.path.dirname(path)
    return None

# copied & modified from
# https://github.com/kovidgoyal/watcher/blob/master/watcher/gitstatusd.py
class _GitStatusD:
    def __init__(self):
        self.process = subprocess.Popen([
            '/opt/homebrew/opt/gitstatus/usrbin/gitstatusd-darwin-arm64',
            '--num-threads=12' # should be 2 * number of virtual cpu
        ], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        atexit.register(self.terminate)
        self.request_id = 0

    def terminate(self):
        if self.process.returncode is None:
            self.process.terminate()
            if self.process.wait(0.1) is None:
                self.process.kill()
                self.process.wait()
    __del__ = terminate

    def get(self, path):
        self.request_id += 1
        rq = f'{self.request_id}\x1f{path}\x1e'
        self.process.stdin.write(rq.encode('utf-8'))
        self.process.stdin.flush()
        resp = b''
        while b'\x1e' not in resp:
            resp += os.read(self.process.stdout.fileno(), 8192)
        fields = resp.rstrip(b'\x1e').decode('utf-8', 'replace').split('\x1f')
        if fields[0] != str(self.request_id):
            raise ValueError(f'Got invalid response id: {fields[0]}')
        if fields[1] == '0':
            raise NotADirectoryError(f'{path} is not a git repository')
        return {
            'workdir': fields[2],
            'HEAD': fields[3],
            'branch_name': fields[4],
            'upstream_branch_name': fields[5],
            'remote_branch_name': fields[6],
            'remote_url': fields[7],
            'repo_state': fields[8],
            'num_files_in_index': int(fields[9] or 0),
            'num_staged_changes': int(fields[10] or 0),
            'num_unstaged_changes': int(fields[11] or 0),
            'num_conflicted_changes': int(fields[12] or 0),
            'num_untracked_files': int(fields[13] or 0),
            'num_commits_ahead_of_upstream': int(fields[14] or 0),
            'num_commits_behind_upstream': int(fields[15] or 0),
            'num_stashes': int(fields[16] or 0),
            'last_tag_pointing_to_HEAD': fields[17],
            'num_unstaged_deleted_files': int(fields[18] or 0),
            'num_staged_new_files': int(fields[19] or 0),
            'num_staged_deleted_files': int(fields[20] or 0),
            'push_remote_name': fields[21],
            'push_remote_url': fields[22],
            'num_commits_ahead_of_push': int(fields[23] or 0),
            'num_commits_behind_of_push': int(fields[24] or 0),
            'num_files_with_skip_worktree_set': int(fields[25] or 0),
            'num_files_with_assume_unchanged_set': int(fields[26] or 0),
            'encoding_of_head': fields[27] or 'utf-8',
            'head_first_para': fields[28],
        }

def _get_git_info(boss: Boss, cwd: str) -> str | None:
    # forgive the horrible hack
    if not hasattr(boss, 'gitstatusd'):
        boss.gitstatusd = _GitStatusD()

    try:
        git_info = boss.gitstatusd.get(cwd)
        git_branch = git_info['branch_name'] or git_info['HEAD'][:8]
        dirty = git_info['num_staged_deleted_files'] + \
            git_info['num_staged_new_files'] + \
            git_info['num_staged_changes'] + \
            git_info['num_unstaged_deleted_files'] + \
            git_info['num_unstaged_changes'] + \
            git_info['num_conflicted_changes'] + \
            git_info['num_untracked_files']
        git_status = '✻ ' if dirty > 0 else ''
    except: return None
    return f'{git_status}{git_branch}'

def _get_info(boss: Boss) -> str | None:
    cwd = _get_cwd(boss)
    if cwd is None:
        return None

    mount = _get_mount(cwd)
    if mount is not None:
        return os.path.basename(mount)

    # only use gitstatusd when not in mounted directory because it gets super
    # slow via sshfs
    return _get_git_info(boss, cwd)

def _refresh_widgets(boss: Boss) -> None:
    result = ''

    tab_manager = boss.active_tab_manager
    if tab_manager is not None:
        active_id = (active_tab := tab_manager.active_tab) and active_tab.id
        def is_active(tab) -> bool:
            return active_id == tab.id

        def get_remote_title(_) -> str:
            return 'ssh'

        def get_local_title(tab) -> str:
            title = tab.get_cwd_of_active_window() or '??'
            title = title.replace(os.path.expanduser('~'), 'home')
            title = title.split('/')[-1]
            info = _get_info(boss)
            suffix = '' if info is None else f': {info}'
            return f'{title}{suffix}' if is_active(tab) else title

        def get_line(tab) -> str:
            exe = tab.get_exe_of_active_window()
            if exe and exe.split('/')[-1] == 'ssh':
                title = get_remote_title(tab)
            else:
                title = get_local_title(tab)
            return f'{"1" if is_active(tab) else ""}:::{title}'

        tab_lines = [get_line(tab) for tab in tab_manager.tabs]
        result += '\n'.join(tab_lines) + '\n'

    fixed_env = os.environ.copy()
    fixed_env['PATH'] = f'/opt/homebrew/bin:{fixed_env["PATH"]}'
    p = subprocess.Popen(
        ['luajit', os.path.expanduser('~/.config/sketchybar/scripts/set-sketchytabs.lua'), 'kitty'],
        stdin=subprocess.PIPE,
        env=fixed_env
    )
    p.stdin.write(result.encode())
    p.stdin.close()

def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _refresh_widgets(boss)
