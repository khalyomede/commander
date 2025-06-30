module commander

fn (command Command) parameter_uses_equal_sign_as_separator(part string) bool {
    parameter_parts := part.split("=")

    if parameter_parts.len < 2 {
        return false
    }

    parameter_name := parameter_parts[0]

    return command.has_parameter(parameter_name)
}
