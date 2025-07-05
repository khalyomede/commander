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
        name: "help"
        execute: fn (mut command Command) i8 {
          return command.help()
        }
      }
    ],
    arguments: [
      Argument{
        name: "name"
        description: "Your first name."
      }
    ]
    execute: fn (mut command Command) i8 {
      name := command.argument("name") or { "Stranger" }

      println("Hello ${name}!")

      return 0
    }
  }

  command.serve()
}
```

```bash
> ./main John
Hello John!
```

## Summary

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)

## About

I create this library to help me create command line applications and tools. I needed a way to focus on my business logic, with a tool that help me parse and get parameters, flags and arguments.

## Features

- Supports Flags, to customize your command behavior (like `--quiet` or `-q`)
- Supports Terminating Flags, which are flags that will interrupt the normal execution of your command (like `--help` or `-h`)
- Supports Parameters, which are flags that take values (like ̀`--region=euw` or `-r=euw`)
- Supports both equal separated and space separated parameters (`--mode=parallel` or `--mode parallel` works interchangeably)
- For Flags and Parameters, supports long form (two dashes `--help`) and short form (single dash `-h`)
- Supports single and list of arguments
- Supports auto generated help documentation
- Supports subcommands (like `greet John` would be the main command and `greet install --quiet` would be the subcommand with the same features as mentioned above)
- Supports validating Arguments, Parameters and Flags on a separated step within the definition
- Supports returning both positive and negative return codes (from -255 to 255)
- Returns a [Result](https://modules.vlang.io/os.html#Result) so you can control the exit step and easily unit test your commands
- Easy output unit testing thanks to customized [println](https://modules.vlang.io/builtin.html#println) and [eprintln](https://modules.vlang.io/builtin.html#eprintln)

## Installation

- [Using V installer](#using-v-installer)
- [Manual download](#manual-download)

### Using V installer

Run this command in your project root folder terminal:

```bash
v install khalyomede.commander
```

### Manual download

1. Select the branch/tag of your choice
2. Download the zip of the repository (green button, then below "Download ZIP")
3. Locate your V modules path (usually this will be the folder at "~/.vmodules")
4. Inside this V modules folder, create a folder called "khalyomede"
5. Inside this "khalyomede" folder, create another folder called "commander"
4. Unzip the content of the folder inside the "~/.vmodules/khalyomede/commander" folder

You should end up with a folder tree like this:

```
~/.vmodules
└── khalyomede
  └── commander
    ├── Argument_is_filled.v
    ├── Argument.v
    ├── ...
    └── v.mod
```

## Examples

- [Hello world](#hello-world)
- [Display help documentation](#display-help-documentation)
- Arguments
  - [Simple argument](#simple-argument)
  - [Argument list](#argument-list)
  - [Getting an argument value](#getting-an-argument-value)
  - [Validate an argument](#validate-an-argument)
- Flags
  - [Add a flag](#add-a-flag)
  - [Add a terminating flag](#add-a-terminating-flag)
  - [Check if a flag is present](#check-if-a-flag-is-present)
- Parameter
  - [Add a parameter](#add-a-parameter)
  - [Get the value of a parameter](#get-the-value-of-a-parameter)
  - [Validate a parameter](#validate-a-parameter)
- Testing
  - [Testing the output](#testing-the-output)
  - [Testing the exit code](#testing-the-exit-code)
- [Create sub commands](#create-sub-commands)

### Hello world

```v
module main

