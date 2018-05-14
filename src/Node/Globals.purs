-- | Global objects exposed by Node.js. See also the [Node.js API
-- | documentation](https://nodejs.org/api/globals.html).
module Node.Globals where

import Effect (Effect)

-- | The name of the directory that the currently executing script resides in.
-- |
-- | Note that this will probably not give you a very useful answer unless you
-- | have bundled up your PureScript code using `psc-bundle`!
foreign import __dirname :: String

-- | The absolute path of the code file being executed.
-- |
-- | Note that this will probably not give you a very useful answer unless you
-- | have bundled up your PureScript code using `psc-bundle`!
foreign import __filename :: String

-- | Just calls `require`. You might also consider using the FFI instead. This
-- | function is, in general, horribly unsafe, and may perform side effects.
foreign import unsafeRequire :: forall a. String -> a

-- | `require.resolve()`. Use the internal `require` machinery to look up the
-- | location of a module, but rather than loading the module, just return the
-- | resolved filename.
foreign import requireResolve :: String -> Effect String
