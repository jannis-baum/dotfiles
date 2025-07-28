import { ifVar, to$, map, withMapper, toKey, FromKeyParam } from "karabiner.ts";
import { tk } from "./shared";


// kindaVim
export const kVnnoremap = () => ifVar('kVnnoremap', true);
export const kVonoremap = () => ifVar('kVonoremap', true);

export function kVmapTextObjects(
    mapping: Partial<Record<FromKeyParam, ReturnType<typeof toKey>>>
) {
    return withMapper(mapping)(
        (from, to) => withMapper(["i", "a"])(
            (ia) => map(from).to(to).condition(ifVar("kVPendingKey", ia))
        )
    )
}

// open/activate apps with hotkeys
export const toSynapse = () => tk('⌘f_f7')
export const toWooshy = () => tk('⌘f_f8')
export const toScrolla = () => tk('⌘f_f9')
export const toHideKitty = () => tk('⌘_u')

// hammerspoon
export const setWin = (s: string) => to$(`open -g hammerspoon://moveWindow?to=${s}`)