import khalyomede.commander { Command }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    execute: fn (mut command Command) i8 {
      println("Hello world!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Display help documentation

Use `command.help()` anywhere in your code. For example you can combine it with a TerminatingFlag to show the help documentation whenever the user use the `--help` or `-h` flag.

```v
module main

import khalyomede.commander { Command, TerminatingFlag }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    flags: [
      TerminatingFlag{
        name: "help"
        short_name: "h"
        description: "Show the documentation."
        execute: fn (mut command Command) i8 {
          return command.help()
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      println("Hello world!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Simple argument

Argument are the basic information passed after the command name.

```v
module main

import khalyomede.commander { Command, Argument }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    arguments: [
      Argument{
        name: "person"
        description: "The name of the person to greet"
      }
    ]
    execute: fn (mut command Command) i8 {
      person := command.argument("person") or { "World" }

      println("Hello ${person}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Argument list

You can catch all argument in the form of a list using an ArgumentList.

```v
module main

import khalyomede.commander { Command, ArgumentList }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    arguments: [
      ArgumentList{
        name: "friends"
        description: "The name of the friends to greet."
      }
    ]
    execute: fn (mut command Command) i8 {
      friends := command.arguments("friends") or { ["World"] }
      message := friends.join(", ")

      println("Hello ${friends}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Getting an argument value

For simple Argument, use `command.argument()`, for ArgumentList use `command.arguments()`.

```v
module main

import khalyomede.commander { Command, Argument, ArgumentList }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    arguments: [
      Argument{
        name: "person"
        description: "The name of the person to greet."
      }
      ArgumentList{
        name: "friends"
        description: "The name of the friends to greet."
      }
    ]
    execute: fn (mut command Command) i8 {
      person := command.argument("person") or { "Stranger" }
      friends := command.arguments("friends") or { ["nobody else"] }

      println("Hello ${person} and ${friends}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Validate an argument

Note that when the command validation fails, it automatically returns an exit code 1.

```v
module main

import khalyomede.commander { Command, Argument }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    arguments: [
      Argument{
        name: "person"
        description: "The name of the person to greet."
        validate: fn (mut command Command) ! {
          person := command.argument("person") or { "" }

          if person.len == 0 {
            return error("The person argument is required.")
          }
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      person := command.argument("person") or { "Stranger" }

      println("Hello ${person}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Add a flag

A flag is a simple trigger that helps you customize the behavior of your command according to the presence of absence of this flag.

```v
module main

import khalyomede.commander { Command, Flag }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    flags: [
      Flag{
        name: "quiet"
        short_name: "quiet"
        description: "Display less debug information."
      }
    ]
    execute: fn (mut command Command) i8 {
      if !command.has_flag("quiet") {
        println("Starting...")
      }

      println("Hello world!")

      if !command.has_flag("quiet") {
        println("Command finished.")
      }

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Add a terminating flag

Terminating flag interrupt the program when present, by specifying a custom termination code.

```v
module main

import khalyomede.commander { Command, TerminatingFlag }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    flags: [
      TerminatingFlag{
        name: "version"
        short_name: "v"
        description: "Display the current version."
        execute: fn (mut command Command) i8 {
          println("v0.1.0")

          return 0
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      println("Hello world!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Check if a flag is present

Use `command.has_flag("name")` to check for a flag presence.

```v
module main

import khalyomede.commander { Command, Flag }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    flags: [
      Flag{
        name: "quiet"
        short_name: "q"
        description: "Display less debug information."
      }
    ]
    execute: fn (mut command Command) i8 {
      if !command.has_flag("quiet") {
        println("Starting...")
      }

      println("Hello world!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Add a parameter

```v
module main

import khalyomede.commander { Command, Parameter }
import os

fn main() {
  mut command := {
    input: os.args
    name: "greet"
    description: "Greet the user."
    parameters: [
      Parameter{
        name: "region"
        short_name: "r"
        description: "Greet on the given region."
      }
    ]
    execute: fn (mut command Command) i8 {
      println("Hello world")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Get the value of a parameter

```v
module main

import khalyomede.commander { Command, Parameter }
import os

fn main() {
  mut command := {
    input: os.args
    name: "greet"
    description: "Greet the user."
    parameters: [
      Parameter{
        name: "region"
        short_name: "r"
        description: "Greet on the given region."
      }
    ]
    execute: fn (mut command Command) i8 {
      region := command.parameter("region") or { "World" }

      println("Hello {$region$}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Validate a parameter

Note that when the command validation fails, it automatically returns an exit code 1.

```v
module main

import khalyomede.commander { Command, Parameter }
import os

fn main() {
  mut command := {
    input: os.args
    name: "greet"
    description: "Greet the user."
    parameters: [
      Parameter{
        name: "region"
        short_name: "r"
        description: "Greet on the given region."
        validate: fn (mut command Command) ! {
          region := command.parameter("region") or {
            return error("Missing parameter --region.")
          }

          if !["World", "Paris"].contains(region) {
            return error("Parameter --region must be either World or Paris.")
          }
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      region := command.parameter("region") or { "World" }

      println("Hello {$region$}!")

      return 0
    }
  }

  command.serve()
}
```

[back to examples](#examples)

### Testing the output

You can use `command.println()` and `command.print_error()` to ease the testing. They still behave like the built-in `println()` and `eprintln()`.

```v
module test

import khalyomede.commander { Command, Argument }

pub fn test_it_greet_user() {
  mut command := Command{
    input: [@FILE, "John"]
    name: "greet"
    description: "Greet the user."
    arguments: [
      Argument{
        name: "person"
        description: "The person to greet."
      }
    ]
    execute: fn (mut command Command) i8 {
      person := command.argument("person") or { "World" }

      command.println("Hello ${person}!")

      return 0
    }
  }

  result := command.run()

  assert result.output == "Hello John!\n"
}
```

[back to examples](#examples)

### Testing the exit code

```v
module test

import khalyomede.commander { Command, Argument }

pub fn test_it_returns_error_when_name_is_not_passed() {
  mut command := Command{
    input: [@FILE]
    name: "greet"
    description: "Greet the user."
    arguments: [
      Argument{
        name: "person"
        description: "The name of the person to greet."
        validate: fn (mut command Command) i8 {
          person := command.argument("person") or { "" }

          if person.len == 0 {
            return error("Argument person is required.")
          }
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      person := command.argument("person") or { "World" }

      command.println("Hello ${person}!")

      return 0
    }
  }

  result := command.run()

  assert result.exit_code == 1
}
```

[back to examples](#examples)

### Create sub commands

You can declare sub commands, that will have the same capabilities as mentioned above.

For example you can have a base command `greet John`, and you could have a sub command `greet install --quiet`.

```v
module main

import khalyomede.commander { Command }
import os

fn main() {
  mut command := Command{
    input: os.args
    name: "greet"
    description: "Greet the user."
    commands: [
      Command{
        name: "install"
        description: "Install the greet command."
        execute: fn (mut command Command) i8 {
          println("Installing...")

          return 0
        }
      }
    ]
    execute: fn (mut command Command) i8 {
      println("Hello world!")

      return 0
    }
  }
}
```

[back to examples](#examples)
