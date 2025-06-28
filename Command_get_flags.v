module commander

import os

fn (command Command) get_flags() []CommandFlag {
    mut flags := []CommandFlag{}

    if command.input.len < 1 {
        return flags
    }

    parts := command.input[1..]

    for part in parts {
        flag_name := part.trim_left('-')

        if part.starts_with("-") {
            for flag in command.flags {
                if part[0..2] == "--" && flag.name == flag_name {
                    flags << flag

                    continue
                }

                if part.starts_with("-") && flag.short_name == flag_name {
                    flags << flag

                    continue
                }
            }
        }
    }

    return flags
}
