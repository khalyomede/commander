module commander

fn (command Command) has_parameter(name string) bool {
    command.get_parameter(name) or {
        return false
    }

    return true
}
