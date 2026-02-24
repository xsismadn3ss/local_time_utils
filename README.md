# local_time_utils

[![Package Version](https://img.shields.io/hexpm/v/local_time_utils)](https://hex.pm/packages/local_time_utils)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/local_time_utils/)

Small utilities for working with “local” time in Gleam (current time with a UTC offset, plus simple formatting).

## Installation

```sh
gleam add local_time_utils@1
```

## Usage

This package exposes 2 *top-level* modules: `time` and `types`.

Since these are generic names, it’s a good idea to import them with aliases to avoid conflicts:

```gleam
import time as local_time
import types as local_types
```

### Get local time (milliseconds)

`utc_offset` is in hours (for example, `0` for UTC, `2` for UTC+2).

```gleam
import gleam/io
import time as local_time

pub fn main() {
  let t = local_time.now(utc_offset: 0)
  io.println(local_time.describe_time(t))
}
```

### Higher precision time (micro/nanoseconds)

```gleam
import gleam/io
import time as local_time

pub fn main() {
  let t = local_time.precise_now(utc_offset: 2)
  io.println(local_time.describe_time(t))
}
```

### Working with the `Time` type

You can pattern-match to access its fields:

```gleam
import gleam/io
import gleam/int
import time as local_time

pub fn main() {
  case local_time.now(utc_offset: 0) {
    local_time.LocalTime(hour, minute, second, millisecond) ->
      io.println("Local: " <> int.to_string(hour) <> ":" <> int.to_string(minute))

    local_time.PreciseTime(hour, minute, second, millisecond, _, _) ->
      io.println("Precise: " <> int.to_string(hour) <> ":" <> int.to_string(minute))
  }
}
```

For the full API (including types), see https://hexdocs.pm/local_time_utils/.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
