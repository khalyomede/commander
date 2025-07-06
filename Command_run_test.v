module test

import commander { Command, Flag, TerminatingFlag, Parameter, Argument, ArgumentList }

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
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
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

fn test_it_can_validate_argument() {
    mut command := Command{
        input: [@FILE, "Jo"]
        name: "greet"
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
                validate: fn (mut command Command) ! {
                    name := command.argument("name") or { return error("Name is required") }

                    if name.len < 3 {
                        return error("Name must be at least 3 characters long.")
                    }
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 1
    assert result.output == "Name must be at least 3 characters long.\n"
}

fn test_it_can_validate_parameter() {
    mut command := Command{
        input: [@FILE, "--region", "USA"]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                validate: fn (mut command Command) ! {
                    region := command.parameter("region") or { return error("Region is required.") }

                    if region.len != 2 {
                        return error("Region must be 2 characters long.")
                    }
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 1
    assert result.output == "Region must be 2 characters long.\n"
}

fn test_it_can_use_argument_then_argument_lists_when_executing_command() {
    mut command := Command{
        input: [@FILE, "John", "Melissa", "Patrick", "Sandy"]
        name: "greet"
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
            }
            ArgumentList{
                name: "friends"
                description: "The friends to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "Stranger" }
            friends := command.arguments("friends") or { [] }
            message := "Hello ${name}" + match friends.len {
                0 { "" }
                else { " and your friends ${friends.join(", ")}" }
            } + "!"

            command.println(message)

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello John and your friends Melissa, Patrick, Sandy!\n"
}

fn test_it_always_fill_argument_list_and_let_following_argument_empty_when_executing_command() {
    mut command := Command{
        input: [@FILE, "John", "Melissa", "Patrick", "Sandy"]
        name: "greet"
        arguments: [
            ArgumentList{
                name: "friends"
                description: "The friends to greet."
            }
            Argument{
                name: "name"
                description: "The name to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "Stranger" }
            friends := command.arguments("friends") or { [] }
            message := "Hello ${name}" + match friends.len {
                0 { "" }
                else { " and your friends ${friends.join(", ")}" }
            } + "!"

            command.println(message)

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello Stranger and your friends John, Melissa, Patrick, Sandy!\n"
}

fn test_it_returns_help() {
    mut command := Command{
        input: [@FILE, "--help"]
        name: "Greet"
        description: "Welcome the user."
        arguments: [
            Argument{
                name: "person"
                description: "The person to greet."
            }
            ArgumentList{
                name: "friends"
                description: "Additional persons to greet."
            }
        ]
        flags: [
            TerminatingFlag{
                name: "help"
                short_name: "h"
                description: "Display the manual."
                execute: fn (mut command Command) i8 {
                    return command.help()
                }
            }
        ]
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "Change the region to greet the user."
            }
        ]
        execute: fn (mut command Command) i8 {
            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == [
        "Greet",
        "Welcome the user."
        ""
        "Usage"
        ""
        "  Greet <person> <...friends> [--region=] [--help]"
        ""
        "Arguments"
        ""
        "  person  The person to greet."
        "  friends  Additional persons to greet."
        ""
        "Parameters"
        ""
        "  --region, -r  Change the region to greet the user."
        ""
        "Flags"
        ""
        "  --help, -h  Display the manual."
        ""
    ].join("\n")
}

fn test_it_runs_sub_command() {
    mut command := Command{
        input: [@FILE, "install"]
        name: "greet"
        commands: [
            Command{
                name: "install"
                execute: fn (mut command Command) i8 {
                    command.println("Installing...")

                    return 0
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            println("nothing")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Installing...\n"
}

fn test_it_can_react_to_terminating_flag_on_sub_command() {
    mut command := Command{
        input: [@FILE, "install", "--help"]
        name: "greet"
        flags: [
            TerminatingFlag{
                name: "help"
                short_name: "h"
                execute: fn (mut command Command) i8 {
                    return command.help()
                }
            }
        ]
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
            }
        ]
        commands: [
            Command{
                name: "install"
                description: "Install dependencies."
                flags: [
                    TerminatingFlag{
                        name: "help"
                        short_name: "h"
                        description: "Display the manual."
                        execute: fn (mut command Command) i8 {
                            return command.help()
                        }
                    }
                ]
                execute: fn (mut command Command) i8 {
                    command.println("Installing...")

                    return 0
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            command.println("Hello world!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == [
        "install"
        "Install dependencies."
        ""
        "Usage"
        ""
        "  greet install [--help]"
        ""
        "Flags"
        ""
        "  --help, -h  Display the manual."
        ""
    ].join("\n")
}

fn test_it_can_handle_equal_separated_parameters() {
    mut command := Command{
        input: [@FILE, "--region=Bahamas"]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "Everywhere" }

            command.println("Hello from ${region}")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello from Bahamas\n"
}

fn test_it_detects_when_flag_is_present() {
    mut command := Command{
        input: [@FILE, "--quiet"]
        name: "greet"
        flags: [
            Flag{
                name: "quiet"
                short_name: "q"
            }
        ]
        execute: fn (mut command Command) i8 {
            if !command.has_flag("quiet") {
                command.println("Command start...")
            }

            command.println("Hello world!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello world!\n"
}

fn test_it_is_able_to_not_detect_flag_when_it_is_not_present() {
    mut command := Command{
        input: [@FILE]
        name: "greet"
        flags: [
            Flag{
                name: "quiet"
                short_name: "q"
            }
        ]
        execute: fn (mut command Command) i8 {
            if !command.has_flag("quiet") {
                command.println("Starting...")
            }

            command.println("Hello world!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Starting...\nHello world!\n"
}

fn test_it_uses_default_value_when_parameter_is_not_passed() {
    mut command := Command{
        input: [@FILE]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                default: "euw-1"
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello world from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello world from euw-1!\n"
}

fn test_it_shows_default_value_in_help_documentation() {
    mut command := Command{
        input: [@FILE, "--help"]
        name: "greet"
        description: "Greet the user."
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                default: "euw-1"
            }
        ]
        flags: [
            TerminatingFlag{
                name: "help"
                short_name: "h"
                description: "Display the manual."
                execute: fn (mut command Command) i8 {
                    return command.help()
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output.contains("--region, -r  The region to greet on. (default: euw-1)")
}

fn test_it_returns_error_when_parameter_value_is_not_in_allowed_values() {
    mut command := Command{
        input: [@FILE, "--region", "usa"]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                allowed: ["euw-1", "euw-2", "euw-3"]
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello world from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 1
    assert result.output.contains("Parameter --region must be one of: euw-1, euw-2, euw-3")
}

fn test_it_accepts_parameter_value_when_it_is_in_allowed_values() {
    mut command := Command{
        input: [@FILE, "--region", "euw-2"]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                allowed: ["euw-1", "euw-2", "euw-3"]
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello world from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello world from euw-2!\n"
}

fn test_it_shows_allowed_values_in_help_documentation() {
    mut command := Command{
        input: [@FILE, "--help"]
        name: "greet"
        description: "Greet the user."
        parameters: [
            Parameter{
                name: "region"
                short_name: "r"
                description: "The region to greet on."
                allowed: ["euw-1", "euw-2", "euw-3"]
            }
        ]
        flags: [
            TerminatingFlag{
                name: "help"
                short_name: "h"
                description: "Display the manual."
                execute: fn (mut command Command) i8 {
                    return command.help()
                }
            }
        ]
        execute: fn (mut command Command) i8 {
            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output.contains("--region, -r  The region to greet on. (allowed: euw-1, euw-2, euw-3)")
}
