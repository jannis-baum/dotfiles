import {
  writeToProfile, rule, map, toApp, ifApp,
  ToEvent, FromKeyParam, ToKeyParam,
} from 'karabiner.ts'
import { combi } from './combis';
import { ifLang, mapLangChars, mapLangSet } from './languages';
import { fullSimlayer, uniformSimlayer } from './layers';
import { tk, resolveChar } from './shared';
import { kVnnoremap, setWin } from './apps';

writeToProfile('karabiner.ts',
    [
        // THUMB KEYS ----------------------------------------------------------
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),

            map('left⌘').to('left⌘').toIfAlone(tk('⌘f_f7')),
            map('right⌘').to('right⌘').toIfAlone(toApp('kitty')).condition(ifApp('kitty').unless()),
            map('right⌘').to('right⌘').toIfAlone(tk('⌘_u')).condition(ifApp('kitty')),

            mapLangSet('left⌥', 'spanish'),
            mapLangSet('right⌥', 'german'),
        ]),


        // COMBI KEYS ----------------------------------------------------------
        rule('upper row combos').manipulators([
            // UPPER ROW
            combi('we').to('↑'),
            combi('er').to('→'),
            combi('rt').to$('~/.config/kitty/viclip-tab.zsh'),
            combi('yu').to(tk('⌘f_f9')), // scrolla
            combi('ui').condition(ifApp('kitty').unless()).to(tk('⌘f_f8')), // wooshy
            combi('ui').condition(ifApp('kitty')).to(tk('⌃_u')),
            combi('io').condition(ifApp('kitty')).to(tk('⌃_o')),

            // HOME ROW
            combi('sd').to('⇥'),
            combi('df').to('⌫'),
            combi('jk').to('⎋'),
            combi('kl').to('⏎'),

            // LOWER ROW
            combi('xc').to('←'),
            combi('cv').to('↓'),
            // tab switching complicated because it's different in xcode & kv
            // doesn't pass through control character
            // prev tab
            combi('m,').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to(tk('⌃⇧_⇥')),
            combi('m,').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to(tk('⌃⇧_⇥')).to('⎋'),
            combi('m,').condition(ifApp('Xcode'), kVnnoremap().unless()).to(tk('⌘⇧_[')),
            combi('m,').condition(ifApp('Xcode'), kVnnoremap()).to('a').to(tk('⌘⇧_[')).to('⎋'),
            // next tab
            combi(',.').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to(tk('⌃_⇥')),
            combi(',.').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to(tk('⌃_⇥')).to('⎋'),
            combi(',.').condition(ifApp('Xcode'), kVnnoremap().unless()).to(tk('⌘⇧_]')),
            combi(',.').condition(ifApp('Xcode'), kVnnoremap()).to('a').to(tk('⌘⇧_]')).to('⎋'),
        ]),


        // LAYERS --------------------------------------------------------------
        // chars
        fullSimlayer(['a', ';'], 'char-mode', {
            w: '~', e: '`', r: '^', t: '$',  y: '#', u: '*', i:   '[', o:   ']',
            s: '"', d: "'", f: '|', g: '\\', h: '%', j: '-', k:   '(', l:   ')',
            x: '+', c: '=', v: '!', b: '@',  n: '&', m: '_', ',': '{', '.': '}'
        } as const, (k, v) => map(k).to(resolveChar(v))),

        // numbers
        fullSimlayer('z', 'number-mode', {
            u: 7, i: 8, o: 9,
            j: 4, k: 5, l: 4,
            n: 0, m: 1, ',': 2, '.': 3,
        } as const, (k, i) => map(k).to(`keypad_${i as 0}`)),

        // gui
        fullSimlayer<FromKeyParam, ToEvent>('/', 'gui-mode', {
                          w: tk('⌘_0'), e: setWin('0,0_1x1'), r: setWin('next_screen'), t: setWin('1,0_1x1'),
            a: tk('⌘_='), s: tk('⌘_-'), d: setWin('0,0_1x2'), f: setWin('0,0_2x2'),     g: setWin('1,0_1x2'),
            z: tk('⌘_['), x: tk('⌘_]'), c: setWin('0,1_1x1'), v: setWin('prev_screen'), b: setWin('1,1_1x1'),
        } as const, (k, v) => map(k).to(v)),

        // control
        // doubled up so we can also press ctrl-q and ctrl-p
        uniformSimlayer('q', 'control-mode-q', (k) => map(k).to(tk(`⌃_${k as ToKeyParam}`))),
        uniformSimlayer('p', 'control-mode-p', (k) => map(k).to(tk(`⌃_${k as ToKeyParam}`))),

        // LANGUAGES -----------------------------------------------------------
        // spanish
        rule('spanish characters', ifLang('spanish')).manipulators([
            map('n').to(tk('⌥_n')).to('n').toUnsetVar('lang'),
            mapLangChars('a', '⌥_e'),
            mapLangChars('e', '⌥_e'),
            mapLangChars('i', '⌥_e'),
            mapLangChars('o', '⌥_e'),
            mapLangChars('u', '⌥_e'),
        ]),

        // german
        rule('german characters', ifLang('german')).manipulators([
            map('s').to(tk('⌥_s')).toUnsetVar('lang'),
            mapLangChars('a', '⌥_u'),
            mapLangChars('o', '⌥_u'),
            mapLangChars('u', '⌥_u'),
        ]),

        // MISC ----------------------------------------------------------------
        rule('disable caps').manipulators([
            map('caps_lock').toNone()
        ]),
    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 500,
       'basic.simultaneous_threshold_milliseconds': 20,
    }
);

