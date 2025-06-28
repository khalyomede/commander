module commander

pub fn (mut command Command) arguments(name string) ?[]string {
    parts := command.parts()
    mut arguments := command.arguments.clone()

    for index := 0; index < parts.len; index += 1 {
        part := parts[index] or { continue }

        if command.has_command_flag(part) {
            continue
        }

        if command.has_parameter(part) {
            index += 1

            continue
        }

        for mut argument in arguments {
            if argument.is_filled() {
                continue
            }

            match argument {
                Argument {
                    if argument.name == name {
                        command.reset_argument_values()

                        return []
                    }

                    argument.values << part

                    break
                }
                ArgumentList {
                    argument.values << part

                    break
                }
                else {
                    break
                }
            }
        }
    }

    for argument in arguments {
        match argument {
            ArgumentList {
                if argument.name == name {
                    values := argument.values

                    command.reset_argument_values()

                    return values
                }
            }
            else {
                continue
            }
        }
    }

    command.reset_argument_values()

    return none
}
