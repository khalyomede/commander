module commander

fn (command Command) validate() ! {
    for argument in command.arguments {
        argument.validate(command)!
    }

    for parameter in command.parameters {
        parameter.validate(command)!
    }
}
