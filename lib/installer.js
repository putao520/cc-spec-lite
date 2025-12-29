/**
 * Main installer logic for cc-spec-lite
 */

const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const ora = require('ora');
const { execSync } = require('child_process');
const { detectPlatform, getInstallDir, getBackupDir } = require('./platform');
const { versionCompare, getAIWVersion, commandExists, detectCurrentLanguage } = require('./utils');

// Constants
const AIW_MIN_VERSION = '0.5.36';
const BACKUP_INFO_FILE = '.cc-spec-backup.json';
const VERSION_FILE = '.cc-spec-lite.json';

/**
 * Get backup info file path
 */
function getBackupInfoPath() {
  const installDir = getInstallDir();
  return path.join(installDir, BACKUP_INFO_FILE);
}

/**
 * Get version file path
 */
function getVersionFilePath() {
  const installDir = getInstallDir();
  return path.join(installDir, VERSION_FILE);
}

/**
 * Save version info
 */
async function saveVersionInfo(version, language) {
  const info = {
    version: version,
    language: language,
    installedAt: new Date().toISOString()
  };

  const versionPath = getVersionFilePath();
  await fs.writeJSON(versionPath, info, { spaces: 2 });
}

/**
 * Get version info
 */
async function getVersionInfo() {
  const versionPath = getVersionFilePath();

  if (fs.existsSync(versionPath)) {
    return await fs.readJSON(versionPath);
  }

  return null;
}

/**
 * Save backup information
 */
async function saveBackupInfo(backupDir, version) {
  const info = {
    backup: backupDir,
    installedAt: new Date().toISOString(),
    version: version
  };

  const infoPath = getBackupInfoPath();
  await fs.writeJSON(infoPath, info, { spaces: 2 });
}

/**
 * Get backup information
 */
async function getBackupInfo() {
  const infoPath = getBackupInfoPath();

  if (fs.existsSync(infoPath)) {
    return await fs.readJSON(infoPath);
  }

  return null;
}

/**
 * Restore backup
 */
async function restoreBackup(backupDir) {
  const installDir = getInstallDir();

  if (!fs.existsSync(backupDir)) {
    console.log(chalk.yellow(`Backup not found: ${backupDir}`));
    return false;
  }

  const spinner = ora('Restoring backup...').start();

  try {
    // Copy backup back to install dir
    await fs.copy(backupDir, installDir, {
      overwrite: true,
      filter: (src) => !src.includes('backup')
    });

    spinner.succeed('Backup restored successfully');
    return true;
  } catch (error) {
    spinner.fail('Restore failed');
    console.error(chalk.red(error.message));
    return false;
  }
}

/**
 * Main install function
 */
