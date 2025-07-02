import {
    writeToProfile,
    rule,
    map,
    toApp,
    ifApp,
} from 'karabiner.ts'
import combos from './combos';
import layers from './layers';

writeToProfile('karabiner.ts',
    [
        rule('thumb keys').manipulators([
            map('␣', 'optionalAny').to('left⇧').toIfAlone('␣'),
            map('left⌘').to('left⌘').toIfAlone('f7', ['⌘', 'fn']),
            map('right⌘').to('right⌘').toIfAlone(toApp('kitty')).condition(ifApp('kitty').unless()),
            map('right⌘').to('right⌘').toIfAlone('h', '⌘').condition(ifApp('kitty'))
        ]),

        ...combos,
        ...layers,
    ],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 0,
       'basic.simultaneous_threshold_milliseconds': 30,
    }
);
