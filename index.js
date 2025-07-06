/**
 * Sample package for Azure Artifacts feed
 * @param {string} name - The name to greet
 * @returns {string} A greeting message
 */
function greet(name) {
  return `Hello, ${name}! This package is from Azure Artifacts feed.`;
}

/**
 * Get the current version of the package
 * @returns {string} The package version
 */
function getVersion() {
  return require('./package.json').version;
}

module.exports = {
  greet,
  getVersion
};
