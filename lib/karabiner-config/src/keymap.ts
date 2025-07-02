import {
  writeToProfile, rule, map, toApp, ifApp,
  ToEvent, FromKeyParam, ToKeyParam,
} from 'karabiner.ts'
import { combi } from './combis';
import { fullSimlayer, uniformSimlayer } from './layers';
import { tk, resolveChar } from './shared';
import { kVnnoremap, setWin } from './apps';

writeToProfile('karabiner.ts',
    [
        // thumb keys
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),
            map('left⌘').to('left⌘').toIfAlone(tk('⌘f_f7')),
            map('right⌘').to('right⌘').toIfAlone(toApp('kitty')).condition(ifApp('kitty').unless()),
            map('right⌘').to('right⌘').toIfAlone(tk('⌘_h')).condition(ifApp('kitty'))
        ]),


        // combi keys
        rule('upper row combos').manipulators([
            // UPPER ROW
            combi('we').to('↑'),
            combi('er').to('→'),
            combi('rt').to$('~/.config/kitty/viclip-tab.zsh'),
            combi('yu').to(tk('⌘f_f9')),
            // in kitty
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


        // layers
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
        uniformSimlayer(['q', 'p'], 'control-mode', (k) => map(k).to(tk(`⌃_${k as ToKeyParam}`)))
    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 0,
       'basic.simultaneous_threshold_milliseconds': 30,
    }
);

