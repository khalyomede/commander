module commander

pub struct Argument implements CommandArgument {
    pub:
        name string
        description string
        validate fn (mut Command) ! = fn (mut command Command) ! {}

    mut:
        values []string
}
