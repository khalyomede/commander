module commander

fn element_to_help(name string, short_name string, description string, default_value string, allowed_values []string) string {
    content := match [name.len > 0, short_name.len > 0] {
        [true, true] { "--${name}, -${short_name}" }
        [false, true] { "-${short_name}" }
        [true, false] { "--${name}" }
        else { "" }
    }

    mut additional_info := description

    if allowed_values.len > 0 {
        allowed_list := allowed_values.join(", ")
        additional_info += " (allowed: ${allowed_list})"
    } else if default_value.len > 0 {
        additional_info += " (default: ${default_value})"
    }

    return match [content.len > 0, additional_info.len > 0] {
        [true, true] { "  ${content}  ${additional_info}" }
        [true, false] { "  ${content}" }
        else { "" }
    }
}
