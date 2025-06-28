module commander

pub struct Command {
    pub:
        input []string
        name string
        flags []CommandFlag
        examples map[string]string
        execute fn (Command) i8 @[required]
}
