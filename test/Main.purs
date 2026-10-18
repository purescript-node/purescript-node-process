module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (catchException, throw)
import Foreign.Object as Object
import Node.Process as Process

main :: Effect Unit
main = do
  testEnvMutation
  testLoadEnvFile

testEnvMutation :: Effect Unit
testEnvMutation = do
  let key = "PURESCRIPT_NODE_PROCESS_TEST"
  original <- Process.lookupEnv key
  Process.setEnv key "first"
  snapshot <- Process.getEnv
  Process.setEnv key "second"
  current <- Process.lookupEnv key
  Process.unsetEnv key
  removed <- Process.lookupEnv key
  restoreEnv key original
  if
    Object.lookup key snapshot == Just "first"
      && current == Just "second"
      && removed == Nothing then pure unit
  else throw "Environment lookup, snapshot, or removal failed"

testLoadEnvFile :: Effect Unit
testLoadEnvFile = do
  let loadedKey = "PURESCRIPT_NODE_PROCESS_ENV_FILE_LOADED"
  let existingKey = "PURESCRIPT_NODE_PROCESS_ENV_FILE_EXISTING"
  originalLoaded <- Process.lookupEnv loadedKey
  originalExisting <- Process.lookupEnv existingKey
  originalCwd <- Process.cwd

  -- Explicit path: loads new variables, keeps existing ones.
  Process.unsetEnv loadedKey
  Process.setEnv existingKey "already-set"
  Process.loadEnvFile' "test/fixtures/.env"
  loadedByPath <- Process.lookupEnv loadedKey
  kept <- Process.lookupEnv existingKey

  -- Default path: resolves `.env` against the current working directory.
  Process.unsetEnv loadedKey
  Process.chdir "test/fixtures"
  Process.loadEnvFile
  Process.chdir originalCwd
  loadedByDefault <- Process.lookupEnv loadedKey

  -- Missing file throws.
  missingThrew <- Process.loadEnvFile' "test/fixtures/missing.env" $> false # catchException \_ -> pure true

  restoreEnv loadedKey originalLoaded
  restoreEnv existingKey originalExisting
  if
    loadedByPath == Just "from-file"
      && kept == Just "already-set"
      && loadedByDefault == Just "from-file"
      && missingThrew then pure unit
  else throw "loadEnvFile did not load the file, overwrote an existing variable, or did not throw for a missing file"

restoreEnv :: String -> Maybe String -> Effect Unit
restoreEnv key = case _ of
  Nothing -> Process.unsetEnv key
  Just value -> Process.setEnv key value
