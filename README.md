# GPT Image 2 Local Codex Skill

A small Hermes skill for generating images with **GPT Image 2** through local Codex.

## What it does

- Uses the user's ChatGPT image-generation access
- Runs local `codex` for text-to-image and image-to-image
- Works in Docker / hermes-agent
- Also works with direct non-Docker install
- Keeps English docs in `SKILL.md` and Chinese docs in `skill_zh.md`

## Quick start

### Environment

For the current Docker / hermes-agent setup, use:

```bash
HOME=/opt/data
CODEX_HOME=/opt/data/.codex
```

Verify auth with:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

Do not rely on a bare `codex login status` here.

### Non-Docker

Use the machine's real Codex home. Do not assume `/opt/data/.codex` unless that is the actual session location.

## Workflow

1. Read the request
2. Offer 3 scenario-based directions
3. Build the prompt with the six-dimensional image method
4. Ask for confirmation
5. Generate only after confirmation

## Six dimensions

1. Subject
2. Scene / composition
3. Style / medium
4. Color / lighting
5. Details / labels
6. Output constraints

## Repository structure

```text
.
├── README.md
├── SKILL.md
└── skill_zh.md
```
