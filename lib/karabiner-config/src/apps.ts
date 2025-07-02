import { ifVar, to$ } from "karabiner.ts";
import { tk } from "./shared";


// kindaVim
export const kVnnoremap = () => ifVar('kVnnoremap', true);

// open/activate apps with hotkeys
export const toSynapse = () => tk('⌘f_f7')
export const toWooshy = () => tk('⌘f_f8')
export const toScrolla = () => tk('⌘f_f9')
export const toHideKitty = () => tk('⌘_u')

// hammerspoon
export const setWin = (s: string) => to$(`open -g hammerspoon://moveWindow?to=${s}`)
