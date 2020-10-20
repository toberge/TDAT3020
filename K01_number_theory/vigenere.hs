import Stuff

-- usage: 
-- putStrLn $ map backlate $ d (map translate "DNVGNXEGCKHEYWVZ") (map translate "TORSK")

encryptNums :: (Integral a) => a -> [a] -> [a] -> [a]
encryptNums n s k = map (flip mod n) $ zipWith (+) s (cycle k)

encrypt s k = bl $ encryptNums 29 (tl s) (tl k)

decryptNums :: (Integral a) => a -> [a] -> [a] -> [a]
decryptNums n s k = map (flip mod n) $ zipWith (-) s (cycle k)

decrypt s k = bl $ decryptNums 29 (tl s) (tl k)

-- main = do
--     putStrLn "Type your key, encrypted text, and decrypted text"    
