import {
  Modifier, ModifierParam, modifierKeyAliases, ToKeyParam,
  ifVar,
  toKey,
} from 'karabiner.ts';

// kindaVim
export const kVnnoremap = () => ifVar('kVnnoremap', true);


// helper to filter for single character string codes
export type SingleChar<T> = T extends string // filter out non-strings
  ? T extends `${infer _}${infer R}` // concat prefix char & remainder char
      ? R extends '' // remainder is an empty string, it's a single character
        ? T
        : never
      : never
  : never;


// helper to write short to's with modifiers
// extend modifier aliases to include fn
export const modifierKeyAliasesExt = {
  'f': 'fn',
  ...modifierKeyAliases
}
// type & combinations of modifiers
export type ModifierKeyAliasExt = keyof typeof modifierKeyAliasesExt;
type _MultipleModifiers = ModifierKeyAliasExt |
    `${ModifierKeyAliasExt}${ModifierKeyAliasExt}` |
    `${ModifierKeyAliasExt}${ModifierKeyAliasExt}${ModifierKeyAliasExt}`;
// short hand to as `<single char modifier list>_<to>`
export type ShortTo = `${'' | `${_MultipleModifiers}_`}${ToKeyParam}`;
// helper type
export type ToArgs = [ToKeyParam, ModifierParam?];
// helper to convert short hand to `toKey` result
export function tk(short: ShortTo): ReturnType<typeof toKey> {
    const split = short.split('_');
    if (split.length == 1) return toKey(split[0] as ToKeyParam);
    const modifiers = Array.from(split[0]).map((m) => modifierKeyAliasesExt[m]) as Array<Modifier>;
    const toParam = split.splice(1).join('_') as ToKeyParam;
    return toKey(toParam, modifiers);
}


const charMap = {
    '!': '⇧_1', '@': '⇧_2', '#': '⇧_3', '$': '⇧_4', '%': '⇧_5',
    '^': '⇧_6', '&': '⇧_7', '*': '⇧_8', '(': '⇧_9', ')': '⇧_0',
    '{': '⇧_[', '}': '⇧_]', '|': '⇧_\\', '"': '⇧_\'',
    '~': '⇧_`', '_': '⇧_-', '+': '⇧_='
} as const;
export function resolveChar(arg: keyof typeof charMap | ShortTo): ReturnType<typeof tk> {
    if (arg in charMap) return tk(charMap[arg]);
    return tk(arg as ShortTo);
}
