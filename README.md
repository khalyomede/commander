# Commander

Create command line applications.

```v
module main

import khalyomede.commander { Command, TerminatingFlag, Argument }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    flags: [
      TerminatingFlag{
        name: "version"
        short_name: "v"
        execute: fn (mut command Command) i8 {
          println("Greet v0.1.0")

          return 0
        }
      }
    ],
    arguments: [
      Argument{
        name: "name"
        description: "Your first name."
        validate: fn (mut command Command) i8 {
          name := command.argument("name") or { "" }

          if name.trim().len == 0 {
            eprintln('Argument "name" is required.')

            return command.help()
          }
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      name := command.argument("name") or { "Stranger" }

      println("Hello ${name}!")

      return 0
    }
  }

  exit(command.run().exit_code)
}
```

```bash
> ./main John
Hello John!
```
