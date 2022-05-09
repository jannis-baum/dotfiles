from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

import subprocess

def draw_git_info(draw_data: DrawData, screen: Screen):
    tm = get_boss().active_tab_manager
    if tm is None: return
    w = tm.active_window
    if w is None: return
    cwd = w.cwd_of_child

    # TODO: do this with python instead of lazy bash
    try:
        git_branch = subprocess.check_output(['bash', '-c', f'git -C {cwd} symbolic-ref --short HEAD || git -C {cwd} rev-parse --short HEAD'])[:-1].decode('utf-8')
        git_status = subprocess.check_output(['bash', '-c', f'[[ `git -C {cwd} status -s` == "" ]] && printf "  " || printf " ✻"'], timeout=0.07).decode('utf-8')
    except subprocess.TimeoutExpired:
        git_status = ' ×'
    except: return
    spaces = screen.columns - screen.cursor.x - len(git_status) - len(git_branch)
    screen.draw(' ' * spaces)
    screen.draw(git_branch)
    screen.cursor.fg = as_rgb(color_as_int(draw_data.active_fg))
    screen.draw(git_status)
    screen.cursor.fg = 0

def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
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
    end = screen.cursor.x
    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if is_last:
        draw_git_info(draw_data, screen)
        pass
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return end
