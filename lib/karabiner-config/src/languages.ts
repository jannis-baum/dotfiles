import { FromKeyParam, ifVar, map, ToKeyParam, toSetVar, toUnsetVar, withMapper } from "karabiner.ts";
import { ShortTo, tk } from "./shared";

// map upper & lower case char to be pressed after given language prefix, then
// unset `lang` variable
export function mapLangChars(from: FromKeyParam & ToKeyParam, prefix: ShortTo) {
    const maps = [
        map(from).to(tk(prefix)).to(from).toUnsetVar('lang'),
        map(from, '⇧').to(tk(prefix)).to(from, '⇧').toUnsetVar('lang'),
    ];
    return withMapper(maps)((m) => m);
}

// set language var
export function mapLangSet(from: FromKeyParam & ToKeyParam, language: string) {
    const maps = [
        // set
        map(from).to(from).condition(ifVar('lang', language).unless())
            .toIfAlone(toSetVar('lang', language)).toDelayedAction(toUnsetVar('lang'), []),
        // unset
        map(from).to(from).condition(ifVar('lang', language)).toIfAlone(toUnsetVar('lang')),
    ];
    return withMapper(maps)((m) => m);
}

// language var condition
export function ifLang(language: string) {
    return ifVar('lang', language);
}
