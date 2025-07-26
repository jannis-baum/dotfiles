import { ifVar, to$, map, withMapper, toSetVar, toKey, FromKeyParam } from "karabiner.ts";
import { tk } from "./shared";


// kindaVim
export const kVnnoremap = () => ifVar('kVnnoremap', true);
export const kVonoremap = () => ifVar('kVonoremap', true);

export function kVmapTextObjects(
    mapping: Partial<Record<FromKeyParam, ReturnType<typeof toKey>>>
) {
    const varName = "kVTextObjectPending"
    let maps = [withMapper(mapping)(
        (from, to) => map(from).to(to).condition(ifVar(varName, true))
    )]

    for (const mode of ["o", "x"]) {
        for (const ia of ["i", "a"] as const) {
            maps.push(
                map(ia)
                    .condition(ifVar(`kV${mode}noremap`, true))
                    .to([toKey(ia), toSetVar(varName, true)])
                    .toDelayedAction(toSetVar(varName, false), toSetVar(varName, false))
            );
        }
    }

    return withMapper(maps)((m) => m)
}

// open/activate apps with hotkeys
export const toSynapse = () => tk('⌘f_f7')
export const toWooshy = () => tk('⌘f_f8')
export const toScrolla = () => tk('⌘f_f9')
export const toHideKitty = () => tk('⌘_u')

// hammerspoon
export const setWin = (s: string) => to$(`open -g hammerspoon://moveWindow?to=${s}`)
