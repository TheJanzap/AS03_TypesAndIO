module Main where

import System.Environment (getArgs)

main :: IO ()
main = do
        args <- getArgs
        let inp = args !! 0
        let outp = args !! 1
        content <- readFile inp
        writeFile outp content