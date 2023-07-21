-- | Bindings to the global `process` object in Node.js. See also [the Node API documentation](https://nodejs.org/api/process.html)
module Node.Process
  ( onBeforeExit
  , onExit
  , onSignal
  , onUncaughtException
  , onUnhandledRejection
  , nextTick
  , argv
  , execArgv
  , execPath
  , chdir
  , cwd
  , getEnv
  , lookupEnv
  , setEnv
  , unsetEnv
  , pid
  , platform
  , exit
  , stdin
  , stdout
  , stderr
  , stdinIsTTY
  , stdoutIsTTY
  , stderrIsTTY
  , version
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Posix (Pid)
import Data.Posix.Signal (Signal)
import Data.Posix.Signal as Signal
import Effect (Effect)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Foreign.Object as FO
import Node.Platform (Platform)
import Node.Platform as Platform
import Node.Stream (Readable, Writable)

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
nextTick cb = runEffectFn1 nextTickImpl cb

foreign import nextTickImpl :: EffectFn1 (Effect Unit) (Unit)

-- | Get a copy of the array containing the command line arguments.
foreign import argv :: Effect (Array String)

-- | Get a copy of the Node-specific options passed to the `node` executable.
foreign import execArgv :: Effect (Array String)

-- | The absolute pathname of the `node` executable that started the
-- | process.
foreign import execPath :: Effect (String)

-- | Change the current working directory of the process. If the current
-- | directory could not be changed, an exception will be thrown.
chdir :: String -> Effect Unit
chdir dir = runEffectFn1 chdirImpl dir

foreign import chdirImpl :: EffectFn1 (String) (Unit)

-- | Get the current working directory of the process.
foreign import cwd :: Effect (String)

-- | Get a copy of the current environment.
-- | If you only want to look up a value without paying
-- | for the overhead of the copy, use `lookupEnv`.
foreign import getEnv :: Effect (FO.Object String)

-- | Get the current environment object without copying it.
-- | Any mutations to the returned object 
-- | or any mutations via `unsetEnv` and `setEnv`
-- | will affect all values that were obtained 
-- | via this function.
-- | Thus, this is an internal function that is
-- | not exported.
foreign import unsafeGetEnv :: Effect (FO.Object String)

-- | Lookup a particular environment variable.
lookupEnv :: String -> Effect (Maybe String)
lookupEnv k = map (FO.lookup k) $ unsafeGetEnv

-- | Set an environment variable.
setEnv :: String -> String -> Effect Unit
setEnv key value = runEffectFn2 setEnvImpl key value

foreign import setEnvImpl :: EffectFn2 (String) (String) (Unit)

-- | Delete an environment variable.
-- | Use case: to hide secret environment variable from child processes.
unsetEnv :: String -> Effect Unit
unsetEnv key = runEffectFn1 unsetEnvImpl key

foreign import unsetEnvImpl :: EffectFn1 (String) (Unit)

foreign import pid :: Pid

platform :: Maybe Platform
platform = Platform.fromString platformStr

foreign import platformStr :: String

-- | Cause the process to exit with the supplied integer code. An exit code
-- | of 0 is normally considered successful, and anything else is considered a
-- | failure.
exit :: forall a. Int -> Effect a
exit code = runEffectFn1 exitImpl code

foreign import exitImpl :: forall a. EffectFn1 (Int) (a)

-- | The standard input stream. Note that this stream will never emit an `end`
-- | event, so any handlers attached via `onEnd` will never be called.
foreign import stdin :: Readable ()

-- | The standard output stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
foreign import stdout :: Writable ()

-- | The standard error stream. Note that this stream cannot be closed; calling
-- | `end` will result in an exception being thrown.
foreign import stderr :: Writable ()

-- | Check whether the standard input stream appears to be attached to a TTY.
-- | It is a good idea to check this before processing the input data from stdin.
foreign import stdinIsTTY :: Boolean

-- | Check whether the standard output stream appears to be attached to a TTY.
-- | It is a good idea to check this before printing ANSI codes to stdout
-- | (e.g. for coloured text in the terminal).
foreign import stdoutIsTTY :: Boolean

-- | Check whether the standard error stream appears to be attached to a TTY.
-- | It is a good idea to check this before printing ANSI codes to stderr
-- | (e.g. for coloured text in the terminal).
foreign import stderrIsTTY :: Boolean

-- | Get the Node.js version.
foreign import version :: String
