module commander

fn (parameter Parameter) validate_allowed(mut command Command) ! {
    if parameter.allowed.len == 0 {
        return // No allowed values specified, skip validation
    }

    value := command.parameter(parameter.name) or {
        return // Parameter not provided, skip validation
    }

    if !parameter.allowed.contains(value) {
        allowed_list := parameter.allowed.join(", ")
        return error("Parameter --${parameter.name} must be one of: ${allowed_list}")
    }
}
