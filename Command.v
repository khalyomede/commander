module commander

pub struct Command {
    pub:
        input []string
        name string
        flags []CommandFlag
        parameters []Parameter
        arguments []Argument
        examples map[string]string
        execute fn (mut Command) i8 @[required]

    mut:
        output string
}
