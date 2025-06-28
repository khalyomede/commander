module test

import commander { Command, TerminatingFlag }

fn test_it_returns_command_execution_return_code_when_nothing_passed() {
    return_code := i8(42)

    command := Command{
        input: [@FILE]
        name: "test"
        execute: fn [return_code] (command Command) i8 {
            return return_code
        }
    }

    assert command.run() == return_code
}

fn test_it_returns_code_zero_if_no_input_provided() {
    return_code := i8(42)

    command := Command{
        name: "test"
        execute: fn [return_code] (command Command) i8 {
            return return_code
        }
    }

    assert command.run() == return_code
}

fn test_it_returns_terminating_flag_execution_return_code_when_passed() {
    flag_return_code := i8(-2)
    return_code := i8(42)

    command := Command{
        input: [@FILE, "--version"]
        name: "test"
        flags: [
            TerminatingFlag{
                name: "version"
                short_name: "v"
                description: "Display the version of the command."
                execute: fn [flag_return_code] (command Command) i8 {
                    return flag_return_code
                }
            }
        ]
        execute: fn [return_code] (command Command) i8 {
            return return_code
        }
    }

    assert command.run() == flag_return_code
}
