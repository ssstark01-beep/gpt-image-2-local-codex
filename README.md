# GPT Image 2 Local Codex Skill

A compact Hermes skill for generating images with **GPT Image 2** through the local `codex` CLI.

## What this repo does

- Uses the user's existing ChatGPT image-generation entitlement
- Runs the local `codex` workflow for text-to-image and image-to-image
- Supports Docker / hermes-agent setups
- Stores the English skill in `SKILL.md`
- Stores the Chinese companion document in `skill_zh.md`

## Quick start

### 1. Prerequisites

- `codex` installed
- `python3` installed
- A ChatGPT account with image-generation access
- Codex session files available locally, usually under one of these paths:
  - `~/.codex/sessions`
  - `/opt/data/.codex/sessions`

### 2. Docker / hermes-agent setup

If you run Hermes Agent inside Docker, mount the Codex home directory into the container and make sure the skill folder is available to the agent.

Example:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

If the output says the user is logged in, you can generate images:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
bash scripts/gen.sh --prompt "<raw prompt>" --out /absolute/path/output.png
```

## Workflow

1. Read the user request.
2. Present 3 scenario-based directions by default.
3. Convert the selected direction into a prompt with the six-dimensional image method.
4. Ask the user to confirm the plan.
5. Generate only after confirmation.

## Six-dimensional image method

The prompt is organized around:

1. Subject
2. Scene / composition
3. Style / medium
4. Color / lighting
5. Details / labels
6. Output constraints

This helps keep prompts short, concrete, and easy to confirm.

## Repository structure

```text
.
├── README.md
├── SKILL.md
└── skill_zh.md
```

## Notes

- `SKILL.md` is the primary skill file for Hermes.
- `skill_zh.md` is the Chinese companion document.
- The prompt workflow is designed for social media graphics, documentation images, infographics, and product-style visuals.

## Publishing

If you want to publish this skill to GitHub, commit these files and push the repository as usual.
