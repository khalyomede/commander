module commander

pub fn (command Command) argument(name string) ?string {
    parts := command.parts()

    for index := 0; index < parts.len; index += 1 {
        part := parts[index] or { continue }

        if command.has_command_flag(part) {
            continue
        }

        if command.has_parameter(part) {
            index += 1

            continue
        }

        return part
    }

    return none
}
