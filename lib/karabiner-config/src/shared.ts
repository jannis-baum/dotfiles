import {
  FromKeyParam, Modifier, ModifierParam, modifierKeyAliases, ToKeyParam,
  ifVar,
  mapSimultaneous,
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
// helper to convert to `.to` arguments
export function to(short: ShortTo): ToArgs {
    const split = short.split('_')
    if (split.length == 1) return [split[0] as ToKeyParam, undefined]
    const modifiers = Array.from(split[0]).map((m) => modifierKeyAliasesExt[m]) as Array<Modifier>
    const toParam = split.splice(1).join('_') as ToKeyParam
    return [toParam, modifiers]
}


export function sim(from: `${SingleChar<FromKeyParam>}${SingleChar<FromKeyParam>}`): ReturnType<typeof mapSimultaneous> {
    const [a, b] = from.split('') as [FromKeyParam, FromKeyParam]
    return mapSimultaneous([a, b]).modifiers('optionalAny')
}
