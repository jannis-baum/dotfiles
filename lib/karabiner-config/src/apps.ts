import { ifVar, to$ } from "karabiner.ts";


// kindaVim
export const kVnnoremap = () => ifVar('kVnnoremap', true);

// hammerspoon
export const setWin = (s: string) => to$(`open -g hammerspoon://moveWindow?to=${s}`)
