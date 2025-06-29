module commander

pub interface CommandArgument {
    name string
    description string
    validate fn (mut Command) !
    is_filled() bool

    mut:
        values []string
}

fn (command_argument CommandArgument) to_help() string {
    return match [command_argument.name.len > 0, command_argument.description.len > 0] {
        [true, true] { "  ${command_argument.name}  ${command_argument.description}" }
        [true, false] { "  ${command_argument.name}" }
        else { "" }
    }
}
