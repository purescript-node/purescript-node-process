module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Foreign.Object as Object
import Node.Process as Process

main :: Effect Unit
main = do
  let key = "PURESCRIPT_NODE_PROCESS_TEST"
  original <- Process.lookupEnv key
  Process.setEnv key "first"
  snapshot <- Process.getEnv
  Process.setEnv key "second"
  current <- Process.lookupEnv key
  Process.unsetEnv key
  removed <- Process.lookupEnv key
  case original of
    Nothing -> Process.unsetEnv key
    Just value -> Process.setEnv key value
  if
    Object.lookup key snapshot == Just "first"
      && current == Just "second"
      && removed == Nothing then pure unit
  else throw "Environment lookup, snapshot, or removal failed"
