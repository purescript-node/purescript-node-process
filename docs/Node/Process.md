## Module Node.Process

Bindings to the global `process` object in Node.js. See also [the Node API documentation](https://nodejs.org/api/process.html)

#### `PROCESS`

``` purescript
data PROCESS :: !
```

An effect tracking interaction with the global `process` object.

#### `onBeforeExit`

``` purescript
onBeforeExit :: forall eff. Eff (process :: PROCESS | eff) Unit -> Eff (process :: PROCESS | eff) Unit
```

Register a callback to be performed when the event loop empties, and
Node.js is about to exit. Asynchronous calls can be made in the callback,
and if any are made, it will cause the process to continue a little longer.

#### `onExit`

``` purescript
onExit :: forall eff. (Int -> Eff (process :: PROCESS | eff) Unit) -> Eff (process :: PROCESS | eff) Unit
```

Register a callback to be performed when the process is about to exit.
Any work scheduled via asynchronous calls made here will not be performed
in time.

The argument to the callback is the exit code which the process is about
to exit with.

#### `onSignal`

``` purescript
onSignal :: forall eff. String -> Eff (process :: PROCESS | eff) Unit -> Eff (process :: PROCESS | eff) Unit
```

Install a handler for a particular signal.

#### `argv`

``` purescript
argv :: forall eff. Eff (process :: PROCESS | eff) (Array String)
```

Get an array containing the command line arguments. Be aware
that this can change over the course of the program.

#### `execArgv`

``` purescript
execArgv :: forall eff. Eff (process :: PROCESS | eff) (Array String)
```

Node-specific options passed to the `node` executable. Be aware that
this can change over the course of the program.

#### `execPath`

``` purescript
execPath :: forall eff. Eff (process :: PROCESS | eff) String
```

The absolute pathname of the `node` executable that started the
process.

#### `chdir`

``` purescript
chdir :: forall eff. String -> Eff (err :: EXCEPTION, process :: PROCESS | eff) Unit
```

Change the current working directory of the process. If the current
directory could not be changed, an exception will be thrown.

#### `cwd`

``` purescript
cwd :: forall eff. Eff (process :: PROCESS | eff) String
```

Get the current working directory of the process.

#### `getEnv`

``` purescript
getEnv :: forall eff. Eff (process :: PROCESS | eff) (StrMap String)
```

Get a copy of the current environment.

#### `lookupEnv`

``` purescript
lookupEnv :: forall eff. String -> Eff (process :: PROCESS | eff) (Maybe String)
```

Lookup a particular environment variable.

#### `setEnv`

``` purescript
setEnv :: forall eff. String -> String -> Eff (process :: PROCESS | eff) Unit
```

Set an environment variable.

#### `pid`

``` purescript
pid :: Int
```

#### `platform`

``` purescript
platform :: Platform
```

#### `exit`

``` purescript
exit :: forall eff. Int -> Eff (process :: PROCESS | eff) Unit
```

Cause the process to exit with the supplied integer code. An exit code
of 0 is normally considered successful, and anything else is considered a
failure.

#### `stdin`

``` purescript
stdin :: forall eff. Readable () (console :: CONSOLE | eff)
```

The standard input stream. Note that this stream will never emit an `end`
event, so any handlers attached via `onEnd` will never be called.

#### `stdout`

``` purescript
stdout :: forall eff. Writable () (console :: CONSOLE | eff)
```

The standard output stream. Note that this stream cannot be closed; calling
`end` will result in an exception being thrown.

#### `stderr`

``` purescript
stderr :: forall eff. Writable () (console :: CONSOLE | eff)
```

The standard error stream. Note that this stream cannot be closed; calling
`end` will result in an exception being thrown.

#### `stdoutIsTTY`

``` purescript
stdoutIsTTY :: Boolean
```

Check whether the process is being run inside a TTY context

#### `version`

``` purescript
version :: String
```

Get the Node.js version.


