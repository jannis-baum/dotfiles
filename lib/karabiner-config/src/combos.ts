import { ifApp, rule } from 'karabiner.ts';
import { kVnnoremap, sim } from './shared';


export default [
    rule('upper row combos').manipulators([
        sim('we').to('↑'),
        sim('er').to('→'),
        sim('rt').to$('~/.config/kitty/viclip-tab.zsh'),
        sim('yu').to('f9', ['⌘', 'fn']),
        // in kitty
        sim('ui').condition(ifApp('kitty')).to('u', '⌃'),
        sim('io').condition(ifApp('kitty')).to('o', '⌃'),
    ]),

    rule('home row combos').manipulators([
        sim('sd').to('⇥'),
        sim('df').to('⌫'),
        sim('jk').to('⎋'),
        sim('kl').to('⏎'),
    ]),

    rule('lower row combos: xc > ←, cv > ↓, m, > tab left ,. > tab right').manipulators([
        sim('xc').to('←'),
        sim('cv').to('↓'),
        // tab switching complicated because it's different in xcode & kv
        // doesn't pass through control character
        // prev tab
        sim('m,').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', ['⌃', '⇧']),
        sim('m,').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', ['⌃', '⇧']).to('⎋'),
        sim('m,').condition(ifApp('Xcode'), kVnnoremap().unless()).to('[', ['⌘', '⇧']),
        sim('m,').condition(ifApp('Xcode'), kVnnoremap()).to('a').to('[', ['⌘', '⇧']).to('⎋'),
        // next tab
        sim(',.').condition(ifApp('Xcode').unless(), kVnnoremap().unless()).to('⇥', '⌃'),
        sim(',.').condition(ifApp('Xcode').unless(), kVnnoremap()).to('a').to('⇥', '⌃').to('⎋'),
        sim(',.').condition(ifApp('Xcode'), kVnnoremap().unless()).to(']', ['⌘', '⇧']),
        sim(',.').condition(ifApp('Xcode'), kVnnoremap()).to('a').to(']', ['⌘', '⇧']).to('⎋'),
    ]),
]
