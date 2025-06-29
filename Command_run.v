module commander

import os { Result }

pub fn (mut command Command) run() Result {
    // Runs sub command if it matches the first argument
    mut sub_command := command.get_sub_command() or {
        Command{
            name: ""
            execute: fn (mut command Command) i8 {
                return 0
            }
        }
    }

    if sub_command.name.len > 0 {
        mut sub_command_found := false
        mut parts := []string{}

        for part in command.input {
            if part == sub_command.name && !sub_command_found {
                sub_command_found = true
            } else {
                parts << part
            }
        }

        mut command_to_run := Command{
            ...sub_command
            input: parts
            parent_name: match command.parent_name.len > 0 {
                true { "${command.parent_name} ${command.name}" }
                else { "${command.name}" }
            }
        }

        return command_to_run.run()
    }

    // Runs the first-level command
    command.validate() or {
        command.print_error(err.msg())

        return Result{
            exit_code: 1
            output: command.output
        }
    }

    terminating_flag := command.get_first_terminating_flag() or { Flag{} }

    match terminating_flag {
        TerminatingFlag {
            return Result{
                exit_code: terminating_flag.execute(mut command)
                output: command.output
            }
        }
        else {}
    }

    return Result{
        exit_code: command.execute(mut command)
        output: command.output
    }
}
