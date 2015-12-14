"use strict";
// module Node.Process

exports.globalProcessObject = process;

exports.readMutableProperty = function(propName) {
    return function() {
        return process[propName];
    }
}
