module commander

pub fn (command Command) parameter(name string) ?string {
    parts := command.parts()

    for index := 0; index < parts.len; index += 1 {
        part := parts[index] or {
            continue
        }

        if command.has_command_flag(part) {
            continue
        }

        if command.has_parameter(part) {
            if command.parameter_uses_equal_sign_as_separator(part) {
                parameter_parts := part.split("=")

                if parameter_parts.len < 2 {
                    return none
                }

                return parameter_parts[1]
            } else {
                return parts[index + 1] or {
                    return none
                }
            }
        }
    }

    return none
}
