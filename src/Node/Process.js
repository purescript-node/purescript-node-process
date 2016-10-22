"use strict";

exports.process = process;

exports.onBeforeExit = function (callback) {
  return function () {
    process.on("beforeExit", callback);
  };
};

exports.onExit = function (callback) {
  return function () {
    process.on("exit", function (code) {
      callback(code)();
    });
  };
};

exports.onSignalImpl = function (signal) {
  return function (callback) {
    return function () {
      process.on(signal, callback);
    };
  };
};

exports.chdir = function (dir) {
  return function () {
    process.chdir(dir);
  };
};

exports.setEnv = function (var_) {
  return function (val) {
    return function () {
      process.env[var_] = val;
    };
  };
};

exports.exit = function (code) {
  return function () {
    process.exit(code);
  };
};
