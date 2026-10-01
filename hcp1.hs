module Main where

import System.Environment (getArgs)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [source, target] -> do
            content <- readFile source
            writeFile target content
        _ -> putStrLn "Usage: hcp <source> <destination>"
