module test

import commander { Command, ArgumentList }

fn test_it_can_get_all_arguments_values() {
    mut command := Command{
        input: [@FILE, "Melissa", "Patrick", "Sandy"]
        name: "greet"
        arguments: [
            ArgumentList{
                name: "friends"
                description: "A list of friends to greet."
            }
        ]
        execute: fn (mut command Command) i8 {
            friends := command.arguments("friends") or { [] }

            command.println("Hello ${friends.join(", ")}!")

            return 0
        }
    }

    result := command.run()

    assert result.exit_code == 0
    assert result.output == "Hello Melissa, Patrick, Sandy!\n"
}
