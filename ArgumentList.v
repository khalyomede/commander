module commander

pub struct ArgumentList {
    pub:
        name string
        description string
        validate fn (mut Command) ! = fn (mut command Command) ! {}

    mut:
        values []string
}
