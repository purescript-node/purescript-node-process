-- | Bindings to the global `process` object in Node.js. See also [the Node API documentation](https://nodejs.org/api/process.html)
module Node.Process
  ( onBeforeExit
  , onExit
  , onSignal
  , onUncaughtException
  , onUnhandledRejection
  , argv
  , argv'
  , execArgv
  , execArgv'
  , execPath
  , chdir
  , cwd
  , getEnv
  , env
  , lookupEnv
  , setEnv
  , unsetEnv
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

import Control.Monad.ST.Global (Global)
import Control.Monad.ST.Global as STGlobal
import Data.Array.ST (STArray)
import Data.Array.ST as STArray
import Data.Maybe (Maybe)
import Data.Posix (Pid)
import Data.Posix.Signal (Signal)
import Data.Posix.Signal as Signal
import Effect (Effect)
import Effect.Exception (Error)
import Foreign.Object as FO
import Foreign.Object.ST (STObject)
import Foreign.Object.ST as STObject
import Node.Platform (Platform)
import Node.Platform as Platform
import Node.Stream (Readable, Writable)
import Unsafe.Coerce (unsafeCoerce)

-- YOLO
foreign import process :: forall props. { | props }

mkEffect :: forall a. (Unit -> a) -> Effect a
mkEffect = unsafeCoerce

-- | Register a callback to be performed when the event loop empties, and
-- | Node.js is about to exit. Asynchronous calls can be made in the callback,
-- | and if any are made, it will cause the process to continue a little longer.
foreign import onBeforeExit :: Effect Unit -> Effect Unit

-- | Register a callback to be performed when the process is about to exit.
-- | Any work scheduled via asynchronous calls made here will not be performed
-- | in time.
-- |
-- | The argument to the callback is the exit code which the process is about
-- | to exit with.
foreign import onExit :: (Int -> Effect Unit) -> Effect Unit

-- | Install a handler for uncaught exceptions. The callback will be called
-- | when the process emits the `uncaughtException` event. The handler
-- | currently does not expose the second `origin` argument from the Node 12
-- | version of this event to maintain compatibility with older Node versions.
foreign import onUncaughtException :: (Error -> Effect Unit) -> Effect Unit

-- | Install a handler for unhandled promise rejections. The callback will be
-- | called when the process emits the `unhandledRejection` event.
-- |
-- | The first argument to the handler can be whatever type the unhandled
-- | Promise yielded on rejection (typically, but not necessarily, an `Error`).
-- |
-- | The handler currently does not expose the type of the second argument,
-- | which is a `Promise`, in order to allow users of this library to choose
-- | their own PureScript `Promise` bindings.
foreign import onUnhandledRejection :: forall a b. (a -> b -> Effect Unit) -> Effect Unit

foreign import onSignalImpl :: String -> Effect Unit -> Effect Unit

-- | Install a handler for a particular signal.
onSignal :: Signal -> Effect Unit -> Effect Unit
onSignal sig = onSignalImpl (Signal.toString sig)

-- | Register a callback to run as soon as the current event loop runs to
-- | completion.
nextTick :: Effect Unit -> Effect Unit
nextTick callback = mkEffect \_ -> process.nextTick callback

-- | Get an array containing the command line arguments.
argv :: Effect (Array String)
argv = STGlobal.toEffect (STArray.freeze argv')

-- | Get the mutable array containing the command line arguments.
argv' :: STArray Global String
argv' = process.argv

-- | Node-specific options passed to the `node` executable.
execArgv :: Effect (Array String)
execArgv = STGlobal.toEffect (STArray.freeze execArgv')

-- | Mutable array of node-specific options passed to the
-- | `node` executable.
execArgv' :: STArray Global String
execArgv' = process.execArgv

-- | The absolute pathname of the `node` executable that started the
-- | process.
execPath :: Effect String
execPath = mkEffect \_ -> process.execPath

-- | Change the current working directory of the process. If the current
-- | directory could not be changed, an exception will be thrown.
foreign import chdir :: String -> Effect Unit

-- | Get the current working directory of the process.
cwd :: Effect String
cwd = process.cwd

-- | Get a copy of the current environment.
getEnv :: Effect (FO.Object String)
getEnv = STGlobal.toEffect (FO.freezeST env)

-- | Mutable reference to the current environment.
env :: STObject Global String
env = process.env

-- | Lookup a particular environment variable.
lookupEnv :: String -> Effect (Maybe String)
lookupEnv k = STGlobal.toEffect (STObject.peek k env)

-- | Set an environment variable.
setEnv :: String -> String -> Effect Unit
setEnv k v = void $ STGlobal.toEffect (STObject.poke k v env)

-- | Delete an environment variable.
-- | Use case: to hide secret environment variable from child processes.
unsetEnv :: String -> Effect Unit
unsetEnv k = void $ STGlobal.toEffect (STObject.delete k env)

pid :: Pid
pid = process.pid

platform :: Maybe Platform
platform = Platform.fromString platformStr

platformStr :: String
platformStr = process.platform

-- | Cause the process to exit with the supplied integer code. An exit code
-- | of 0 is normally considered successful, and anything else is considered a
-- | failure.
foreign import exit :: forall a. Int -> Effect a

-- | The standard input stream. Note that this stream will never emit an `end`
-- | event, so any handlers attached via `onEnd` will never be called.
stdin :: Readable ()
stdin = process.stdin

-- | The standard output stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
stdout :: Writable ()
stdout = process.stdout

-- | The standard error stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
stderr :: Writable ()
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
