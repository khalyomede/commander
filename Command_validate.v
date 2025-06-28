module commander

fn (mut command Command) validate() ! {
    for argument in command.arguments {
        argument.validate(mut command)!
    }

    for parameter in command.parameters {
        parameter.validate(mut command)!
    }
}