async function install(options = {}) {
  const pkg = require('../package.json');

  // If called from npm script, options might be undefined
  if (!options.lang) {
    const { detectSystemLanguage } = require('./utils');
    options.lang = await detectSystemLanguage();
  }

  // Ensure options has required boolean flags
  if (options.force === undefined) options.force = false;
  if (options.skipAiw === undefined) options.skipAiw = false;

  console.log(chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'));
  console.log(chalk.blue(`  cc-spec-lite Installer v${pkg.version}`));
  console.log(chalk.blue('  SPEC-driven development framework for Claude Code'));
  console.log(chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'));

  const platform = detectPlatform();
  const installDir = getInstallDir();

  console.log(chalk.cyan(`Platform: ${platform}`));
  console.log(chalk.cyan(`Target: ${installDir}\n`));

  // Detect existing installation
  const currentLang = await detectCurrentLanguage(installDir);

  // Auto-select language: keep existing, or use OS locale
  if (currentLang) {
    options.lang = currentLang;
    console.log(chalk.cyan(`Existing installation detected: ${currentLang}\n`));
  } else {
    // Detect from OS if not specified
    if (!options.lang) {
      const { detectSystemLanguage } = require('./utils');
      options.lang = await detectSystemLanguage();
    }
    console.log(chalk.cyan(`Auto-detected language: ${options.lang}\n`));
  }

  // Backup logic: only backup on first installation, not on updates
  let backupDir = null;
  const isUpdate = currentLang !== null;  // Already has cc-spec-lite installed

  if (fs.existsSync(installDir) && !isUpdate) {
    // First installation with existing user config - backup it!
    backupDir = getBackupDir();
    const spinner = ora('Backing up existing configuration...').start();

    try {
      await fs.ensureDir(backupDir);
      await fs.copy(installDir, backupDir, {
        filter: (src) => !src.includes('backup')
      });
      spinner.succeed(`Backed up existing config to: ${backupDir}`);

      // Save backup info
      await saveBackupInfo(backupDir, pkg.version);
    } catch (error) {
      spinner.warn('Backup failed (continuing anyway)');
    }
  } else if (isUpdate) {
    console.log(chalk.cyan('Update mode: existing cc-spec-lite installation will be updated\n'));
  }

  // Copy files
  const copySpinner = ora(`Installing ${options.lang} files...`).start();

  try {
    const resourceDir = path.join(__dirname, '..', 'resources', options.lang);

    if (!fs.existsSync(resourceDir)) {
      copySpinner.fail(`Language directory not found: ${resourceDir}`);
      process.exit(1);
    }

    await fs.ensureDir(installDir);
    await fs.copy(resourceDir, installDir);

    // Set executable permissions for script files on Unix systems
    if (process.platform !== 'win32') {
      const { execSync } = require('child_process');
      const scriptsDir = path.join(installDir, 'scripts');

      if (fs.existsSync(scriptsDir)) {
        try {
          execSync(`chmod -R 755 "${scriptsDir}"`, { stdio: 'ignore' });
        } catch (chmodError) {
          // Non-fatal, just warn
          copySpinner.warn('Scripts may not be executable');
        }
      }

      // Also set permissions for hook files if they exist
      const hooksDir = path.join(installDir, 'hooks');
      if (fs.existsSync(hooksDir)) {
        try {
          execSync(`chmod -R 755 "${hooksDir}"`, { stdio: 'ignore' });
        } catch (chmodError) {
          // Non-fatal
        }
      }
    }

    copySpinner.succeed(`Installed ${options.lang} files`);
  } catch (error) {
    copySpinner.fail('Installation failed');
    console.error(chalk.red(error.message));
    process.exit(1);
  }

  // Check aiw
  if (!options.skipAiw) {
    await checkAIW(options.lang);
  } else {
    console.log(chalk.yellow('\n⚠ Skipped aiw check (--skip-aiw flag)\n'));
  }

  // Save version info
  await saveVersionInfo(pkg.version, options.lang);

  // Success message
  console.log(chalk.green('\n✓ Installation completed!\n'));
  console.log(chalk.cyan('Language:'), options.lang);
  console.log(chalk.cyan('Location:'), installDir);
  console.log();
  console.log(chalk.cyan('Next steps:'));
  console.log('  1. Restart Claude Code');
  console.log('  2. Use /spec-init to initialize your project');
  console.log();
}

/**
 * Uninstall function
 */
async function uninstall() {
  const installDir = getInstallDir();
  const backupInfo = await getBackupInfo();

  // Require --force flag or environment variable for non-interactive uninstall
  const force = process.env.FORCE_UNINSTALL === '1' || process.argv.includes('--force');

  if (!force) {
    console.log(chalk.red('\nUninstall requires confirmation.'));
    console.log(chalk.cyan('Please run with --force flag or set FORCE_UNINSTALL=1\n'));
    console.log(chalk.cyan('Example: cc-spec uninstall --force\n'));
    process.exit(1);
  }

  console.log(chalk.cyan('Uninstalling cc-spec-lite...\n'));

  // If backup exists, restore it
  if (backupInfo && fs.existsSync(backupInfo.backup)) {
    console.log(chalk.cyan(`Found backup from ${backupInfo.installedAt}\n`));

    const restored = await restoreBackup(backupInfo.backup);
    if (restored) {
      // Remove backup info file and version file
      const infoPath = getBackupInfoPath();
      const versionPath = getVersionFilePath();
      if (fs.existsSync(infoPath)) {
        await fs.remove(infoPath);
      }
      if (fs.existsSync(versionPath)) {
        await fs.remove(versionPath);
      }

      console.log(chalk.green('\n✓ Uninstalled and backup restored\n'));
      return;
    }
  }

  // No restore or restore failed, proceed with uninstall
  const spinner = ora('Uninstalling...').start();

  try {
    // Remove files but keep backup directory
    const files = ['CLAUDE.md', 'skills', 'commands', 'scripts', 'roles', 'hooks', BACKUP_INFO_FILE, VERSION_FILE];

    for (const file of files) {
      const targetPath = path.join(installDir, file);
      if (fs.existsSync(targetPath)) {
        await fs.remove(targetPath);
      }
    }

    spinner.succeed('Uninstalled successfully\n');
    console.log(chalk.cyan('Backup files preserved in:'));
    console.log(chalk.cyan(`  ${path.join(installDir, 'backup')}\n`));
  } catch (error) {
    spinner.fail('Uninstall failed');
    console.error(chalk.red(error.message));
    process.exit(1);
  }
}

/**
 * Update function
 */
async function update(options) {
  console.log(chalk.cyan('Updating cc-spec-lite...\n'));
  await install({ ...options, force: true });
}

/**
 * Status function
 */
async function status() {
  const installDir = getInstallDir();
  const platform = detectPlatform();

  console.log(chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'));
  console.log(chalk.blue('  cc-spec-lite Status'));
  console.log(chalk.blue('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'));

  console.log(chalk.cyan('Platform:'), platform);
  console.log(chalk.cyan('Install Dir:'), installDir);

  // Check if installed
  if (!fs.existsSync(installDir)) {
    console.log(chalk.red('\nStatus: Not installed\n'));
    return;
  }

  const lang = await detectCurrentLanguage(installDir);
  console.log(chalk.cyan('Language:'), lang || 'unknown');

  // Check version info
  const versionInfo = await getVersionInfo();
  if (versionInfo) {
    console.log(chalk.cyan('Version:'), versionInfo.version);
    console.log(chalk.cyan('Installed:'), new Date(versionInfo.installedAt).toLocaleString());
  } else {
    console.log(chalk.yellow('Version:'), 'unknown (legacy installation)');
  }

  // Count files
  try {
    const skills = await fs.readdir(path.join(installDir, 'skills')).catch(() => []);
    const commands = await fs.readdir(path.join(installDir, 'commands')).catch(() => []);

    console.log(chalk.cyan('Skills:'), skills.length || 0);
    console.log(chalk.cyan('Commands:'), commands.length || 0);
  } catch (error) {
    console.log(chalk.red('Error reading installation'));
  }

  // Check aiw
  const aiwVersion = getAIWVersion();
  if (aiwVersion) {
    console.log(chalk.cyan('aiw:'), `v${aiwVersion}`);
  } else {
    console.log(chalk.yellow('aiw:'), 'not found');
  }

  console.log();
}

/**
 * Check and install aiw
 */
async function checkAIW(lang) {
  const spinner = ora('Checking AI Warden CLI (aiw)...').start();

  const aiwVersion = getAIWVersion();

  if (aiwVersion) {
    spinner.succeed(`aiw found: v${aiwVersion}`);

    // Check version
    const comparison = versionCompare(aiwVersion, AIW_MIN_VERSION);

    if (comparison === -1) {
      console.log(chalk.yellow(`\n⚠ aiw version ${aiwVersion} is below minimum ${AIW_MIN_VERSION}`));
      console.log(chalk.cyan('Please update: npm install -g @putao520/aiw\n'));
    }
  } else {
    spinner.warn('aiw not found');
    console.log(chalk.cyan('\nInstalling aiw...\n'));
    await installAIW(lang);
  }
}

/**
 * Copy role files to aiw
 */
async function copyRoles(lang, force = false) {
  const spinner = ora('Setting up aiw roles...').start();

  try {
    const aiwRoleDir = path.join(process.env.HOME, '.aiw', 'role');
    const sourceRoleDir = path.join(__dirname, '..', 'resources', lang, 'roles');

    // Check and create source directory if not exists
    const sourceDirExists = fs.existsSync(sourceRoleDir);
    if (!sourceDirExists) {
      await fs.ensureDir(sourceRoleDir);
      spinner.warn(`Source role directory not found, created: ${sourceRoleDir}`);
    }

    // Get role files from source
    const roleFiles = await fs.readdir(sourceRoleDir);
    const filteredFiles = roleFiles.filter(f => f.endsWith('.md'));

    if (filteredFiles.length === 0) {
      spinner.warn('No role files found in source directory');
      return;
    }

    // Check target directory status (before creating it)
    const targetDirExists = fs.existsSync(aiwRoleDir);
    let existingFiles = [];

    // Ensure aiw role directory exists (create if not)
    await fs.ensureDir(aiwRoleDir);

    // If target directory existed before, check for conflicting files
    if (targetDirExists) {
      for (const file of filteredFiles) {
        const targetPath = path.join(aiwRoleDir, file);
        if (fs.existsSync(targetPath)) {
          existingFiles.push(file);
        }
      }
    }

    // Skip if existing files and not forced
    if (existingFiles.length > 0 && !force) {
      spinner.info(`Found ${existingFiles.length} existing role files in aiw (skipped)`);
      spinner.info('Use --force to overwrite\n');
      return;
    }

    // Copy files
    for (const file of filteredFiles) {
      const srcPath = path.join(sourceRoleDir, file);
      const destPath = path.join(aiwRoleDir, file);
      await fs.copy(srcPath, destPath, { overwrite: true });
    }

    spinner.succeed(`Copied ${filteredFiles.length} role files to aiw\n`);
  } catch (error) {
    spinner.warn('Failed to copy role files (continuing anyway)');
    console.error(chalk.gray(error.message));
  }
}

/**
 * Install aiw
 */
async function installAIW(lang) {
  const spinner = ora('Installing aiw...').start();

  try {
    execSync('npm install -g @putao520/aiw', { stdio: 'pipe' });
    spinner.succeed('aiw installed successfully');

    // Copy role files after installation
    await copyRoles(lang);
  } catch (error) {
    spinner.fail('aiw installation failed');
    console.error(chalk.red('Error:'), error.message);
    console.log(chalk.yellow('\nPlease install manually:'));
    console.log('  npm install -g @putao520/aiw\n');
    process.exit(1);
  }
}

// CLI argument handling when run directly
if (require.main === module) {
  const command = process.argv[2];

  (async () => {
    try {
      if (command === 'install') {
        await install();
      } else if (command === 'uninstall') {
        await uninstall();
      } else if (command === 'update') {
        await update();
      } else if (command === 'status') {
        await status();
      } else {
        console.log('Usage: node installer.js [install|uninstall|update|status]');
        process.exit(1);
      }
    } catch (error) {
      console.error('Error:', error.message);
      process.exit(1);
    }
  })();
}

module.exports = {
  install,
  uninstall,
  update,
  status
};
