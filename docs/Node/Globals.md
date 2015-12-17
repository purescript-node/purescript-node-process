## Module Node.Globals

Global objects exposed by Node.js. See also the [Node.js API
documentation](https://nodejs.org/api/globals.html).

#### `__dirname`

``` purescript
__dirname :: String
```

The name of the directory that the currently executing script resides in.

Note that this will probably not give you a very useful answer unless you
have bundled up your PureScript code using `psc-bundle`!

#### `__filename`

``` purescript
__filename :: String
```

The absolute path of the code file being executed.

Note that this will probably not give you a very useful answer unless you
have bundled up your PureScript code using `psc-bundle`!

#### `unsafeRequire`

``` purescript
unsafeRequire :: forall a. String -> a
```

Just calls `require`. You might also consider using the FFI instead. This
function is, in general, horribly unsafe, and may perform side effects.

#### `requireResolve`

``` purescript
requireResolve :: forall eff. String -> Eff (fs :: FS | eff) String
```

`require.resolve()`. Use the internal `require` machinery to look up the
location of a module, but rather than loading the module, just return the
resolved filename.


