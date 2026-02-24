//// This module defines a custom type `Number` that can represent 
//// either an integer or a float.

import gleam/float
import gleam/int

/// Type representing a number, which can be either an integer or a float.
pub type Number {
  Int(Int)
  Float(Float)
}

/// Function to describe a number as a string.
pub fn describe_number(number: Number) -> String {
  case number {
    Int(i) -> "Int: " <> int.to_string(i)
    Float(f) -> "Float: " <> float.to_string(f)
  }
}
