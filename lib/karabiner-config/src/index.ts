import {
    writeToProfile,
    rule, simlayer,
    map, mapSimultaneous, withMapper,
    toApp,
    ifApp, ifVar,
} from 'karabiner.ts'

const kVnnoremap = () => ifVar('kVnnoremap', true);

writeToProfile('karabiner.ts',
    [
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),
            map('left⌘').to('left⌘').toIfAlone('f7', ['⌘', 'fn']),
            map('right⌘').to('right⌘').toIfAlone(toApp('kitty')).condition(ifApp('kitty').unless()),
            map('right⌘').to('right⌘').toIfAlone('h', '⌘').condition(ifApp('kitty'))
        ]),

        rule('home row combos: sd > ⇥, df > ⌫, jk > ⎋, kl > ⏎').manipulators([
            mapSimultaneous(['s', 'd']).modifiers('optionalAny').to('⇥'),
            mapSimultaneous(['d', 'f']).modifiers('optionalAny').to('⌫'),
            mapSimultaneous(['j', 'k']).modifiers('optionalAny').to('⎋'),
            mapSimultaneous(['k', 'l']).modifiers('optionalAny').to('⏎'),
        ]),

        rule('upper row combos: we > ↑, er > →, rt > viclip, yu > scrolla (CFf9), ui > ctrl+u, io > ctrl+o').manipulators([
            mapSimultaneous(['w', 'e']).modifiers('optionalAny').to('↑'),
            mapSimultaneous(['e', 'r']).modifiers('optionalAny').to('→'),
            mapSimultaneous(['r', 't']).modifiers('optionalAny').to$('~/.config/kitty/viclip-tab.zsh'),
            mapSimultaneous(['y', 'u']).modifiers('optionalAny').to('f9', ['⌘', 'fn']),
            // in kitty
            mapSimultaneous(['u', 'i']).condition(ifApp('kitty')).to('u', '⌃'),
            mapSimultaneous(['i', 'o']).condition(ifApp('kitty')).to('o', '⌃'),
        ]),

        rule('lower row combos: xc > ←, cv > ↓, m, > tab left ,. > tab right').manipulators([
            mapSimultaneous(['x', 'c']).modifiers('optionalAny').to('←'),
            mapSimultaneous(['c', 'v']).modifiers('optionalAny').to('↓'),
            // tab switching complicated because it's different in xcode & kv
            // doesn't pass through control character
            // prev tab
            mapSimultaneous(['m', ',']).condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', ['⌃', '⇧']),
            mapSimultaneous(['m', ',']).condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', ['⌃', '⇧']).to('⎋'),
            mapSimultaneous(['m', ',']).condition(ifApp('Xcode'), kVnnoremap().unless()).to('[', ['⌘', '⇧']),
            mapSimultaneous(['m', ',']).condition(ifApp('Xcode'), kVnnoremap()).to('a').to('[', ['⌘', '⇧']).to('⎋'),
            // next tab
            mapSimultaneous([',', '.']).condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', '⌃'),
            mapSimultaneous([',', '.']).condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', '⌃').to('⎋'),
            mapSimultaneous([',', '.']).condition(ifApp('Xcode'), kVnnoremap().unless()).to(']', ['⌘', '⇧']),
            mapSimultaneous([',', '.']).condition(ifApp('Xcode'), kVnnoremap()).to('a').to(']', ['⌘', '⇧']).to('⎋'),
        ]),

        simlayer(['a', ';'], 'char-mode').manipulators([
            // upper row
            map('q').to('vk_none'), map('w').to('`', '⇧'), map('e').to('`'), map('r').to('6', '⇧'), map('t').to('4', '⇧'),
            map('y').to('3', '⇧'), map('u').to('8', '⇧'), map('i').to('['), map('o').to(']'), map('p').to('vk_none'),
            // home row
            map('s').to('\'', '⇧'), map('d').to('\''), map('f').to('\\', '⇧'), map('g').to('\\'),
            map('h').to('5', '⇧'), map('j').to('-'), map('k').to('9', '⇧'), map('l').to('0', '⇧'),
            // lower row
            map('z').to('vk_none'), map('x').to('=', '⇧'), map('c').to('='), map('v').to('1', '⇧'), map('b').to('2', '⇧'),
            map('n').to('7', '⇧'), map('m').to('[', '⇧'), map('.').to(']', '⇧'), map('/').to('vk_none')
        ]),

        simlayer('z', 'number-mode').manipulators([
            // keypad mapping
            withMapper({
                        'u': 7, 'i': 8, 'o': 9,
                        'j': 4, 'k': 5, 'l': 4,
                'n': 0, 'm': 1, ',': 2, '.': 3,
            } as const)((k, i) => map(k).to(`keypad_${i as 0}`)),
            // disable other keys
            withMapper([
                'q', 'w', 'e', 'r', 't', 'y',                'p',
                'a', 's', 'd', 'f', 'g', 'h',                ';',
                     'x', 'c', 'v', 'b',                     '/',
            ] as const)((k) => map(k).to('vk_none'))
        ])
    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 0,
       'basic.simultaneous_threshold_milliseconds': 30,
    }
);
