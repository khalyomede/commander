module commander

fn (command Command) has_command_flag(name string) bool {
    command.get_command_flag(name) or {
        return false
    }

    return true
}
