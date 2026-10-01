module Main where

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Client
    ( httpLbs, newManager, parseRequest, Response(responseBody) )
import Network.HTTP.Client.TLS ( tlsManagerSettings )
import System.Environment ( getArgs )
import System.Exit ( exitSuccess )
import Data.Time.Clock (getCurrentTime)
import Data.Time (formatTime, defaultTimeLocale)

main :: IO ()
main = do
  action <- parseArgs
  case action of
    Help -> printHelp
    LoadWeather city -> getWeather city

data Action =
    Help
  | LoadWeather String

newtype URL = URL String

parseArgs :: IO Action
parseArgs = do
  args <- getArgs
  let action =
        case args of
          -- Why doesn't Haskell have multiple cases per match arm?
          []          -> Help
          ["-h"]      -> Help
          ["--help"]  -> Help
          [city]      -> LoadWeather city
          _           -> Help
  -- What it feels like to write Haskell:
  pure action

printHelp :: IO ()
printHelp = do
  putStrLn "wttr - Get the current weather for a city"
  putStrLn "usage: wttr <CITY>"
  putStrLn "--help    Prints this help message"
  exitSuccess

getWeather :: String -> IO ()
getWeather city = do
  weather <- fetchWeather city
  L8.putStrLn weather
  writeToFile weather city

buildURL :: String -> URL
buildURL city = URL $ "https://wttr.in/~" ++ city ++ "?format=3"

fetchWeather :: String -> IO L8.ByteString
fetchWeather city = do
    manager <- newManager tlsManagerSettings
    let (URL url) = buildURL city
    request <- parseRequest url
    response <- httpLbs request manager
    pure (responseBody response)

writeToFile :: L8.ByteString -> String -> IO ()
writeToFile content city = do
  currentTime <- getCurrentTime
  let timestamp = formatTime defaultTimeLocale "%Y-%m-%d_%H:%M:%S" currentTime
  let fileName = city ++ "_" ++ timestamp ++ ".txt"
  L8.writeFile fileName content