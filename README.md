# CC-SPEC-Lite

> **A re-entrant SPEC execution loop for AI-assisted development.**  
> Each `/spec` invocation runs a full cycle: **Requirement → Implementation → Audit**.

---

## ⚡ What is CC-SPEC-Lite?

cc-spec-lite is NOT another documentation framework or a linear "spec-first" template. It is a **closed-loop execution engine** designed for Claude Code and other agentic AI CLIs.

It transforms AI development from "vibe-driven" prompting into a **deterministic, re-entrant loop** where the Specification (SPEC) acts as the state machine's source of truth.

### The Atomic Unit: `/spec`
Unlike tools that treat specification as a "phase" (Spec → Plan → Code), cc-spec-lite treats `/spec` as an **indivisible execution unit**. 

When you run `/spec`, the system:
1.  **Clarifies**: Proactively interviews you to refine the requirement.
2.  **Architects**: Updates the SSOT (SPEC files) to match the new state.
3.  **Implements**: Automatically triggers specialized agents to write the code.
4.  **Audits**: Runs a final verification to ensure the code matches the SPEC.

---

## 🚀 Key Capabilities

*   **🔄 Re-entrant Execution**: Run `/spec` at any time, in any order. Whether you are adding a feature, refactoring, or fixing a bug, the loop always converges on the SPEC.
*   **💂 Agentic Guardrails**: Orchestrates specialized roles (**Architect** vs. **Programmer**). The Architect designs the "What", and the Programmer executes the "How," preventing implementation drift.
*   **⚖️ Audit-Centric**: Consistency is enforced by the system, not the user's memory. The final audit ensures no "TODOs" or "stubs" remain.
*   **⚙️ Multi-Provider Fallback**: Built-in priority management (`codex`, `gemini`, `claude`) with automatic fallbacks ensures your execution loop never breaks due to API limits.

---

## 🛠 Quick Start

### 1. Install
```bash
npm install -g @putao520/cc-spec-lite
```

### 2. Initialize
```bash
/spec-init
```

### 3. Execute
```bash
/spec "Implement a user login with JWT fallback"
```

### 4. Align & Audit
```bash
/spec-audit
```
The final guardrail to ensure implementation 100% matches the architecture. If discrepancies are found, the loop re-triggers to fix them automatically.

---

## 🧩 How It Differs

| Feature | Stage-Based (Spec-Kit/OpenSpec) | Loop-Based (CC-SPEC-Lite) |
| :--- | :--- | :--- |
| **Logic** | Linear (Step A → Step B) | **Re-entrant (Atomic Loop)** |
| **Enforcement** | Human-checked documentation | **System-level Audit guardrails** |
| **Philosophy** | Change Management (Deltas) | **State Machine (SSOT Convergence)** |
| **AI Role** | Documentation assistant | **Execution Engine** |

---

## ⚙️ AI CLI Priority Management

CC-SPEC-Lite sits on top of a robust runner that manages multiple AI agents. Configure your preferred order in `~/.claude/config/aiw-priority.yaml`:

```yaml
priority:
  - cli: codex
    provider: auto
  - cli: gemini
    provider: official
  - cli: claude
    provider: glm
```

The system automatically falls back to the next provider if the primary one fails, ensuring high availability for your development loop.

---

## 📜 Requirements

- **Node.js** >= 14
- **Claude Code** (or compatible Agentic AI CLI)
- **Git**

---

## 🤝 Contributing

Contributions are welcome. Please ensure all PRs follow the **SPEC-driven** workflow: 
1. Update SPEC → 2. Implement → 3. Audit.

---

## ⚖️ License

MIT License.

---
**Version**: 0.3.0  
**Author**: putao520 <yuyao1022@hotmail.com>
