module commander

fn (command Command) get_parameter(name string) ?Parameter {
    if name.starts_with("-") {
        parameter_parts := name.trim_left('-').split('=')
        parameter_name := match parameter_parts.len {
            0 { "" }
            else { parameter_parts[0] }
        }

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
