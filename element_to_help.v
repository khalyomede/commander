module commander

fn element_to_help(name string, short_name string, description string, default_value string) string {
    content := match [name.len > 0, short_name.len > 0] {
        [true, true] { "--${name}, -${short_name}" }
        [false, true] { "-${short_name}" }
        [true, false] { "--${name}" }
        else { "" }
    }

    additional_information := match default_value.len > 0 {
        true { "${description} (default: ${default_value})" }
        false { description }
    }

    return match [content.len > 0, additional_information.len > 0] {
        [true, true] { "  ${content}  ${additional_information}" }
        [true, false] { "  ${content}  ${additional_information}" }
        else { "" }
    }
}
