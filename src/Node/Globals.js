"use strict";

export {__dirname};
export {__filename};
export {require as unsafeRequire};

export function requireResolve(mod) {
  return function () {
    return require.resolve(mod);
  };
}
