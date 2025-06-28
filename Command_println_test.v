module test

import commander { Command }

fn test_it_saves_output() {
    message := "Hello world"

    mut command := Command{
        name: "test"
        execute: fn [message] (mut command Command) i8 {
            command.println(message)

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "${message}\n"
}
