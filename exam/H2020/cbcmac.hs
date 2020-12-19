import Text.Printf (printf)
import Data.Bits (xor)

cbc_exam :: Int -> [Int] -> [Int]
cbc_exam k = drop 1 . scanl cipher 9
  where cipher y x = (11 * (x `xor` y) + k) `mod` 16

-- actually not correct!
cbc_rev :: Int -> [Int] -> [Int]
cbc_rev k = drop 1 . scanl cipher 9
  where cipher y x = (3*(x - k) `mod` 16) `xor` y

cbcmac_exam :: Int -> [Int] -> Int
cbcmac_exam k = last . drop 1 . scanl cipher 0
  where cipher y x = (11 * (x `xor` y) + k) `mod` 16
