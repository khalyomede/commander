module commander

pub struct TerminatingFlag {
    pub:
        name string
        short_name string
        description string
        execute fn (mut Command) i8 @[required]
}
