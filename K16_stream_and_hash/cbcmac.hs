import Text.Printf (printf)
import Data.Bits (xor)

cbcmac :: Int -> [Int] -> [Int]
cbcmac k = drop 1 . reverse . foldl (\ys x -> ((x `xor` head ys) + k) `mod` 16 : ys) [0]

main = do
    mapM_ (putStrLn . printf "%04b") $ cbcmac 3 [13,15,10,1]
    putStrLn ""
    mapM_ (putStrLn . printf "%04b") $ cbcmac 3 [2,12,1,15]

-- no. 1: [13,15,10,1]
-- no. 2: [2,12,1,15]
