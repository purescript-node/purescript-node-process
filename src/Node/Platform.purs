-- | This module defines data type for the different platforms supported by
-- | Node.js
module Node.Platform where

import Prelude
import Data.Maybe (Maybe(..))

data Platform
  = Darwin
  | FreeBSD
  | Linux
  | SunOS
  | Win32

-- | The String representation for a platform, recognised by Node.js.
toString :: Platform -> String
toString Darwin  = "darwin"
toString FreeBSD = "freebsd"
toString Linux   = "linux"
toString SunOS   = "sunos"
toString Win32   = "win32"

fromString :: String -> Maybe Platform
fromString "darwin"  = Just Darwin
fromString "freebsd" = Just FreeBSD
fromString "linux"   = Just Linux
fromString "sunos"   = Just SunOS
fromString "win32"   = Just Win32
fromString _         = Nothing

instance showPlatform :: Show Platform where
  show Darwin  = "Darwin"
  show FreeBSD = "FreeBSD"
  show Linux   = "Linux"
  show SunOS   = "SunOS"
  show Win32   = "Win32"

derive instance eqPlatform :: Eq Platform
derive instance ordPlatform :: Ord Platform
