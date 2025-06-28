module commander

pub fn (mut command Command) println(message string) Command {
    command.output += message + "\n"

    println(message)

    return command
}
