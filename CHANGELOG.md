# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v11.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v11.0.0) - 2023-07-21

Bugfixes:
- Fix FFI for `channelRef`/`channelUnref` (#40 by @JordanMartinez)

## [v11.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v11.0.0) - 2023-07-21

Breaking changes:
- Breaking changes to `exit` (#39 by @JordanMartinez)

  The `exit` API provides two versions:
    - unspecified exit code: `process.exit();`
    - specified exit code: `process.exit(1);`

  Previously, the type signature of `exit` only allowed
  the second usage. This change supports both.
  Followin the pattern used in other Node libraries
  of a `'` (prime) character indicating a
  variant of the function that takes a callback or optons
  are, the type signature of `exit` has changed:

  ```purs
  -- before:
  exit :: forall a. Int -> Effect a

  -- after:
  exit :: forall a. Effect a

  exit' :: forall a. Int -> Effect a
  ```
- Bump `node-streams` to `v8.0.0` (#40 by @JordanMartinez)
- Migrate `onEventName` to `eventH`-style event handling API (#40 by @JordanMartinez)

  ```purs
  -- Before
  onExit \exitCode -> ...

  -- After
  process # on_ exitH \exitCode ->
  ```

  See https://pursuit.purescript.org/packages/purescript-node-event-emitter/3.0.0/docs/Node.EventEmitter for more details.

  `onSignal` has many possible enumerations, so a generic one was provided instead:
  ```purs
  -- Before
  onSignalExit SIGTERM do
    ...

  -- After
  process # on_ (mkSignalH SIGTERM) do
    ...
  -- Or, is `Signal` doesn't have it
  process # on_ (mkSignalH' "SIGTERM") do
    ...
  ```

New features:
- Add missing APIs (#39 by @JordanMartinez)

  - Process-related things
    - `abort`
    - `setExitCode`
    - `getExitCode`
    - `kill`/`killStr`/`kilInt`
    - `nextTick'`
    - `ppid`
    - Uncaught exception capture callback
      - `hasUncaughtExceptionCaptureCallback`
      - `setUncaughtExceptionCaptureCallback`
      - `clearUncaughtExceptionCaptureCallback`
    - `getTitle`/`setTitle`
  - ChildProcess-related things
    - `channelRef`/`channelUnref`
    - `connected`
    - `unsafeSend`/`unsafeSendOpts`/`unsafeSendCb`/`unsafeSendOptsCb`
  - Diagnostic-related things
    - `config`
    - `cpuUsage`/`cpuUsageDiff`
    - `debugPort`
    - `memoryUsage`/`memoryUsageRss`
    - `resourceUsage`
    - `uptime`

Bugfixes:
- Docs: discourage `exit` in favor of `setExitCode` (#39 by @JordanMartinez)

Other improvements:
- Bumped CI's node version to `lts/*` (#37 by @JordanMartinez)
- Updated CI `actions/checkout` and `actions/setup-nodee` to `v3` (#37 by @JordanMartinez)
- Format codebase & enforce formatting in CI via purs-tidy (#37 by @JordanMartinez)
- Use uncurried FFI (#38 by @JordanMartinez)
- Reordered export list (#39 by @JordanMartinez)

## [v10.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v10.0.0) - 2022-04-29

Breaking changes:
- Update project and deps to PureScript v0.15.0 (#34 by @nwolverson, @JordanMartinez, @sigma-andex)

New features:

Bugfixes:

Other improvements:

## [v9.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v9.0.0) - 2022-04-27

Due to implementing a breaking change incorrectly, use v10.0.0 instead.

## [v8.2.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v8.2.0) - 2021-05-06

New features:
- Export `nextTick` (#32 by @JordanMartinez)

Other improvements:
- Fix warnings revealed by v0.14.1 PS release (#32 by @JordanMartinez)

## [v8.1.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v8.1.0) - 2021-03-19

New features:
- Added `stdinIsTTY` as the counterpart of `process.stdin.isTTY` (#31 by @matoruru)

## [v8.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v8.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#24)

New features:
- Added functions to register handlers for the `uncaughtException` and `unhandledRejection` events on the process (#20)
- Added `unsetEnv` for deleting environment variables (#21)

Bugfixes:
- Updated the implementations of `argv`, `execArgv`, and `getEnv` so they clone the argument array to ensure referential transparency (#26)

Other improvements:
- Migrated CI to GitHub Actions, updated installation instructions to use Spago, and migrated from `jshint` to `eslint` (#22)
- Added a changelog and pull request template (#27)

## [v7.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v7.0.0) - 2019-03-15

- Updated `purescript-foreign-object` dependency

## [v6.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v6.0.0) - 2018-05-29

- Updated for 0.12

## [v5.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v5.0.0) - 2017-08-04

- Added `OpenBSD`, `Android`, and `AIX` to `Platform` constructors (@AlexanderAA)
- Made `Node.Process.platform` return a `Maybe Platform` to avoid crashes on unrecognised operating systems
- Used `exception :: EXCEPTION` where appropriate instead of the previous `err :: EXCEPTION` to bring this library into line with the types used in recent versions of `purescript-exceptions` (@nwolverson)

## [v4.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v4.0.0) - 2017-04-05

- Updated for 0.11 compiler (@simonyangme)

## [v3.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v3.0.0) - 2016-10-22

- Updated dependencies

## [v2.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v2.0.0) - 2016-07-31

- Updated dependencies

## [v1.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v1.0.0) - 2016-06-12

- Compatibility with 0.9.x of the compiler.

## [v0.5.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v0.5.0) - 2016-03-31

- Bumped dependencies

## [v0.1.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v0.1.0) - 2015-12-04

- Initial release
