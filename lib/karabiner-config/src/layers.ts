import { simlayer, map, withMapper, FromKeyParam } from 'karabiner.ts';
import { ShortTo, to } from './shared';

const charMap = {
    '!': '⇧_1', '@': '⇧_2', '#': '⇧_3', '$': '⇧_4', '%': '⇧_5',
    '^': '⇧_6', '&': '⇧_7', '*': '⇧_8', '(': '⇧_9', ')': '⇧_0',
    '{': '⇧_[', '}': '⇧_]', '|': '⇧_\\', '"': '⇧_\'',
    '~': '⇧_`', '_': '⇧_-'
} as const;
function resolve(arg: keyof typeof charMap | ShortTo): ShortTo {
    if (arg in charMap) return charMap[arg];
    return arg as ShortTo;
}

const allKeys = Array('qwertyuiop' + 'asdfghjkl;\'' + 'zxcvbnm,./') as Array<FromKeyParam>;
function withFullMapper(...params: Parameters<typeof withMapper>): ReturnType<typeof withMapper> {
    const mapInput = params[0];
    const unspecifiedKeys = (() => {
        if (Array.isArray(mapInput)) {
            return allKeys.filter((k) => !mapInput.includes(k))
        }
        return allKeys.filter((k) => !(k in mapInput))
    })()
    return (mapper) => {
        return withMapper(mapInput)((k, v) => {
            const kp = k as FromKeyParam;
            return unspecifiedKeys.includes(kp) ? map(kp).toNone() : mapper(k, v)
        });
    }
}

export default [
        simlayer(['a', ';'], 'char-mode').manipulators([
            // upper row
            map('q').to('vk_none'), map('w').to(...to('⇧_`')), map('e').to('`'), map('r').to('6', '⇧'), map('t').to('4', '⇧'),
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
]
