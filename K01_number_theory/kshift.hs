import Stuff

e n k x = (x + k) `mod` n

d n k x = (x - k) `mod` n

decrypt xs n k = map (d n k) xs

main :: IO ()
main = do
    putStrLn "pls gib txt"
    cs <- getLine
    let xs = map translate cs
    putStrLn $ unwords $ map show xs
    mapM_ putStrLn $ map (map backlate) $ map (decrypt xs 29) [1..28]
