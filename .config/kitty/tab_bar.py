# pyright: reportMissingImports=false

from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

import subprocess, atexit, os

# copied & modified from
# https://github.com/kovidgoyal/watcher/blob/master/watcher/gitstatusd.py
class GitStatusD:
    def __init__(self):
        self.process = subprocess.Popen([
            '/usr/local/opt/gitstatus/usrbin/gitstatusd-darwin-x86_64',
            '--num-threads=16' # should be 2 * number of virtual cpu
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

def get_git_info():
    boss = get_boss()
    # forgive the horrible hack
    if not hasattr(boss, 'gitstatusd'):
        boss.gitstatusd = GitStatusD()

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
        git_status = f' ✻' if dirty > 0 else '  '
    except: return
    return (git_branch, git_status)

def draw_right(data: list[tuple[str, bool]], draw_data: DrawData, screen: Screen):
    spaces = screen.columns - screen.cursor.x - sum((len(text) for text, _ in data))
    screen.draw(' ' * spaces)
    for text, is_active in data:
        screen.cursor.fg = 0 if not is_active else \
            as_rgb(color_as_int(draw_data.active_fg))
        screen.draw(text)
    screen.cursor.fg = 0

def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    if index != 1 or not is_last:
        if draw_data.leading_spaces:
            screen.draw(' ' * draw_data.leading_spaces)
        draw_title(draw_data, screen, tab, index)
        trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
        max_title_length -= trailing_spaces
        extra = screen.cursor.x - before - max_title_length
        if extra > 0:
            screen.cursor.x -= extra + 1
            screen.draw('…')
        if trailing_spaces:
            screen.draw(' ' * trailing_spaces)

    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    end = screen.cursor.x

    if is_last:
        right_data: list[tuple[str, bool]] = list()
        
        try:
            active_window = get_boss().active_window_for_cwd
            active_pid = active_window.child.pid
            with open(f'/tmp/current-jobs-{active_pid}', 'r') as fp:
                job_count = fp.read().replace(' ', '')
                if int(job_count) > 0:
                    right_data.append((job_count + ' ', True))
        except: pass

        git_info = get_git_info()
        if git_info:
            right_data += [(git_info[0], False), (git_info[1], True)]

        draw_right(right_data, draw_data, screen)
    else:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)

    screen.cursor.bg = 0
    return end
