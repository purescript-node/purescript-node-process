import process from "process";

export function onBeforeExit(callback) {
  return () => {
    process.on("beforeExit", callback);
  };
}

export function onExit(callback) {
  return () => {
    process.on("exit", code => {
      callback(code)();
    });
  };
}

export function onUncaughtException(callback) {
  return () => {
    process.on("uncaughtException", error => {
      callback(error)();
    });
  };
}

export function onUnhandledRejection(callback) {
  return () => {
    process.on("unhandledRejection", (error, promise) => {
      callback(error)(promise)();
    });
  };
}

export function onSignalImpl(signal) {
  return callback => () => {
    process.on(signal, callback);
  };
}

export const nextTickImpl = (cb) => process.nextTick(cb);
export const argv = () => process.argv.slice();
export const execArgv = () => process.execArgv.slice();
export const execPath = () => process.execPath;
export const chdirImpl = (dir) => process.chdir(dir);
export const cwd = () => process.cwd;
export const getEnv = () => Object.assign({}, process.env);
export const unsafeGetEnv = () => process.env;
export const setEnvImpl = (key, val) => {
  process.env[key] = val;
};
export const unsetEnvImpl = (key) => {
  delete process.env[key];
};
export const pid = process.pid;
export const platformStr = process.platform;
export const exitImpl = (code) => process.exit(code);
export const stdin = process.stdin;
export const stdout = process.stdout;
export const stderr = process.stderr;
export const stdinIsTTY = process.stdinIsTTY;
export const stdoutIsTTY = process.stdoutIsTTY;
export const stderrIsTTY = process.stderrIsTTY;
export const version = process.version;

