module Main where

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import System.Environment
import Control.Monad
import System.Exit

main :: IO ()
main = do
  arg <- firstArg
  when (arg == "--help") $ do
    printHelp
    exitSuccess
  putStrLn "Test"

printHelp :: IO ()
printHelp = do
  putStrLn "wttr - Get the current weather for a city"
  putStrLn "usage: wttr <CITY>"
  putStrLn "--help    Prints this help message"

firstArg :: IO String
firstArg = do
  args <- getArgs
  let first = args !! 0
  pure first -- Place String in IO and return