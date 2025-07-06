module commander

pub fn (mut command Command) help() i8 {
    mut usage := "  " + match command.parent_name.len > 0 {
        true { "${command.parent_name} ${command.name}" }
        else { command.name }
    }

    for argument in command.arguments {
        usage += match argument {
            Argument {
                " <${argument.name}>"
            }
            ArgumentList {
                " <...${argument.name}>"
            }
            else {
                ""
            }
        }
    }

    for parameter in command.parameters {
        usage += " [--${parameter.name}=]"
    }

    for flag in command.flags {
        usage += " [--${flag.name}]"
    }

    mut lines := [
        "${command.name}"
        "${command.description}"
        ""
        "Usage"
        ""
        usage
    ]

    if command.has_arguments() {
        lines << ["", "Arguments", ""]

        for argument in command.arguments {
            lines << argument.to_help()
        }
    }

    if command.has_parameters() {
        lines << ["", "Parameters", ""]

        for parameter in command.parameters {
            lines << element_to_help(parameter.name, parameter.short_name, parameter.description, parameter.default, parameter.allowed)
        }
    }

    if command.has_command_flags() {
        lines << ["", "Flags", ""]

        for flag in command.flags {
            lines << element_to_help(flag.name, flag.short_name, flag.description, "", [])
        }
    }

    for line in lines {
        command.println(line)
    }

    return 0
}
