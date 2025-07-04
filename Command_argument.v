module commander

pub fn (mut command Command) argument(name string) ?string {
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

                        return part
                    }

                    argument.values << part

                    break
                }
                ArgumentList {
                    if argument.name == name {
                        command.reset_argument_values()

                        return none
                    }

                    argument.values << part

                    break
                }
                else {
                    break
                }
            }
        }
    }

    command.reset_argument_values()

    return none
}
