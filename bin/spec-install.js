#!/usr/bin/env node

/**
 * spec-install - Quick install command
 */

const installer = require('../lib/installer');

// Simple install with default language
install({
  lang: 'en',
  force: false,
  skipAiw: false
}).catch(err => {
  console.error('Installation failed:', err.message);
  process.exit(1);
});
