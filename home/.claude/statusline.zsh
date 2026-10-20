function ponytail() {
    # CLAUDE_CONFIG_DIR overrides ~/.claude, matching where the hooks write the flag (issue #34)
    flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.ponytail-active"
    [[ -f "$flag" ]] || exit 0

    mode=$(head -n1 "$flag" | tr -d '[:space:]')

    if [[ -z "$mode" || "$mode" = "full" ]]; then
        printf '[ponytail]'
    else
        printf "[ponytail:$mode]"
    fi
}

# rate_limits only exists on Pro/Max after the first API response; missing fields are skipped
# one line per value; (@f) splits them into separate array elements
parts=("$(ponytail)" "${(@f)$(jq -r '
    # one block, 8 levels (12.5% each), clamped; ANSI 141 above 70%
    def bar: . as $p | ["▁","▂","▃","▄","▅","▆","▇","█"][[[($p * 0.08 | floor), 7] | min, 0] | max]
        | if $p > 70 then "\u001b[38;5;141m\(.)\u001b[0m" end;
    def show($label): "\($label) \(bar) \(floor)%";
    (.rate_limits.five_hour.used_percentage // empty | show("5h")),
    (.rate_limits.seven_day.used_percentage // empty | show("7d")),
    (.context_window.used_percentage // empty | show("ctx"))
')}")
# -r: raw (no escape sequences)
# -n: no new line
print -rn -- ${(j: · :)parts:#}
