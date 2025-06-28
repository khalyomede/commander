module commander

fn (command Command) parts() []string {
    return match command.input.len {
        0 { []string{} }
        else { command.input[1..] }
    }
}
