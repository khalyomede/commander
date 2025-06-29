module commander

pub struct Command {
    parent_name string

    pub:
        input []string
        name string @[required]
        description string
        flags []CommandFlag
        parameters []Parameter
        arguments []CommandArgument
        examples map[string]string
        execute fn (mut Command) i8 @[required]
        commands []Command

    mut:
        output string
}
