import Stuff

keystream :: (Integral a) => a -> [a] -> [a]
keystream k xs = k : init xs

encryptNums :: (Integral a) => a -> a -> [a] -> [a]
encryptNums n k xs = map (flip mod n) $ zipWith (+) xs zs
    where zs = keystream k xs

encrypt k s = bl $ encryptNums 29 k (tl s)

decryptNums :: (Integral a) => a -> a -> [a] -> [a]
decryptNums n k xs = aux k xs
    where 
      aux _ [] = []
      aux z (x:xs) = zNext : aux zNext xs
        where zNext = (x-z) `mod` n

decrypt k s = bl $ decryptNums 29 k (tl s)
