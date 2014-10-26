requirejs = require("requirejs");

requirejs.config({
  nodeRequire: require,
  paths: {
    'text': "../lib/text",
    'json': "../lib/json",
    'src': "../src",
    'ls': "../lib/ls",
    'package': "../package.json"
  }
});

module.exports = requirejs;
