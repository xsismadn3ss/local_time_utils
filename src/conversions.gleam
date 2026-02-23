import gleam/float
import types

pub fn unix_nanoseconds_to_nanoseconds(unix_nanoseconds: Int) -> Int {
  unix_nanoseconds / 1_000_000_000
}

pub fn unix_nanoseconds_to_microseconds(unix_nanoseconds: Int) -> Int {
  unix_nanoseconds / 1000
}

/// Converts unix seconds to milliseconds
pub fn unix_seconds_to_milliseconds(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> { i / 1000 } % 1000
    types.Float(f) -> { float.round(f) / 1000 } % 1000
  }
}

/// Converts unix seconds to seconds
pub fn unix_seconds_to_seconds(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> i % 60
    types.Float(f) -> float.round(f) % 60
  }
}

/// Converts unix seconds to minutes
pub fn unix_seconds_to_minutes(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> { i / 60 } % 60
    types.Float(f) -> { float.round(f) / 60 } % 60
  }
}

/// Converts unix seconds to hours
pub fn unix_seconds_to_hours(unix_seconds: types.Number) -> Int {
  case unix_seconds {
    types.Int(i) -> { i / 3600 } % 24
    types.Float(f) -> { float.round(f) / 3600 } % 24
  }
}

/// Adjusts the hour offset to ensure it stays within the 0-23 range.
pub fn adjust_hour_offset(hours: Int) -> Int {
  case hours {
    hours if hours > 23 -> {
      hours - 24
    }
    _ -> hours
  }
}
