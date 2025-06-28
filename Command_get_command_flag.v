module commander

fn (command Command) get_command_flag(name string) ?CommandFlag {
    flag_name := name.trim_left('-')

    if name.starts_with("-") {
        for flag in command.flags {
            if name[0..2] == "--" && flag.name == flag_name {
                return flag
            }

            if name.starts_with("-") && flag.short_name == flag_name {
                return flag
            }
        }
    }

    return none
}
