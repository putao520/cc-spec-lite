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
 * @returns {string|null} 'zh', 'en', or null
 */
function detectCurrentLanguage(installDir) {
  const fs = require('fs');
  const path = require('path');
  const claudePath = path.join(installDir, 'CLAUDE.md');

  if (fs.existsSync(claudePath)) {
    const content = fs.readFileSync(claudePath, 'utf8');
    return content.includes('文档定位') ? 'zh' : 'en';
  }

  return null;
}

/**
 * Detect system language and return default language for cc-spec
 * @returns {string} 'zh' for Chinese locales, 'en' otherwise
 */
function detectSystemLanguage() {
  // Check environment variables in order of priority
  const langVars = [
    process.env.LC_ALL,
    process.env.LC_MESSAGES,
    process.env.LANG,
    process.env.LANGUAGE
  ];

  for (const langVar of langVars) {
    if (langVar) {
      // Match Chinese locales: zh_CN, zh_CN.UTF-8, zh-SG, zh-Hans, etc.
      if (/^zh(_|-)?CN/i.test(langVar)) {
        return 'zh';
      }
    }
  }

  // Check macOS specific
  if (process.platform === 'darwin') {
    try {
      const { execSync } = require('child_process');
      const locale = execSync('defaults read -g AppleLocale', { encoding: 'utf8' }).trim();
      if (locale === 'zh_CN') {
        return 'zh';
      }
    } catch {
      // Ignore errors, fall through to default
    }
  }

  // Check Windows specific
  if (process.platform === 'win32') {
    const geoId = process.env.GEOID || '';
    // China GeoID is 45 (CN)
    if (geoId === '45' || geoId === 'CN') {
      return 'zh';
    }
  }

  // Default to English for all other regions
  return 'en';
}

module.exports = {
  versionCompare,
  getAIWVersion,
  commandExists,
  detectCurrentLanguage,
  detectSystemLanguage
};
