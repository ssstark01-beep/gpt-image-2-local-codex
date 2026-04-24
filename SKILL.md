---
name: gpt-image-2-local-codex
description: Generate GPT Image 2 images through local Codex, with concise setup notes for Docker or direct install, scenario-based prompt choices, and safe auth checks.
---

# GPT Image 2 via Local Codex

Use this skill when the user wants GPT Image 2 / ChatGPT Images 2.0 through the local `codex` CLI.

## Prerequisites

- `codex` on PATH
- `python3` on PATH
- ChatGPT account with image-generation access
- A local Codex session store

### Environment rule

For the current Docker/hermes-agent setup, use:

```bash
HOME=/opt/data
CODEX_HOME=/opt/data/.codex
```

Do not treat a bare `codex login status` as authoritative in this environment. Verify auth with:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

Only call the session unauthenticated if this command says so.

## Install / setup

### Docker / hermes-agent

Mount or copy this skill into the agent's skill directory, and make sure the container can access the Codex auth/session directory.

### Direct install (non-Docker)

Copy the skill into the local Hermes Agent skills directory and use the machine's real Codex home. Do not assume `/opt/data/.codex` unless that is the actual session location on that machine.

## Default workflow

1. Understand the request.
2. Offer **3 scenario-based directions**.
3. Turn the chosen direction into a prompt with the **six-dimensional image method**.
4. Ask for confirmation.
5. Generate only after the user agrees.

## Three-direction template

Choose the options based on the use case, not just abstract style words.

Common scenarios:
- Social media: catchy / clear / shareable
- GitHub / docs: readable / structured / practical
- Product image: polished / premium / branded
- Educational: explanatory / layered / easy to learn
- Technical diagram: modular / flow-based / clear relationships
- Comparison chart: side-by-side / matrix / conclusion-driven

Example technical trio:
- Clear structure
- Teaching/explainer
- High-impact visual

## Six-dimensional image method

Keep prompts short but concrete:

1. **Subject** — what is being drawn
2. **Scene / composition** — layout, framing, grouping
3. **Style / medium** — infographic, cartoon, poster, schematic, etc.
4. **Color / lighting** — palette, mood, gradients, glow, contrast
5. **Details / labels** — titles, arrows, notes, icons, numbered steps
6. **Output constraints** — ratio, language, readability, negative constraints

## Confirmation format

When asking the user to confirm, show:

- Direction: A / B / C
- Use case: social / docs / educational / product / poster / comparison
- Six-dimension prompt:
  - Subject
  - Scene
  - Style
  - Color
  - Details
  - Constraints
- Final output: poster / infographic / tutorial / social image / other

Then ask one question:

> Which direction do you want? I’ll generate after you confirm.

## GitHub publishing mode

If the user asks to publish or document the project for GitHub, provide both Chinese and English sections:

- Project overview
- Architecture overview
- Core components
- Image generation workflow
- Technical highlights
- Copy-ready README text

## Generation

Use the helper script after confirmation:

```bash
bash scripts/gen.sh \
  --prompt "<raw prompt>" \
  --out /absolute/path/output.png
```

For image-to-image or multi-reference input, repeat `--ref`:

```bash
bash scripts/gen.sh \
  --prompt "<raw prompt>" \
  --ref /abs/ref1.png \
  --ref /abs/ref2.png \
  --out /absolute/path/output.png
```

## Common pitfalls

- `codex: command not found` → CLI missing or not on PATH
- `codex login status -> Not logged in` → session not authenticated
- `401 Unauthorized` → auth expired or missing
- Bare `codex login status` can mislead in this environment
- Browser auth may be blocked; finish login locally if needed
- If `image_generation` is disabled, no image payload may be produced

## Verification

Before concluding auth is missing, run the env-aware login check above.
After generation, confirm the output file exists and is a valid image.
