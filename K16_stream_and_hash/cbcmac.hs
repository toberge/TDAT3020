import Text.Printf (printf)
import Data.Bits (xor)

cbcmac :: Int -> [Int] -> [Int]
cbcmac k = drop 1 . scanl cipher 0
  where cipher y x = ((x `xor` y) + k) `mod` 16

main = do
    mapM_ (putStrLn . printf "%04b") $ cbcmac 3 [13,15,10,1]
    putStrLn ""
    mapM_ (putStrLn . printf "%04b") $ cbcmac 3 [2,12,1,15]
