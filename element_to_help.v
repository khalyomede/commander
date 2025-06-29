module commander

fn element_to_help(name string, short_name string, description string) string {
    content := match [name.len > 0, short_name.len > 0] {
        [true, true] { "--${name}, -${short_name}" }
        [false, true] { "-${short_name}" }
        [true, false] { "--${name}" }
        else { "" }
    }

    return match [content.len > 0, description.len > 0] {
        [true, true] { "  ${content}  ${description}" }
        [true, false] { "  ${content}  ${description}" }
        else { "" }
    }
}
