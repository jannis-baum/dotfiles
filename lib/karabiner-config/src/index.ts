import { writeToProfile } from 'karabiner.ts'

writeToProfile('karabiner.ts',
    [],
    {
       'basic.to_if_alone_timeout_milliseconds': 300,
       'basic.to_if_held_down_threshold_milliseconds': 50,
       'basic.to_delayed_action_delay_milliseconds': 0,
       'basic.simultaneous_threshold_milliseconds': 30,
    }
)
