module Stuff where
import Data.Char

translate :: Char -> Int
translate c
  | '@' < c && c < 'a'      = ord c - 65
  | c == 'Æ'                = 26
  | c == 'Ø'                = 27
  | c == 'Å'                = 28
  | otherwise               = 26

tl = map translate

backlate :: Int -> Char
backlate x
  | 0 <= x && x < 26 = chr (65+x)
  | x == 26         = 'Æ'
  | x == 27         = 'Ø'
  | x == 28         = 'Å'
  | otherwise       = 'Æ'

bl = map backlate
