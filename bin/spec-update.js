#!/usr/bin/env node

/**
 * spec-update - Quick update command
 */

const installer = require('../lib/installer');

installer.update({
  lang: undefined // Auto-detect current language
}).catch(err => {
  console.error('Update failed:', err.message);
  process.exit(1);
});
