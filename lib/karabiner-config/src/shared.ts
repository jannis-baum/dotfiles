import { FromKeyParam, ifVar, mapSimultaneous } from 'karabiner.ts';

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

export function sim(from: `${SingleChar<FromKeyParam>}${SingleChar<FromKeyParam>}`): ReturnType<typeof mapSimultaneous> {
    const [a, b] = from.split('') as [FromKeyParam, FromKeyParam]
    return mapSimultaneous([a, b]).modifiers('optionalAny')
}
