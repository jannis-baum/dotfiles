import { FromKeyParam, ifVar, map, ToKeyParam, toSetVar, withMapper } from "karabiner.ts";
import { ShortTo, tk, toDelayedSetVar } from "./shared";

// map upper & lower case char to be pressed after given language prefix, then
// unset `lang` variable
export function mapLangChars(from: FromKeyParam & ToKeyParam, prefix: ShortTo) {
    const maps = [
        map(from).to(tk(prefix)).to(from).toVar('lang', false),
        map(from, '⇧').to(tk(prefix)).to(from, '⇧').toVar('lang', false),
    ];
    return withMapper(maps)((m) => m);
}

// set language var
export function mapLangSet(from: FromKeyParam & ToKeyParam, language: string) {
    return map(from).to(from)
        .condition(ifVar('lang', language).unless())
        .toIfAlone(toSetVar('lang', language))
        .to(toDelayedSetVar('lang', false));
}

// language var condition
export function ifLang(language: string) {
    return ifVar('lang', language);
}
