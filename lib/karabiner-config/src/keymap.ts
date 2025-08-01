import {
    writeToProfile,
    rule, map, withMapper,
    FromKeyParam,
    toApp, ToEvent, ToKeyParam,
    ifApp, ifVar,
} from 'karabiner.ts'
import { combi } from './combis';
import { ifLang, mapLangChars, mapLangSet } from './languages';
import { fullSimlayer, uniformSimlayer } from './layers';
import { tk, resolveChar, toDelayedSetVar } from './shared';
import { kVmapTextObjects, kVnnoremap, kVonoremap, setWin, toHideKitty, toScrolla, toSynapse, toWooshy } from './apps';

writeToProfile('karabiner.ts',
    [
        // THUMB KEYS ----------------------------------------------------------
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),

            map('left⌘').to('left⌘').toIfAlone(toSynapse()),
            map('right⌘').to('right⌘').condition(ifApp('kitty').unless()).toIfAlone(toApp('kitty')),
            map('right⌘').to('right⌘').condition(ifApp('kitty')).toIfAlone(toHideKitty()),

            mapLangSet('left⌥', 'spanish'),
            mapLangSet('right⌥', 'german'),
        ]),


        // COMBI KEYS ----------------------------------------------------------
        rule('upper row combos').manipulators([
            // UPPER ROW
            combi('we').to('↑'),
            combi('er').to('→'),
            combi('rt').to$('~/.config/kitty/scripts/viclip-tab'),
            combi('yu').to(toScrolla()),
            combi('ui').condition(ifApp('kitty').unless()).to(toWooshy()),
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
            // directory prefix
            combi('./').condition(ifApp('kitty')).to(resolveChar('~')).to('/')
                .condition(ifVar('path-prefix').unless())
                .toVar('path-prefix', true)
                .to(toDelayedSetVar('path-prefix', false)),
            map('/').condition(ifApp('kitty')).condition(ifVar('path-prefix', true))
                .to(resolveChar('_')).to('/')
                .toVar('path-prefix', false)
        ]),


        // LAYERS --------------------------------------------------------------
        // chars
        fullSimlayer(['a', ';'], 'char-mode', {
            w: '~', e: '`', r: '^', t: '$',  y: '#', u: '*',  i:  '[',  o:  ']',
            s: '"', d: "'", f: '|', g: '\\', h: '%', j: '-',  k:  '(',  l:  ')',
            x: '+', c: '=', v: '!', b: '@',  n: '&', m: '_', ',': '{', '.': '}'
        } as const, (k, v) => map(k).to(resolveChar(v))),

        // numbers
        fullSimlayer('z', 'number-mode', {
                  u: 7,  i:  8,  o:  9,
                  j: 4,  k:  5,  l:  6,
            n: 0, m: 1, ',': 2, '.': 3,
        } as const, (k, i) => map(k).to(`keypad_${i as 0}`)),

        // gui
        fullSimlayer<FromKeyParam, ToEvent>('/', 'gui-mode', {
                          w: tk('⌘_0'), e: setWin('0,0_1x1'), r: setWin('next_screen'), t: setWin('1,0_1x1'), y: setWin('0,0_2x1'),
            a: tk('⌘_='), s: tk('⌘_-'), d: setWin('0,0_1x2'), f: setWin('0,0_2x2'),     g: setWin('1,0_1x2'),
            z: tk('⌘_['), x: tk('⌘_]'), c: setWin('0,1_1x1'), v: setWin('prev_screen'), b: setWin('1,1_1x1'), n: setWin('0,1_2x1'),
        } as const, (k, v) => map(k).to(v)),

        // control
        // doubled up so we can also press ctrl-q and ctrl-p
        uniformSimlayer('q', 'control-mode-q', (k) => map(k).to(tk(`⌃_${k as ToKeyParam}`))),
        uniformSimlayer('p', 'control-mode-p', (k) => map(k).to(tk(`⌃_${k as ToKeyParam}`))),

        // LANGUAGES -----------------------------------------------------------
        // spanish
        rule('spanish characters', ifLang('spanish')).manipulators([
            mapLangChars('n', '⌥_n'),
            withMapper(['a', 'e', 'i', 'o', 'u'])((k) => mapLangChars(k, '⌥_e')),
        ]),

        // german
        rule('german characters', ifLang('german')).manipulators([
            map('s').to(tk('⌥_s')).toUnsetVar('lang'),
            withMapper(['a', 'o', 'u'])((k) => mapLangChars(k, '⌥_u')),
        ]),

        // kindaVim ------------------------------------------------------------
        rule('kV nnoremap', kVnnoremap()).manipulators([
            map('y', '⇧').to('y').to(resolveChar('$')),
        ]),
        rule('kV text objects').manipulators([
            kVmapTextObjects({
                d: resolveChar("'"), s: resolveChar('"'), e: resolveChar('`'),
                l: resolveChar('('), o: resolveChar(']'), '.': resolveChar('}'),
            })
        ]),

        // MISC ----------------------------------------------------------------
        rule('disable caps').manipulators([
            map('caps_lock', 'optionalAny').toNone()
        ]),
    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 500,
       'basic.simultaneous_threshold_milliseconds': 20,
    }
);

