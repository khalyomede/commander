module commander

pub struct Argument {
    pub:
        name string
        description string
        validate fn (Command) ! = fn (command Command) ! {}
}
