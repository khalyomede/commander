module commander

pub interface CommandArgument {
    name string
    description string
    validate fn (mut Command) !
    is_filled() bool

    mut:
        values []string
}
