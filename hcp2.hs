module Main where

import System.Environment (getArgs)

main :: IO ()
main = 
    getArgs >>= \args ->
        case args of
            [source, target] -> 
                readFile source >>= \content ->
                writeFile target content
            _ -> putStrLn "Usage: hcp <source> <destination>"
