-- | Bindings to the global `process` object in Node.js. See also [the Node API documentation](https://nodejs.org/api/process.html)
module Node.Process
  ( onBeforeExit
  , onExit
  , onSignal
  , onUncaughtException
  , onUnhandledRejection
  , abort
  , argv
  , argv0
  , channelRef
  , channelUnref
  , chdir
  , config
  , connected
  , CpuUsage
  , cpuUsageToRecord
  , cpuUsage
  , cpuUsageDiff
  , cwd
  , debugPort
  , disconnect
  , getEnv
  , lookupEnv
  , setEnv
  , unsetEnv
  , execArgv
  , execPath
  , exit
  , exit'
  , setExitCode
  , getExitCode
  , hasUncaughtExceptionCaptureCallback
  , kill
  , killStr
  , killInt
  , MemoryUsage
  , memoryUsage
  , memoryUsageRss
  , nextTick
  , nextTick'
  , pid
  , platform
  , platformStr
  , ppid
  , ResourceUsage
  , resourceUsage
  , unsafeSend
  , JsSendOptions
  , unsafeSendOpts
  , unsafeSendCb
  , unsafeSendOptsCb
  , setUncaughtExceptionCaptureCallback
  , clearUncaughtExceptionCaptureCallback
  , stdin
  , stdout
  , stderr
  , stdinIsTTY
  , stdoutIsTTY
  , stderrIsTTY
  , getTitle
  , setTitle
  , uptime
  , version
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Posix (Pid)
import Data.Posix.Signal (Signal)
import Data.Posix.Signal as Signal
import Effect (Effect)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4)
import Foreign (Foreign)
import Foreign.Object as FO
import Node.Platform (Platform)
import Node.Platform as Platform
import Node.Stream (Readable, Writable)
import Prim.Row as Row

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

-- | The `process.abort()` method causes the Node.js process to exit immediately and generate a core file.
-- | This feature is not available in Worker threads.
abort :: Maybe (Effect Unit)
abort = toMaybe abortImpl

foreign import abortImpl :: Nullable (Effect Unit)

-- | Get a copy of the array containing the command line arguments.
foreign import argv :: Effect (Array String)

-- | The process.argv0 property stores a read-only copy of the original value of argv[0] passed when Node.js starts.
foreign import argv0 :: Effect String

-- | This method makes the IPC channel keep the event loop of the process running if .unref() has been called before.
-- | Typically, this is managed through the number of 'disconnect' and 'message' listeners on the process object. 
-- | However, this method can be used to explicitly request a specific behavior.
-- |
-- | Context: if the Node.js process was spawned with an IPC channel (see the Child Process documentation), 
-- | the process.channel property is a reference to the IPC channel. If no IPC channel exists, this property is undefined.
channelRef :: Maybe (Effect Unit)
channelRef = toMaybe channelRefImpl

foreign import channelRefImpl :: Nullable (Effect Unit)

-- | This method makes the IPC channel not keep the event loop of the process running, 
-- | and lets it finish even while the channel is open.
-- | Typically, this is managed through the number of 'disconnect' and 'message' listeners on the process object. 
-- | However, this method can be used to explicitly request a specific behavior.
-- |
-- | Context: if the Node.js process was spawned with an IPC channel (see the Child Process documentation), 
-- | the process.channel property is a reference to the IPC channel. If no IPC channel exists, this property is undefined.
channelUnref :: Maybe (Effect Unit)
channelUnref = toMaybe channelUnrefImpl

foreign import channelUnrefImpl :: Nullable (Effect Unit)

-- | Change the current working directory of the process. If the current
-- | directory could not be changed, an exception will be thrown.
chdir :: String -> Effect Unit
chdir dir = runEffectFn1 chdirImpl dir

foreign import chdirImpl :: EffectFn1 (String) (Unit)

-- | Returns a copy of the Config value.
-- | The process.config property returns an Object containing the JavaScript representation of the configure options used to compile the current Node.js executable. 
-- | This is the same as the config.gypi file that was produced when running the ./configure script.
foreign import config :: Effect (Foreign)

-- | If the Node.js process is spawned with an IPC channel (see the Child Process and Cluster documentation), the process.connected property will return true so long as the IPC channel is connected and will return false after process.disconnect() is called.
-- | Once process.connected is false, it is no longer possible to send messages over the IPC channel using process.send().
foreign import connected :: Effect (Boolean)

newtype CpuUsage = CpuUsage { user :: Int, system :: Int }

derive instance Eq CpuUsage
instance Show CpuUsage where
  show (CpuUsage r) = "(CpuUsage " <> show r <> ")"

cpuUsageToRecord :: CpuUsage -> { user :: Int, system :: Int }
cpuUsageToRecord (CpuUsage r) = r

foreign import cpuUsage :: Effect (CpuUsage)

cpuUsageDiff :: CpuUsage -> Effect CpuUsage
cpuUsageDiff prev = runEffectFn1 cpuUsageDiffImpl prev

foreign import cpuUsageDiffImpl :: EffectFn1 (CpuUsage) (CpuUsage)

-- | Get the current working directory of the process.
foreign import cwd :: Effect (String)

foreign import debugPort :: Int

-- | If the Node.js process is spawned with an IPC channel (see the Child Process and Cluster documentation), the process.disconnect() method will close the IPC channel to the parent process, allowing the child process to exit gracefully once there are no other connections keeping it alive.
-- | The effect of calling process.disconnect() is the same as calling ChildProcess.disconnect() from the parent process.
-- |
-- | If the Node.js process was not spawned with an IPC channel, process.disconnect() will be undefined.
disconnect :: Maybe (Effect Unit)
disconnect = toMaybe disconnectImpl

foreign import disconnectImpl :: Nullable (Effect Unit)

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

-- | Get a copy of the Node-specific options passed to the `node` executable.
foreign import execArgv :: Effect (Array String)

-- | The absolute pathname of the `node` executable that started the
-- | process.
foreign import execPath :: Effect (String)

-- | Cause the process to exit immediately without completing any pending asynchronous operations
-- | including I/O operations to `process.stdout` and `process.stderr`.
-- | Process will exit with the `process.exitCode` value if it has been set
-- | or `0` (i.e. exit successfully) otherwise.
-- |
-- | Rather than using this function to exit, one should set `process.exitCode` and
-- | let Node gracefully exit once all pending asynchronous operations have completed.
-- | If it is necessary to terminate the Node.js process due to an error condition, 
-- | throwing an uncaught error and allowing the process to terminate accordingly 
-- | is safer than calling process.exit().
foreign import exit :: forall a. Effect a

-- | Cause the process to exit immediately without completing any pending asynchronous operations
-- | including I/O operations to `process.stdout` and `process.stderr`.
-- | An exit code of 0 is normally considered successful, and anything else is considered a
-- | failure.
-- |
-- | Rather than using this function to exit, one should set `process.exitCode` and
-- | let Node gracefully exit once all pending asynchronous operations have completed.
-- | If it is necessary to terminate the Node.js process due to an error condition, 
-- | throwing an uncaught error and allowing the process to terminate accordingly 
-- | is safer than calling process.exit().
exit' :: forall a. Int -> Effect a
exit' code = runEffectFn1 exitImpl code

foreign import exitImpl :: forall a. EffectFn1 (Int) (a)

-- | Sets the exit code to use when the process exits.
-- | An exit code of 0 is normally considered successful, and anything else is considered a
-- | failure.
-- |
-- | In comparison to `exit`/`exit'`, this is the safer way 
-- | to exit a Node.js process because any pending asynchronous operations
-- | including I/O operations to `process.stdout` and `process.stderr`
-- | will complete before the `Node.js` process exits.
setExitCode :: Int -> Effect Unit
setExitCode code = runEffectFn1 setExitCodeImpl code

foreign import setExitCodeImpl :: EffectFn1 (Int) (Unit)

-- | Gets the currently set exit code. This will be `Nothing`
-- | if the exit code has not been previously set.
getExitCode :: Effect (Maybe Int)
getExitCode = map toMaybe getExitCodeImpl

foreign import getExitCodeImpl :: Effect (Nullable Int)

foreign import hasUncaughtExceptionCaptureCallback :: Effect (Boolean)

kill :: Pid -> Effect Unit
kill p = runEffectFn1 killImpl p

foreign import killImpl :: EffectFn1 (Pid) (Unit)

killStr :: Pid -> String -> Effect Unit
killStr p sig = runEffectFn2 killStrImpl p sig

foreign import killStrImpl :: EffectFn2 (Pid) (String) (Unit)

killInt :: Pid -> Int -> Effect Unit
killInt p sig = runEffectFn2 killIntImpl p sig

foreign import killIntImpl :: EffectFn2 (Pid) (Int) (Unit)

-- | - `heapTotal` and `heapUsed` refer to V8's memory usage.
-- | - `external` refers to the memory usage of C++ objects bound to JavaScript objects managed by V8.
-- | - `rss`, Resident Set Size, is the amount of space occupied in the main memory device (that is a subset of the total allocated memory) for the process, including all C++ and JavaScript objects and code.
-- | - `arrayBuffers` refers to memory allocated for ArrayBuffers and SharedArrayBuffers, including all Node.js Buffers. This is also included in the external value. When Node.js is used as an embedded library, this value may be 0 because allocations for ArrayBuffers may not be tracked in that case.
type MemoryUsage =
  { rss :: Int
  , heapTotal :: Int
  , heapUsed :: Int
  , external :: Int
  , arrayBuffers :: Int
  }

-- | Returns an object describing the memory usage of the Node.js process measured in bytes.
-- | When using Worker threads, `rss` will be a value that is valid for the entire process, while the other fields will only refer to the current thread.
-- | The process.memoryUsage() method iterates over each page to gather information about memory usage which might be slow depending on the program memory allocations.
-- |
-- | Note: if one just wants the `rss` value, use `memoryUsageRss`, which is faster to compute.
foreign import memoryUsage :: Effect (MemoryUsage)

-- | The process.memoryUsage.rss() method returns an integer representing the Resident Set Size (RSS) in bytes.
-- | The Resident Set Size, is the amount of space occupied in the main memory device (that is a subset of the total allocated memory) for the process, including all C++ and JavaScript objects and code.
-- | This is the same value as the rss property provided by process.memoryUsage() but process.memoryUsage.rss() is faster.
foreign import memoryUsageRss :: Effect Int

-- | Register a callback to run as soon as the current event loop runs to
-- | completion.
-- | One should use `queueMicroTask` instead for most situations instead of `nextTick`. 
-- | See Node docs for more info.
nextTick :: Effect Unit -> Effect Unit
nextTick cb = runEffectFn1 nextTickImpl cb

foreign import nextTickImpl :: EffectFn1 (Effect Unit) (Unit)

-- | Register a callback that will receive the record arg as an argument
-- | to run as soon as the current event loop runs to completion.
-- | One should use `queueMicroTask` instead for most situations instead of `nextTick`. 
-- | See Node docs for more info.
nextTick' :: forall r. ({ | r } -> Effect Unit) -> { | r } -> Effect Unit
nextTick' cb args = runEffectFn2 nextTickCbImpl (mkEffectFn1 cb) args

foreign import nextTickCbImpl :: forall r. EffectFn2 (EffectFn1 { | r } Unit) ({ | r }) (Unit)

-- | Returns the PID of the current process.
foreign import pid :: Pid

platform :: Maybe Platform
platform = Platform.fromString platformStr

foreign import platformStr :: String

-- | Returns the PID of the parent of the current process.
foreign import ppid :: Pid

-- | - `userCPUTime` <integer> maps to ru_utime computed in microseconds. It is the same value as process.cpuUsage().user.
-- | - `systemCPUTime` <integer> maps to ru_stime computed in microseconds. It is the same value as process.cpuUsage().system.
-- | - `maxRSS` <integer> maps to ru_maxrss which is the maximum resident set size used in kilobytes.
-- | - `sharedMemorySize` <integer> maps to ru_ixrss but is not supported by any platform.
-- | - `unsharedDataSize` <integer> maps to ru_idrss but is not supported by any platform.
-- | - `unsharedStackSize` <integer> maps to ru_isrss but is not supported by any platform.
-- | - `minorPageFault` <integer> maps to ru_minflt which is the number of minor page faults for the process, see this article for more details.
-- | - `majorPageFault` <integer> maps to ru_majflt which is the number of major page faults for the process, see this article for more details. This field is not supported on Windows.
-- | - `swappedOut` <integer> maps to ru_nswap but is not supported by any platform.
-- | - `fsRead` <integer> maps to ru_inblock which is the number of times the file system had to perform input.
-- | - `fsWrite` <integer> maps to ru_oublock which is the number of times the file system had to perform output.
-- | - `ipcSent` <integer> maps to ru_msgsnd but is not supported by any platform.
-- | - `ipcReceived` <integer> maps to ru_msgrcv but is not supported by any platform.
-- | - `signalsCount` <integer> maps to ru_nsignals but is not supported by any platform.
-- | - `voluntaryContextSwitches` <integer> maps to ru_nvcsw which is the number of times a CPU context switch resulted due to a process voluntarily giving up the processor before its time slice was completed (usually to await availability of a resource). This field is not supported on Windows.
-- | - `involuntaryContextSwitches` <integer> maps to ru_nivcsw which is the number of times a CPU context switch resulted due to a higher priority process becoming runnable or because the current process exceeded its time slice. This field is not supported on Windows.

type ResourceUsage =
  { userCPUTime :: Int
  , systemCPUTime :: Int
  , maxRSS :: Int
  , sharedMemorySize :: Int
  , unsharedDataSize :: Int
  , unsharedStackSize :: Int
  , minorPageFault :: Int
  , majorPageFault :: Int
  , swappedOut :: Int
  , fsRead :: Int
  , fsWrite :: Int
  , ipcSent :: Int
  , ipcReceived :: Int
  , signalsCount :: Int
  , voluntaryContextSwitches :: Int
  , involuntaryContextSwitches :: Int
  }

foreign import resourceUsage :: Effect (ResourceUsage)

-- | Unsafe because child process must be a Node child process and an IPC channel must exist.
unsafeSend :: forall messageRows. { | messageRows } -> Nullable Foreign -> Effect Boolean
unsafeSend msg handle = runEffectFn2 sendImpl msg handle

foreign import sendImpl :: forall messageRows. EffectFn2 ({ | messageRows }) (Nullable Foreign) (Boolean)

-- | - `keepAlive` <boolean> A value that can be used when passing instances of `net.Socket` as the `Handle`. When true, the socket is kept open in the sending process. Default: false.
type JsSendOptions =
  ( keepAlive :: Boolean
  )

-- | Unsafe because process must be a Node child process and an IPC channel must exist.
unsafeSendOpts
  :: forall r trash messageRows
   . Row.Union r trash JsSendOptions
  => { | messageRows }
  -> Nullable Foreign
  -> { | r }
  -> Effect Boolean
unsafeSendOpts msg handle opts = runEffectFn3 sendOptsImpl msg handle opts

foreign import sendOptsImpl :: forall messageRows r. EffectFn3 ({ | messageRows }) (Nullable Foreign) ({ | r }) (Boolean)

-- | Unsafe because process must be a Node child process and an IPC channel must exist.
unsafeSendCb
  :: forall messageRows
   . { | messageRows }
  -> Nullable Foreign
  -> (Maybe Error -> Effect Unit)
  -> Effect Boolean
unsafeSendCb msg handle cb = runEffectFn3 sendCbImpl msg handle $ mkEffectFn1 \err -> cb $ toMaybe err

foreign import sendCbImpl :: forall messageRows. EffectFn3 ({ | messageRows }) (Nullable Foreign) (EffectFn1 (Nullable Error) Unit) (Boolean)

-- | Unsafe because process must be a Node child process and an IPC channel must exist.
unsafeSendOptsCb
  :: forall r trash messageRows
   . Row.Union r trash JsSendOptions
  => { | messageRows }
  -> Nullable Foreign
  -> { | r }
  -> (Maybe Error -> Effect Unit)
  -> Effect Boolean
unsafeSendOptsCb msg handle opts cb = runEffectFn4 sendOptsCbImpl msg handle opts $ mkEffectFn1 \err -> cb $ toMaybe err

foreign import sendOptsCbImpl :: forall messageRows r. EffectFn4 ({ | messageRows }) (Nullable Foreign) ({ | r }) (EffectFn1 (Nullable Error) Unit) (Boolean)

setUncaughtExceptionCaptureCallback :: Effect Unit -> Effect Unit
setUncaughtExceptionCaptureCallback cb = runEffectFn1 setUncaughtExceptionCaptureCallbackImpl cb

foreign import setUncaughtExceptionCaptureCallbackImpl :: EffectFn1 (Effect Unit) (Unit)

foreign import clearUncaughtExceptionCaptureCallback :: Effect Unit

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

-- | The process.title property returns the current process title (i.e. returns the current value of ps). 
foreign import getTitle :: Effect (String)

-- | The process.title property returns the current process title (i.e. returns the current value of ps). 
-- | Assigning a new value to process.title modifies the current value of ps.
-- | 
-- | When a new value is assigned, different platforms will impose different maximum length restrictions 
-- | on the title. Usually such restrictions are quite limited. For instance, on Linux and macOS, 
-- | process.title is limited to the size of the binary name plus the length of the command-line arguments 
-- | because setting the process.title overwrites the argv memory of the process. 
-- | Node.js v0.8 allowed for longer process title strings by also overwriting the environ memory but 
-- | that was potentially insecure and confusing in some (rather obscure) cases.
-- | 
-- | Assigning a value to process.title might not result in an accurate label within process manager 
-- | applications such as macOS Activity Monitor or Windows Services Manager.
setTitle :: String -> Effect Unit
setTitle newTitle = runEffectFn1 setTitleImpl newTitle

foreign import setTitleImpl :: EffectFn1 (String) (Unit)

-- | The process.uptime() method returns the number of seconds the current Node.js process has been running.
-- | The return value includes fractions of a second. Use `Data.Int.floor` to get whole seconds.
foreign import uptime :: Effect (Number)

-- | Get the Node.js version.
foreign import version :: String
