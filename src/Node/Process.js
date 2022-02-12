"use strict";

export {process};

export function onBeforeExit(callback) {
  return function () {
    process.on("beforeExit", callback);
  };
}

export function onExit(callback) {
  return function () {
    process.on("exit", function (code) {
      callback(code)();
    });
  };
}

export function onUncaughtException(callback) {
  return function () {
    process.on("uncaughtException", function (error) {
      callback(error)();
    });
  };
}

export function onUnhandledRejection(callback) {
  return function () {
    process.on("unhandledRejection", function (error, promise) {
      callback(error)(promise)();
    });
  };
}

export function onSignalImpl(signal) {
  return function (callback) {
    return function () {
      process.on(signal, callback);
    };
  };
}

export function chdir(dir) {
  return function () {
    process.chdir(dir);
  };
}

export function setEnv(var_) {
  return function (val) {
    return function () {
      process.env[var_] = val;
    };
  };
}

export function unsetEnv(var_) {
  return function () {
    delete process.env[var_];
  };
}

export function exit(code) {
  return function () {
    process.exit(code);
  };
}

export function copyArray(xs) {
  return function () {
    return xs.slice();
  };
}

export function copyObject(o) {
  return function () {
    return Object.assign({}, o);
  };
}
