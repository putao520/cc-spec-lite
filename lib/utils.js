/**
 * Utility functions
 */

/**
 * Compare two version strings
 * @param {string} v1 - First version
 * @param {string} v2 - Second version
 * @returns {number} 0=equal, 1=v1>v2, 2=v1<v2
 */
function versionCompare(v1, v2) {
  if (v1 === v2) return 0;

  const parts1 = v1.split('.').map(Number);
  const parts2 = v2.split('.').map(Number);

  // Pad shorter version with zeros
  const maxLen = Math.max(parts1.length, parts2.length);
  while (parts1.length < maxLen) parts1.push(0);
  while (parts2.length < maxLen) parts2.push(0);

  // Compare each segment
  for (let i = 0; i < maxLen; i++) {
    if (parts1[i] > parts2[i]) return 1;
    if (parts1[i] < parts2[i]) return -1;
  }

  return 0;
}

/**
 * Get aiw version
 * @returns {string|null} Version string or null if not found
 */
function getAIWVersion() {
  try {
    const { execSync } = require('child_process');
    const output = execSync('aiw --version', { encoding: 'utf8' });
    const match = output.match(/(\d+\.\d+\.\d+)/);
    return match ? match[1] : null;
  } catch {
    return null;
  }
}

/**
 * Check if command exists
 * @param {string} command - Command to check
 * @returns {boolean} True if command exists
 */
function commandExists(command) {
  try {
    const { execSync } = require('child_process');
    execSync(`which ${command}`, { stdio: 'ignore' });
    return true;
  } catch {
    try {
      execSync(`where ${command}`, { stdio: 'ignore' });
      return true;
    } catch {
      return false;
    }
  }
}

/**
 * Detect current language from existing installation
 * @param {string} installDir - Installation directory
 * @returns {Promise<string|null>} 'zh', 'en', or null
 */
async function detectCurrentLanguage(installDir) {
  const fs = require('fs-extra');
  const path = require('path');
  const versionFilePath = path.join(installDir, '.cc-spec-lite.json');

  if (fs.existsSync(versionFilePath)) {
    try {
      const versionInfo = await fs.readJSON(versionFilePath);
      return versionInfo.language || null;
    } catch {
      return null;
    }
  }

  return null;
}

/**
 * Detect system language using os-locale library
 * @returns {Promise<string>} 'zh' for Chinese locales, 'en' otherwise
 */
async function detectSystemLanguage() {
  try {
    const { osLocale } = require('os-locale');
    const locale = await osLocale();

    // Match all Chinese locales: zh, zh-CN, zh_CN, zh-cn, zh-TW, zh_TW, etc.
    if (/^zh([._-][A-Za-z]{2})?$/i.test(locale)) {
      return 'zh';
    }

    return 'en';
  } catch (error) {
    // Fallback to default if detection fails
    return 'zh';
  }
}

module.exports = {
  versionCompare,
  getAIWVersion,
  commandExists,
  detectCurrentLanguage,
  detectSystemLanguage
};
