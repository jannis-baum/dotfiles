# pyright: reportMissingImports=false

from typing import Any

from kitty.boss import Boss
from kitty.window import Window

import subprocess, atexit, os

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

def _get_git_info(boss: Boss):
    # forgive the horrible hack
    if not hasattr(boss, 'gitstatusd'):
        boss.gitstatusd = _GitStatusD()

    tm = boss.active_tab_manager
    if tm is None: return
    w = tm.active_window
    if w is None: return
    cwd = w.cwd_of_child

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
    except: return
    return f'{git_status}{git_branch}'

def _refresh_widgets(boss: Boss) -> None:
    result = ''

    git_info = _get_git_info(boss)
    if git_info is not None:
        result += ''.join(git_info) + '\n'

    tab_manager = boss.active_tab_manager
    if tab_manager is not None:
        active_id = (active_tab := tab_manager.active_tab) and active_tab.id
        def get_title(tab) -> str:
            cwd = tab.get_cwd_of_active_window() or '??'
            cwd = '/'.join(cwd.split('/')[-2:])
            active = '' if tab.id == active_id else 'class="faint" '
            return active + cwd
        tab_titles = [get_title(tab) for tab in tab_manager.tabs]
        result += '\n'.join(tab_titles) + '\n'

    subprocess.run(
        [os.path.expanduser('~/.bin/widgets'), '--set', 'kitty'],
        input=result,
        text=True
    )

def on_cmd_startstop(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _refresh_widgets(boss)

def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _refresh_widgets(boss)

def on_title_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _refresh_widgets(boss)
