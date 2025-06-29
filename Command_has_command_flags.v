module commander

fn (command Command) has_command_flags() bool {
    return command.flags.len > 0
}
