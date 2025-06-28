module commander

fn (command Command) get_command_flags() []CommandFlag {
    mut flags := []CommandFlag{}

    for part in command.parts() {
        flag := command.get_command_flag(part) or {
            continue
        }

        flags << flag
    }

    return flags
}
