import gleam/float
import gleam/time/timestamp
import types.{describe_number}

/// Type representing a time, either with or without a date.
pub type Time {
  /// Time without a date, such as 12:30:45.123
  LocalTime(hour: Int, minute: Int, second: Int, millisecond: Int)
  /// Time with a date, such as 2024-06-01T12:30:45.123Z
  PreciseTime(
    hour: Int,
    minute: Int,
    second: Int,
    millisecond: Int,
    microsecond: Int,
    nanosecond: Int,
  )
}

/// Function to get the current time without a date, with precision up to milliseconds.
pub fn now(utc_offset utc_offset: Int) {
  let timestamp = timestamp.system_time()
  let unix_seconds = timestamp.to_unix_seconds(timestamp)

  LocalTime(
    hour: types.Float(unix_seconds)
      |> unix_seconds_to_hours
      |> fn(hour) { hour + utc_offset }
      |> adjust_hour_offset,
    minute: types.Float(unix_seconds) |> unix_seconds_to_minutes,
    second: types.Float(unix_seconds) |> unix_seconds_to_seconds,
    millisecond: types.Float(unix_seconds)
      |> unix_seconds_to_milliseconds,
  )
}

/// Function to get the current time with high precision, including microseconds and nanoseconds.
pub fn precise_now(utc_offset utc_offset: Int) {
  let timestamp = timestamp.system_time()
  let result = timestamp.to_unix_seconds_and_nanoseconds(timestamp)
  let unix_seconds = result.0
  let nanoseconds = result.1

  PreciseTime(
    hour: types.Int(unix_seconds)
      |> unix_seconds_to_hours
      |> fn(hour) { hour + utc_offset }
      |> adjust_hour_offset,
    minute: types.Int(unix_seconds) |> unix_seconds_to_minutes,
    second: types.Int(unix_seconds) |> unix_seconds_to_seconds,
    millisecond: types.Int(unix_seconds)
      |> unix_seconds_to_milliseconds,
    microsecond: nanoseconds
      |> unix_nanoseconds_to_microseconds,
    nanosecond: nanoseconds
      |> unix_nanoseconds_to_nanoseconds,
  )
}

/// Function to describe a time as a string.
pub fn describe_time(time: Time) {
  let value =
    time.hour |> types.Int |> describe_number
    <> ":"
    <> time.minute |> types.Int |> describe_number
    <> ":"
    <> time.second |> types.Int |> describe_number
    <> "."
    <> time.millisecond |> types.Int |> describe_number
    <> "."
  case time {
    LocalTime(_, _, _, _) -> value
    PreciseTime(_, _, _, _, microsecond, nanosecond) ->
      value
      <> microsecond |> types.Int |> describe_number
      <> "."
      <> nanosecond |> types.Int |> describe_number
  }
}

// Helper functions to convert unix time to various components.

fn unix_nanoseconds_to_nanoseconds(unix_nanoseconds: Int) -> Int {
  unix_nanoseconds / 1_000_000_000
}

fn unix_nanoseconds_to_microseconds(unix_nanoseconds: Int) -> Int {
  unix_nanoseconds % 1000
}

/// Converts unix seconds to milliseconds
fn unix_seconds_to_milliseconds(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(_) -> 0
    types.Float(f) -> {
      let whole = float.floor(f)
      let frac = f -. whole
      float.round(frac *. 1000.0)
    }
  }
}

/// Converts unix seconds to seconds
fn unix_seconds_to_seconds(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> i % 60
    types.Float(f) -> float.round(f) % 60
  }
}

/// Converts unix seconds to minutes
fn unix_seconds_to_minutes(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> { i / 60 } % 60
    types.Float(f) -> { float.round(f) / 60 } % 60
  }
}

/// Converts unix seconds to hours
fn unix_seconds_to_hours(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> { i / 3600 } % 24
    types.Float(f) -> { float.round(f) / 3600 } % 24
  }
}

/// Adjusts the hour offset to ensure it stays within the 0-23 range.
fn adjust_hour_offset(hours: Int) -> Int {
  case hours {
    hours if hours > 23 -> {
      hours - 24
    }
    _ -> hours
  }
}
