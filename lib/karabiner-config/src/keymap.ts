import {
    writeToProfile,
    rule,
    map,
    toApp,
    ifApp,
} from 'karabiner.ts'
import { combi } from './combis';
import { fullSimlayer } from './layers';
import { kVnnoremap, to, resolveChar } from './shared';

writeToProfile('karabiner.ts',
    [
        // thumb keys
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),
            map('left⌘').to('left⌘').toIfAlone('f7', ['⌘', 'fn']),
            map('right⌘').to('right⌘').toIfAlone(toApp('kitty')).condition(ifApp('kitty').unless()),
            map('right⌘').to('right⌘').toIfAlone('h', '⌘').condition(ifApp('kitty'))
        ]),

        // combi keys
        rule('upper row combos').manipulators([
            // UPPER ROW
            combi('we').to('↑'),
            combi('er').to('→'),
            combi('rt').to$('~/.config/kitty/viclip-tab.zsh'),
            combi('yu').to('f9', ['⌘', 'fn']),
            // in kitty
            combi('ui').condition(ifApp('kitty')).to('u', '⌃'),
            combi('io').condition(ifApp('kitty')).to('o', '⌃'),

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
            combi('m,').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', ['⌃', '⇧']),
            combi('m,').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', ['⌃', '⇧']).to('⎋'),
            combi('m,').condition(ifApp('Xcode'), kVnnoremap().unless()).to('[', ['⌘', '⇧']),
            combi('m,').condition(ifApp('Xcode'), kVnnoremap()).to('a').to('[', ['⌘', '⇧']).to('⎋'),
            // next tab
            combi(',.').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', '⌃'),
            combi(',.').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', '⌃').to('⎋'),
            combi(',.').condition(ifApp('Xcode'), kVnnoremap().unless()).to(']', ['⌘', '⇧']),
            combi(',.').condition(ifApp('Xcode'), kVnnoremap()).to('a').to(']', ['⌘', '⇧']).to('⎋'),
        ]),

        // layers
        fullSimlayer(['a', ';'], 'char-mode', {
            w: '~', e: '`', r: '^', t: '$',  y: '#', u: '*', i:   '[', o:   ']',
            s: '"', d: "'", f: '|', g: '\\', h: '%', j: '-', k:   '(', l:   ')',
            x: '+', c: '=', v: '!', b: '@',  n: '&', m: '_', ',': '{', '.': '}'
        } as const, (k, v) => map(k).to(...to(resolveChar(v)))),

        fullSimlayer('z', 'number-mode', {
            u: 7, i: 8, o: 9,
            j: 4, k: 5, l: 4,
            n: 0, m: 1, ',': 2, '.': 3,
        } as const, (k, i) => map(k).to(`keypad_${i as 0}`)),

    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 0,
       'basic.simultaneous_threshold_milliseconds': 30,
    }
);
