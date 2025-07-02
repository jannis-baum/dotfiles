import { FromKeyParam, mapSimultaneous } from 'karabiner.ts';
import { SingleChar } from './shared';


export function combi(from: `${SingleChar<FromKeyParam>}${SingleChar<FromKeyParam>}`): ReturnType<typeof mapSimultaneous> {
    const [a, b] = from.split('') as [FromKeyParam, FromKeyParam]
    return mapSimultaneous([a, b]).modifiers('optionalAny')
}
