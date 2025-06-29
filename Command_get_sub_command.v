module commander

fn (command Command) get_sub_command() ?Command {
    if command.input.len < 2 {
        return none
    }

    potential_command_name := command.input[1]

    for sub_command in command.commands {
        if sub_command.name == potential_command_name {
            return sub_command
        }
    }

    return none
}
