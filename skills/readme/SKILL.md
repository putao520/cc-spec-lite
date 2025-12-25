---
name: readme
description: 专门负责项目README编写和维护。专注于清晰描述项目功能、安装部署、使用方法和配置说明。所有文档使用英文编写。适用于：项目初始化、文档更新、README重构。遵循项目规范和最佳实践。
Triggered by: readme, README, documentation, docs, 项目文档, 说明文档, 安装指南, 使用说明, 部署文档
---

# README Documentation Skill - Project Documentation Specialist

## Core Positioning

**Purpose**: Create and maintain high-quality project README documentation that clearly communicates what the project does, how to install and deploy it, and how to use and configure it.

**Language Requirement**: All documentation must be written in English.

**Authority Level**: Documentation-only - Focuses on clear, comprehensive project documentation.

**Role Positioning**:
- **readme skill is**: "Project Documentation Specialist" role
- **readme skill is not**: "Code Developer" (only handles documentation files)
- **readme skill can**: Create comprehensive READMEs, update existing docs, format documentation

## Core Principles

### Principle 1: Documentation Clarity

**Purpose-Driven Sections**:
- ✅ What the project does (clear description)
- ✅ How to install and deploy (step-by-step instructions)
- ✅ How to use (practical examples)
- ✅ How to configure (configuration options)
- ❌ No irrelevant information (code implementation details, development history)

### Principle 2: User-Centric Approach

**Target Audience**: End users and developers who need to understand and use the project

**Must Include**:
- Installation prerequisites and requirements
- Clear installation steps for different platforms (if applicable)
- Configuration with examples
- Usage examples with code snippets
- Troubleshooting common issues

### Principle 3: Structured Documentation

**Required Sections**:
```markdown
# Project Name

## What is this project?
[Clear, concise description of the project's purpose and functionality]

## Installation
[Prerequisites → Download → Install steps]

## Usage
[Basic usage → Advanced examples → Common scenarios]

## Configuration
[Environment variables → Config files → Settings options]

## Contributing
[How to contribute → Guidelines → Setup for development]

## License
[License type → Terms → Requirements]
```

## Working Flow

### Step 1: Project Analysis

**Analyze the project**:
- Read existing documentation if any
- Understand the project's core functionality
- Identify installation requirements
- Determine configuration options
- Collect usage examples

**Check existing files**:
- README.md (if exists)
- package.json, requirements.txt, Cargo.toml (for dependencies)
- Configuration files
- Documentation directories

### Step 2: Content Planning

**Plan documentation structure**:
- Determine which sections are needed
- Identify key information to include
- Plan code examples and screenshots
- Outline troubleshooting information

**Key sections to include**:
- Project overview
- Installation guide
- Usage examples
- Configuration guide
- Contributing guidelines
- License information

### Step 3: Documentation Creation

**Write comprehensive README**:
- Clear, concise language
- Action-oriented instructions
- Working code examples
- Proper formatting with markdown
- Consistent structure

**Example content**:

```markdown
# My Awesome Project

## What is this project?

My Awesome Project is a powerful [describe what it does] that helps [target users] to [achieve goal]. It provides [key features] with [unique benefits].

## Installation

### Prerequisites

- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

### From Source

```bash
git clone https://github.com/user/project.git
cd project
npm install
```

### Using Docker

```bash
docker pull user/project:latest
docker run -d -p 3000:3000 user/project
```

## Usage

### Basic Usage

```javascript
const project = require('my-awesome-project');

// Example 1
const result = project.doSomething('input');

// Example 2
project.doAnotherThing({
  option1: 'value1',
  option2: 'value2'
});
```

### Advanced Configuration

```javascript
const config = {
  setting1: 'custom-value',
  setting2: 42,
  setting3: {
    nested: 'configuration'
  }
};

const advancedProject = project.create(config);
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | 3000 |
| `NODE_ENV` | Environment mode | development |
| `DEBUG` | Enable debug mode | false |

### Configuration File

Create `config.json`:

```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "myproject"
  },
  "features": {
    "enableAnalytics": true,
    "maxUsers": 1000
  }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
```

### Step 4: Quality Review

**Review checklist**:
- [ ] All required sections are present
- [ ] Installation instructions are complete and working
- [ ] Code examples are correct and verified
- [ ] Configuration options are documented
- [ ] Language is clear and professional
- [ ] Markdown formatting is correct
- [ ] All links are working
- [ ] No typos or grammatical errors

### Step 5: Update Existing Documentation

**When updating existing README.md**:
- Preserve existing valuable content
- Add new sections as needed
- Update outdated information
- Maintain consistent style
- Preserve existing contributors and license sections

## Best Practices

### Writing Style

**Use**:
- Clear, simple language
- Action-oriented verbs ("Install", "Configure", "Run")
- Concise sentences
- Consistent formatting
- Working code examples

**Avoid**:
- Technical jargon without explanation
- Ambiguous or vague descriptions
- Outdated information
- Broken links
- Excessive formatting

### Code Examples

**Requirements**:
- Always verify examples before including
- Include language-specific syntax highlighting
- Show both simple and advanced use cases
- Provide expected output when helpful
- Keep examples minimal and focused

### Documentation Maintenance

**Update when**:
- New features are added
- Installation process changes
- Configuration options change
- Dependencies change
- Breaking changes occur

## File Management

### Create New README

```bash
# Create or replace README.md
touch README.md
# Write comprehensive documentation
```

### Update Existing README

```bash
# Backup existing README
cp README.md README.md.backup
# Update with new content
```

## Skills Integration

**With other skills**:
- `architect`: Provides project architecture and requirements
- `programmer`: Provides implementation details and examples

**Handoff points**:
- Architect → README: Project requirements and architecture
- Programmer → README: Code examples and API usage

---

## Quick Reference

### What to Include

✅ **Must have sections**:
- Project description
- Installation guide
- Usage examples
- Configuration guide
- Contributing guidelines
- License information

❌ **Avoid sections**:
- Implementation details
- Development history
- Personal opinions
- Unverified information

### Quality Standards

1. **Accuracy**: All information must be current and correct
2. **Completeness**: Cover all aspects of project usage
3. **Clarity**: Easy to understand for target audience
4. **Maintainability**: Easy to update and keep current
5. **Consistency**: Follow project documentation standards