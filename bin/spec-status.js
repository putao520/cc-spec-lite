#!/usr/bin/env node

/**
 * spec-status - Quick status command
 */

const installer = require('../lib/installer');

installer.status().catch(err => {
  console.error('Status check failed:', err.message);
  process.exit(1);
});
