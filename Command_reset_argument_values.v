module commander

fn (mut command Command) reset_argument_values() {
    for mut argument in command.arguments {
        argument.values = []
    }
}
