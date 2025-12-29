#!/usr/bin/env node

/**
 * cc-spec - Main CLI for cc-spec-lite
 * SPEC-driven development framework for Claude Code
 */

const { program } = require('commander');
const installer = require('../lib/installer');
const { detectSystemLanguage } = require('../lib/utils');

// Package info
const pkg = require('../package.json');

// Auto-detect default language based on system locale
const defaultLang = detectSystemLanguage();

program
  .name('cc-spec')
  .description('SPEC-driven development framework for Claude Code')
  .version(pkg.version);

program
  .command('install')
  .description('Install cc-spec-lite to ~/.claude')
  .option('-l, --lang <language>', 'Language (en/zh)', defaultLang)
  .option('-f, --force', 'Force reinstall (allows language switching)')
  .option('--skip-aiw', 'Skip aiw installation check')
  .action(installer.install);

program
  .command('uninstall')
  .description('Uninstall cc-spec-lite')
  .action(installer.uninstall);

program
  .command('update')
  .description('Update cc-spec-lite to latest version')
  .option('-l, --lang <language>', 'Switch language during update')
  .action(installer.update);

program
  .command('status')
  .description('Show installation status and information')
  .action(installer.status);

// Parse arguments
program.parse(process.argv);

// Show help if no command provided
if (!process.argv.slice(2).length) {
  program.outputHelp();
}
