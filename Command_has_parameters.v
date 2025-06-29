module commander

fn (command Command) has_parameters() bool {
    return command.parameters.len > 0
}
