module commander

fn (command Command) get_parameter(name string) ?Parameter {
    if name.starts_with("-") {
        parameter_name := name.trim_left('-')

        for parameter in command.parameters {
            if name[0..2] == "--" && parameter.name == parameter_name {
                return parameter
            }

            if name.starts_with("-") && parameter.short_name == parameter_name {
                return parameter
            }
        }
    }

    return none
}
