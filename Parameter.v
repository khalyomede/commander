module commander

pub struct Parameter {
    pub:
        name string
        short_name string
        description string
        default string = ""
        validate fn (mut Command) ! = fn (mut command Command) ! {}
}
