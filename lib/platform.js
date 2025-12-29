/**
 * Platform detection utilities
 */

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
  if (process.platform === 'win32') {
    return `${process.env.USERPROFILE}\\.claude`;
  }
  return `${process.env.HOME}/.claude`;
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
  return `${installDir}/backup/cc-spec-lite-${timestamp}`;
}

module.exports = {
  detectPlatform,
  getInstallDir,
  getBackupDir
};
