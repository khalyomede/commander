module test

import commander { Command, Flag, Parameter, Argument }

fn test_it_gets_parameter_when_only_parameter_is_passed() {
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, "--region", region]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                description: "The region to greet on."
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello from ${region}!\n"
}

fn test_it_gets_parameter_when_parameter_is_passed_then_argument() {
    region := "Bahamas"
    name := "John"

    mut command := Command{
        input: [@FILE, "--region", region, name]
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

fn test_it_gets_parameter_when_argument_is_passed_then_parameter() {
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

fn test_it_gets_parameter_when_parameter_is_passed_then_flag() {
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, "--region", region, "--verbose"]
        name: "greet"
        parameters: [
            Parameter{
                name: "region"
                description: "The region to greet on."
            }
        ]
        flags: [
            Flag{
                name: "verbose"
                description: "Enable verbose output."
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello from ${region}!\n"
}

fn test_it_gets_parameters_when_flag_is_passed_then_parameter() {
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, "--verbose", "--region", region]
        name: "greet"
        flags: [
            Flag{
                name: "verbose"
                description: "Enable verbose output."
            }
        ]
        parameters: [
            Parameter{
                name: "region"
                description: "The region to greet on."
            }
        ]
        execute: fn (mut command Command) i8 {
            region := command.parameter("region") or { "the World" }

            command.println("Hello from ${region}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello from ${region}!\n"
}

fn test_it_gets_parameters_when_flag_is_passed_then_argument_then_parameter() {
    name := "John"
    region := "Bahamas"

    mut command := Command{
        input: [@FILE, "--verbose", name, "--region", region]
        name: "greet"
        flags: [
            Flag{
                name: "verbose"
                description: "Enable verbose output."
            }
        ]
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
