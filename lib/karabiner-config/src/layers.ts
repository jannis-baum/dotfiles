import { simlayer, map, withMapper, FromKeyParam, LayerKeyParam } from 'karabiner.ts';
import { ShortTo, to } from './shared';

// `withFullMapper` always maps `allKeys` (except for `ignoreKeys`), ommitted
// keys are mapped to None
const allKeys = [...
    'qwertyuiop' +
    'asdfghjkl;' +
    'zxcvbnm,./'
] as Array<FromKeyParam>;

function withFullMapper<const K extends string | number, const V>(
    src: Partial<Record<K, V>>,
    ignoreKeys: Array<string | number>
): ReturnType<typeof withMapper<K,V>> {
    // complete src array/obj by adding in keys to map to none
    const completedMap = (() => {
        const relevantKeys = allKeys.filter((k) => !ignoreKeys.includes(k))
        // if src is array we can just return allKeys
        if (Array.isArray(src)) return relevantKeys as Partial<Record<K, V>>;
        // if not we add missing keys with value 0 to object
        return relevantKeys.filter((k) => !(k in src)).reduce((o, key) => ({ ...o, [key]: 0 }), { ...src })
    })()
    return (mapper) => {
        return withMapper(completedMap)((k, v) => {
            // if original src included key, call provided wrapper
            if (Array.isArray(src) && src.includes(k) || k in src) {
                return mapper(k, v)
            }
            // else map to none
            return map(k as FromKeyParam).toNone()
        });
    }
}

// helper to make full simlayer by omitting none-map for simlayer key(s)
function fullSimlayer<const K extends string | number, const V>(
    key: LayerKeyParam | LayerKeyParam[],
    varName: string | undefined,
    mapping: Partial<Record<K, V>>,
    mapper: Parameters<ReturnType<typeof withFullMapper<K, V>>>[0],
): ReturnType<typeof simlayer> {
    return simlayer(key, varName).manipulators([
        withFullMapper(mapping, Array.isArray(key) ? key : [key])(mapper)
    ])
}

const charMap = {
    '!': '⇧_1', '@': '⇧_2', '#': '⇧_3', '$': '⇧_4', '%': '⇧_5',
    '^': '⇧_6', '&': '⇧_7', '*': '⇧_8', '(': '⇧_9', ')': '⇧_0',
    '{': '⇧_[', '}': '⇧_]', '|': '⇧_\\', '"': '⇧_\'',
    '~': '⇧_`', '_': '⇧_-', '+': '⇧_='
} as const;
function resolve(arg: keyof typeof charMap | ShortTo): ShortTo {
    if (arg in charMap) return charMap[arg];
    return arg as ShortTo;
}


export default [
    fullSimlayer(['a', ';'], 'char-mode', {
        w: '~', e: '`', r: '^', t: '$',  y: '#', u: '*', i:   '[', o:   ']',
        s: '"', d: "'", f: '|', g: '\\', h: '%', j: '-', k:   '(', l:   ')',
        x: '+', c: '=', v: '!', b: '@',  n: '&', m: '_', ',': '{', '.': '}'
    } as const, (k, v) => map(k).to(...to(resolve(v)))),

    fullSimlayer('z', 'number-mode', {
        u: 7, i: 8, o: 9,
        j: 4, k: 5, l: 4,
        n: 0, m: 1, ',': 2, '.': 3,
    } as const, (k, i) => map(k).to(`keypad_${i as 0}`)),
]
