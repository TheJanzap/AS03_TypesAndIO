module Main where

import System.Environment (getArgs)

main :: IO ()
main = 
    getArgs >>= \args ->
        let inp  = args !! 0
            outp = args !! 1
        in readFile inp >>= \content ->
            writeFile outp content