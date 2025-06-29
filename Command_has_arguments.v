module commander

fn (command Command) has_arguments() bool {
    return command.arguments.len > 0
}
