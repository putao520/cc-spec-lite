/**
 * Platform detection utilities
 */

const path = require('path');
const os = require('os');

/**
 * Detect current platform
 * @returns {string} Platform identifier (linux/macos/windows)
 */
function detectPlatform() {
  switch (process.platform) {
    case 'linux':
      return 'linux';
    case 'darwin':
      return 'macos';
    case 'win32':
      return 'windows';
    default:
      return 'unknown';
  }
}

/**
 * Get Claude installation directory for current platform
 * @returns {string} Installation directory path
 */
function getInstallDir() {
  return path.join(os.homedir(), '.claude');
}

/**
 * Get backup directory path
 * @returns {string} Backup directory path with timestamp
 */
function getBackupDir() {
  const installDir = getInstallDir();
  const timestamp = new Date()
    .toISOString()
    .replace(/[:.]/g, '-')
    .slice(0, 19);
  return path.join(installDir, 'backup', `cc-spec-lite-${timestamp}`);
}

module.exports = {
  detectPlatform,
  getInstallDir,
  getBackupDir
};
