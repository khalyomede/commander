module commander

pub fn (command Command) get_first_terminating_flag() ?CommandFlag {
    terminating_flag := command.get_flags()
        .filter(it is TerminatingFlag)[0] or {
            return none
        }

    return terminating_flag
}
