module commander

pub fn (command Command) run() i8 {
    terminating_flag := command.get_first_terminating_flag() or { Flag{} }

    match terminating_flag {
        TerminatingFlag {
            return terminating_flag.execute(command)
        }
        else {}
    }

    return command.execute(command)
}
