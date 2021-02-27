import LeanNixStatic1.Inline
import LeanNixStatic1.Extern

#reduce ifNative1Else0 0 == 0

def main(argv: List String): IO UInt32 := do
 IO.println s!"{ifNative1Else0 0} should be 1"
 IO.println s!"{addMagicConstant 0} should be 12345"
 return 0
 