-- A definition with both native and Lean implementations
@[extern c inline "lean_box(1)"]
def ifNative1Else0(dummy: Nat): Nat := 0

-- A constant with only a native implementation
@[extern c inline "#1 ^ #2"]
constant xor (a: @& UInt64) (b: @& UInt64) : UInt64