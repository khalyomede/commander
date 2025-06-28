module commander

fn (command Command) get_first_terminating_flag() ?CommandFlag {
    terminating_flag := command.get_command_flags()
        .filter(it is TerminatingFlag)[0] or {
            return none
        }

    return terminating_flag
}
