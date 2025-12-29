/**
 * Configuration manager for AI CLI priority settings.
 */

const fs = require('fs-extra');
const os = require('os');
const path = require('path');

const CONFIG_FILE_NAME = 'aiw-priority.yaml';
const DEFAULT_PRIORITY = [
  { cli: 'codex', provider: 'auto' },
  { cli: 'gemini', provider: 'auto' },
  { cli: 'claude', provider: 'official' }
];

/**
 * Get user config file path.
 * @returns {string}
 */
function getUserConfigPath() {
  return path.join(os.homedir(), '.claude', 'config', CONFIG_FILE_NAME);
}

/**
 * Get providers file path.
 * @returns {string}
 */
function getProvidersPath() {
  return path.join(os.homedir(), '.aiw', 'providers.json');
}

/**
 * Clone default priority list.
 * @returns {Array<{cli: string, provider: string}>}
 */
function getDefaultPriority() {
  return DEFAULT_PRIORITY.map(entry => ({ ...entry }));
}

/**
 * Normalize provider list, ensuring "auto" is present and first.
 * @param {string[]} providerIds
 * @returns {string[]}
 */
function normalizeProviders(providerIds) {
  const ids = Array.isArray(providerIds) ? providerIds : [];
  const seen = new Set();
  const normalized = [];

  for (const id of ids) {
    if (!id || id === 'auto' || seen.has(id)) {
      continue;
    }
    seen.add(id);
    normalized.push(id);
  }

  return ['auto', ...normalized];
}

/**
 * Read available providers from ~/.aiw/providers.json.
 * @returns {Promise<{providers: string[], warning: string|null}>}
 */
async function getAvailableProviders() {
  const providersPath = getProvidersPath();

  if (!fs.existsSync(providersPath)) {
    return {
      providers: ['auto'],
      warning: `Providers file not found: ${providersPath}. Using auto only.`
    };
  }

  try {
    const data = await fs.readJSON(providersPath);
    const providersObject = data && typeof data.providers === 'object' ? data.providers : null;

    if (!providersObject) {
      return {
        providers: ['auto'],
        warning: 'Invalid providers.json format. Using auto only.'
      };
    }

    const providerIds = Object.keys(providersObject);
    return {
      providers: normalizeProviders(providerIds),
      warning: null
    };
  } catch (error) {
    return {
      providers: ['auto'],
      warning: `Failed to read providers.json: ${error.message}. Using auto only.`
    };
  }
}

/**
 * Build priority configuration with defaults and availability checks.
 * @param {string[]} cliOrder
 * @param {Record<string, string>} providerSelections
 * @param {string[]} availableProviders
 * @returns {Array<{cli: string, provider: string}>}
 */
function buildPriorityConfig(cliOrder, providerSelections, availableProviders) {
  const defaultPriority = getDefaultPriority();
  const defaultMap = defaultPriority.reduce((acc, entry) => {
    acc[entry.cli] = entry.provider;
    return acc;
  }, {});
  const order = Array.isArray(cliOrder) && cliOrder.length > 0
    ? cliOrder
    : defaultPriority.map(entry => entry.cli);
  const selections = providerSelections && typeof providerSelections === 'object'
    ? providerSelections
    : {};
  const providers = Array.isArray(availableProviders) && availableProviders.length > 0
    ? availableProviders
    : ['auto'];

  const ensuredProviders = providers.includes('auto') ? providers : ['auto', ...providers];

  return order.map(cli => {
    const requested = selections[cli] || defaultMap[cli] || 'auto';
    const provider = ensuredProviders.includes(requested) ? requested : 'auto';
    return { cli, provider };
  });
}

/**
 * Generate YAML configuration content.
 * @param {Array<{cli: string, provider: string}>} priorityEntries
 * @returns {string}
 */
function generateConfigYaml(priorityEntries) {
  if (!Array.isArray(priorityEntries) || priorityEntries.length === 0) {
    throw new Error('Priority configuration is empty.');
  }

  const lines = ['priority:'];

  for (const entry of priorityEntries) {
    if (!entry || !entry.cli || !entry.provider) {
      throw new Error('Priority configuration entry is invalid.');
    }
    lines.push(`  - cli: ${entry.cli}`);
    lines.push(`    provider: ${entry.provider}`);
  }

  return `${lines.join('\n')}\n`;
}

/**
 * Write user configuration file.
 * @param {string} configYaml
 * @returns {Promise<string>} Path to written config file.
 */
async function writeUserConfig(configYaml) {
  if (typeof configYaml !== 'string' || configYaml.trim().length === 0) {
    throw new Error('Config content is empty.');
  }

  const configPath = getUserConfigPath();
  await fs.ensureDir(path.dirname(configPath));
  await fs.writeFile(configPath, configYaml, 'utf8');
  return configPath;
}

module.exports = {
  buildPriorityConfig,
  generateConfigYaml,
  getAvailableProviders,
  getDefaultPriority,
  getUserConfigPath,
  writeUserConfig
};
