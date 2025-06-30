module commander

pub fn (mut command Command) serve() {
    exit(command.run().exit_code)
}
