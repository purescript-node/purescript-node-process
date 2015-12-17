"use strict";
/* global exports */
/* global require */
/* global __dirname */
/* global __filename  */

// module Node.Globals

exports.__dirname = __dirname;
exports.__filename = __filename;
exports.unsafeRequire = require;

exports.requireResolve = function(mod) {
  return function() {
    return require.resolve(mod);
  };
};
