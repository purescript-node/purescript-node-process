## Module Node.Platform

This module defines data type for the different platforms supported by
Node.js

#### `Platform`

``` purescript
data Platform
  = Darwin
  | FreeBSD
  | Linux
  | SunOS
  | Win32
```

##### Instances
``` purescript
Show Platform
Eq Platform
Ord Platform
```

#### `toString`

``` purescript
toString :: Platform -> String
```

The String representation for a platform, recognised by Node.js.

#### `fromString`

``` purescript
fromString :: String -> Maybe Platform
```


