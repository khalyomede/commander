module commander

fn (argument Argument) is_filled() bool {
    return argument.values.len > 0
}
