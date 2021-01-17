# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v8.0.0](https://github.com/purescript-node/purescript-node-process/releases/tag/v8.0.0) - 2021-MONTH-DAY

Breaking changes:
  - Updated dependencies for PureScript 0.14 (#24)
  
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

- Add `OpenBSD`, `Android`, and `AIX` to `Platform` constructors (@AlexanderAA)
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
