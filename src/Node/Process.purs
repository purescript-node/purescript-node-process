-- | Bindings to the global `process` object in Node.js. See also [the Node API documentation](https://nodejs.org/api/process.html)
module Node.Process
  ( PROCESS
  , onBeforeExit
  , onExit
  , onSignal
  , argv
  , execArgv
  , execPath
  , chdir
  , cwd
  , getEnv
  , lookupEnv
  , setEnv
  , pid
  , platform
  , exit
  , stdin
  , stdout
  , stderr
  , stdoutIsTTY
  , stderrIsTTY
  , version
  ) where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)

import Data.Maybe (Maybe, fromJust)
import Data.Posix (Pid)
import Data.Posix.Signal (Signal)
import Data.Posix.Signal as Signal
import Data.StrMap (StrMap)
import Data.StrMap as StrMap

import Node.Platform (Platform)
import Node.Platform as Platform
import Node.Stream (Readable, Writable)

import Partial.Unsafe (unsafePartial)

import Unsafe.Coerce (unsafeCoerce)

-- | An effect tracking interaction with the global `process` object.
foreign import data PROCESS :: !

-- YOLO
foreign import process :: forall props. { | props }

mkEff :: forall eff a. (Unit -> a) -> Eff eff a
mkEff = unsafeCoerce

-- | Register a callback to be performed when the event loop empties, and
-- | Node.js is about to exit. Asynchronous calls can be made in the callback,
-- | and if any are made, it will cause the process to continue a little longer.
foreign import onBeforeExit :: forall eff. Eff (process :: PROCESS | eff) Unit -> Eff (process :: PROCESS | eff) Unit

-- | Register a callback to be performed when the process is about to exit.
-- | Any work scheduled via asynchronous calls made here will not be performed
-- | in time.
-- |
-- | The argument to the callback is the exit code which the process is about
-- | to exit with.
foreign import onExit :: forall eff. (Int -> Eff (process :: PROCESS | eff) Unit) -> Eff (process :: PROCESS | eff) Unit

foreign import onSignalImpl :: forall eff. String -> Eff (process :: PROCESS | eff) Unit -> Eff (process :: PROCESS | eff) Unit

-- | Install a handler for a particular signal.
onSignal :: forall eff. Signal -> Eff (process :: PROCESS | eff) Unit -> Eff (process :: PROCESS | eff) Unit
onSignal sig = onSignalImpl (Signal.toString sig)

-- | Register a callback to run as soon as the current event loop runs to
-- | completion.
nextTick :: forall eff. Eff eff Unit -> Eff eff Unit
nextTick callback = mkEff \_ -> process.nextTick callback

-- | Get an array containing the command line arguments. Be aware
-- | that this can change over the course of the program.
argv :: forall eff. Eff (process :: PROCESS | eff) (Array String)
argv = mkEff \_ -> process.argv

-- | Node-specific options passed to the `node` executable. Be aware that
-- | this can change over the course of the program.
execArgv :: forall eff. Eff (process :: PROCESS | eff) (Array String)
execArgv = mkEff \_ -> process.execArgv

-- | The absolute pathname of the `node` executable that started the
-- | process.
execPath :: forall eff. Eff (process :: PROCESS | eff) String
execPath = mkEff \_ -> process.execPath

-- | Change the current working directory of the process. If the current
-- | directory could not be changed, an exception will be thrown.
foreign import chdir :: forall eff. String -> Eff (err :: EXCEPTION, process :: PROCESS | eff) Unit

-- | Get the current working directory of the process.
cwd :: forall eff. Eff (process :: PROCESS | eff) String
cwd = process.cwd

-- | Get a copy of the current environment.
getEnv :: forall eff. Eff (process :: PROCESS | eff) (StrMap String)
getEnv = mkEff \_ -> process.env

-- | Lookup a particular environment variable.
lookupEnv :: forall eff. String -> Eff (process :: PROCESS | eff) (Maybe String)
lookupEnv k = StrMap.lookup k <$> getEnv

-- | Set an environment variable.
foreign import setEnv :: forall eff. String -> String -> Eff (process :: PROCESS | eff) Unit

pid :: Pid
pid = process.pid

platform :: Platform
platform = unsafePartial $ fromJust $ Platform.fromString process.platform

-- | Cause the process to exit with the supplied integer code. An exit code
-- | of 0 is normally considered successful, and anything else is considered a
-- | failure.
foreign import exit :: forall eff a. Int -> Eff (process :: PROCESS | eff) a

-- | The standard input stream. Note that this stream will never emit an `end`
-- | event, so any handlers attached via `onEnd` will never be called.
stdin :: forall eff. Readable () (console :: CONSOLE | eff)
stdin = process.stdin

-- | The standard output stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
stdout :: forall eff. Writable () (console :: CONSOLE, err :: EXCEPTION | eff)
stdout = process.stdout

-- | The standard error stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
stderr :: forall eff. Writable () (console :: CONSOLE, err :: EXCEPTION | eff)
stderr = process.stderr

-- | Check whether the standard output stream appears to be attached to a TTY.
-- | It is a good idea to check this before printing ANSI codes to stdout
-- | (e.g. for coloured text in the terminal).
stdoutIsTTY :: Boolean
stdoutIsTTY = process.stdout.isTTY

-- | Check whether the standard error stream appears to be attached to a TTY.
-- | It is a good idea to check this before printing ANSI codes to stderr
-- | (e.g. for coloured text in the terminal).
stderrIsTTY :: Boolean
stderrIsTTY = process.stderr.isTTY

-- | Get the Node.js version.
version :: String
version = process.version
