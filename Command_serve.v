module commander

pub fn (mut command Command) serve() {
    exit(command.run())
}
