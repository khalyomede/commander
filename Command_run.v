module commander

import os { Result }

pub fn (mut command Command) run() Result {
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
