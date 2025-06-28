module test

import commander { Command, Argument, Flag, Parameter }

fn test_it_gets_argument_value_when_only_argument_is_passed() {
    name := "John"

    mut command := Command{
        input: [@FILE, name]
        name: "greet"
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "Stranger" }

            command.println("Hello ${name}")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello ${name}\n"
}

fn test_it_gets_argument_value_when_argument_passed_then_flag() {
    name := "John"

    mut command := Command{
        input: [@FILE, name, "--verbose"]
        name: "greet"
        flags: [
            Flag{
                name: "verbose"
                short_name: "v"
                description: "Displays all algorithm steps."
            }
        ]
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "Stranger" }

            command.println("Hello ${name}")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello ${name}\n"
}

fn test_it_gets_argument_value_when_flag_passed_then_argument() {
    name := "John"

    mut command := Command{
        input: [@FILE, "--verbose", name]
        name: "greet"
        flags: [
            Flag{
                name: "verbose"
                short_name: "v"
                description: "Displays all algorithm steps."
            }
        ]
        arguments: [
            Argument{
                name: "name"
                description: "The name to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            name := command.argument("name") or { "Stranger" }

            command.println("Hello ${name}")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello ${name}\n"
}

fn test_it_gets_argument_value_when_argument_passed_then_parameter() {
    name := "John"
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, name, "--region", region]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
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

fn test_it_gets_argument_value_when_parameter_passed_then_argument() {
    name := "John"
    region := "Bahamas"

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

fn test_it_gets_argument_value_when_parameters_passed_then_flag_then_argument() {
    name := "John"
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, "--region", region, "--verbose", name]
        name: "greet"
        flags: [
            Flag{
                name: "verbose"
                short_name: "v"
                description: "Displays all algorithm steps."
            }
        ]
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
