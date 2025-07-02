import { simlayer, map, withMapper, FromKeyParam, LayerKeyParam } from 'karabiner.ts';


// `withFullMapper` always maps `allKeys` (except for `ignoreKeys`), ommitted
// keys are mapped to None
const allKeys = [...
    'qwertyuiop' +
    'asdfghjkl;' +
    'zxcvbnm,./'
] as Array<FromKeyParam>;

export function withFullMapper<const K extends string | number, const V>(
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
export function fullSimlayer<const K extends string | number, const V>(
    key: LayerKeyParam | LayerKeyParam[],
    varName: string | undefined,
    mapping: Partial<Record<K, V>>,
    mapper: Parameters<ReturnType<typeof withFullMapper<K, V>>>[0],
): ReturnType<typeof simlayer> {
    return simlayer(key, varName).manipulators([
        withFullMapper(mapping, Array.isArray(key) ? key : [key])(mapper)
    ])
}


// uniform transformation on all keys except ignored ones
export function withUniformMapper(
  ignoreKeys: Array<string | number>
): ReturnType<typeof withMapper<FromKeyParam, number>> {
    return withMapper(allKeys.filter((k) => !ignoreKeys.includes(k)));
}


// helper to make uniform simlayer by omitting map for simlayer key(s)
export function uniformSimlayer(
    key: LayerKeyParam | LayerKeyParam[],
    varName: string | undefined,
    mapper: Parameters<ReturnType<typeof withUniformMapper>>[0],
): ReturnType<typeof simlayer> {
    return simlayer(key, varName).manipulators([
        withUniformMapper(Array.isArray(key) ? key : [key])(mapper)
    ])
}
