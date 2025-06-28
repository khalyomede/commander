module commander

pub fn (mut command Command) print_error(message string) Command {
    eprintln(message)

    command.output += "${message}\n"

    return command
}
