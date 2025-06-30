module commander

pub fn (command Command) has_flag(name string) bool {
    parts := command.parts()

    for part in parts {
        if command.has_command_flag(part) {
            return true
        }
    }

    return false
}
