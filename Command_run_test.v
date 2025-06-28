module test

import commander { Command, Flag, TerminatingFlag, Parameter, Argument }

fn test_it_returns_command_execution_return_code_when_nothing_passed() {
    return_code := i8(42)

    mut command := Command{
        input: [@FILE]
        name: "test"
        execute: fn [return_code] (mut command Command) i8 {
            return return_code
        }
    }

    assert command.run().exit_code == return_code
}

fn test_it_returns_code_zero_if_no_input_provided() {
    return_code := i8(42)

    mut command := Command{
        name: "test"
        execute: fn [return_code] (mut command Command) i8 {
            return return_code
        }
    }

    assert command.run().exit_code == return_code
}

fn test_it_returns_terminating_flag_execution_return_code_when_passed() {
    flag_return_code := i8(-2)
    return_code := i8(42)

    mut command := Command{
        input: [@FILE, "--version"]
        name: "test"
        flags: [
            TerminatingFlag{
                name: "version"
                short_name: "v"
                description: "Display the version of the command."
                execute: fn [flag_return_code] (mut command Command) i8 {
                    command.println("Version 0.1.0")

                    return flag_return_code
                }
            }
        ]
        execute: fn [return_code] (mut command Command) i8 {
            return return_code
        }
    }

    result := command.run()

    assert result.exit_code == flag_return_code
    assert result.output == "Version 0.1.0\n"
}

fn test_it_can_use_argument_in_command_execution() {
    name := "John"

    mut command := Command{
        input: [@FILE, name]
        name: "test"
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "World" }

            command.println("Hello ${name}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello ${name}!\n"
}

fn test_it_can_use_option_first_and_argument_last_to_execute_command() {
    region := "Bahamas"
    name := "John"

    mut command := Command{
        input: [@FILE, "--region", region, name]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }
            name := command.argument("name") or { "Stranger" }

            command.println("Hello ${name} from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello ${name} from ${region}!\n"
}
