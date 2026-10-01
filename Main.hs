module Main where

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Client
    ( httpLbs, newManager, parseRequest, Response(responseBody) )
import Network.HTTP.Client.TLS ( tlsManagerSettings )
import System.Environment ( getArgs )
import Control.Monad ( when )
import System.Exit ( exitSuccess )
import Data.Time.Clock (getCurrentTime)
import Data.Time (formatTime, defaultTimeLocale)

main :: IO ()
main = do
  arg <- firstArg
  when (arg == "--help") $ do
    printHelp
    exitSuccess
  weather <- fetchWeather arg
  L8.putStrLn weather
  writeToFile weather arg

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

fetchWeather :: String -> IO L8.ByteString
fetchWeather city = do
    manager <- newManager tlsManagerSettings
    let url = "https://wttr.in/~" ++ city ++ "?format=3"
    request <- parseRequest url
    response <- httpLbs request manager
    pure (responseBody response)

writeToFile :: L8.ByteString -> String -> IO ()
writeToFile content city = do
  currentTime <- getCurrentTime
  let timestamp = formatTime defaultTimeLocale "%Y-%m-%d_%H:%M:%S" currentTime
  let fileName = city ++ "_" ++ timestamp ++ ".txt"
  L8.writeFile fileName content