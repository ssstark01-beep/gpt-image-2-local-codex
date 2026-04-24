---
name: gpt-image-2-local-codex
description: Generate GPT Image 2 images through the local Codex CLI, with Docker/hermes-agent setup notes, concise prompt-confirmation workflow, and ChatGPT session handling.
---

# GPT Image 2 via Local Codex

Use this skill when the user explicitly wants GPT Image 2 / ChatGPT Images 2.0 generated through the local `codex` CLI.

## When to use

- The user says: `use GPT Image 2`, `gpt-image-2`, `ChatGPT Images 2.0`, or `image 2`
- The user wants image-to-image editing or multi-reference composition
- The user wants the local Codex-based workflow instead of another image model

## Prerequisites

- `codex` installed and on PATH
- `python3` installed and on PATH
- A logged-in ChatGPT account with image-generation entitlement
- A persisted Codex session store, typically at `~/.codex/sessions` or `/opt/data/.codex/sessions`

## Docker / hermes-agent quick install

In a Dockerized `hermes-agent` environment, mount or copy this skill into the agent's skill directory, then make sure the container can reach the Codex auth/session directory.

Minimal checklist:

1. Install the skill into the Hermes Agent skills path.
2. Mount the Codex home directory if credentials already exist.
3. Verify login inside the container.
4. Run the generation helper after user confirmation.

Example runtime setup:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

If that returns logged in, generate images with:

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
bash scripts/gen.sh --prompt "<raw prompt>" --out /absolute/path/output.png
```

## Default interaction pattern

Before generating any image:

1. Interpret the user's request.
2. Propose **three scenario-based directions** by default.
3. Convert the chosen direction into a prompt using the **six-dimensional image method**.
4. Ask the user to confirm the方案 before running generation.
5. Only generate after the user explicitly chooses or approves a direction.

If the user already gave a very specific direction and wants to skip choices, you may proceed directly, but the default behavior is still to present three directions first.

## Three-direction default template

Choose the three directions based on the user's scenario, not just abstract style words.

Common scene sets:

- **Social media**: catchy cover / clear message / high shareability
- **GitHub or docs**: readable / structured / utility-oriented
- **Product intro**: benefit-led / polished / brand-forward
- **Educational**: explanatory / layered / easy to learn
- **Technical architecture**: modular / flow-based / component clarity
- **Comparison chart**: side-by-side / matrix / conclusion-driven
- **Poster / event**: strong mood / visual punch / attention-grabbing
- **Card grid**: consistent items / scan-friendly / compact copy

Example technical trio:

- **Clear structure version**
- **Teaching/explainer version**
- **High-impact visual version**

## Six-dimensional image method

Use a compact prompt skeleton with these six dimensions:

1. **Subject** — what is being drawn
2. **Scene / composition** — how the image is laid out
3. **Style / medium** — what the image looks like visually
4. **Color / lighting** — palette, mood, contrast, gradients, glow
5. **Details / labels** — titles, annotations, icons, arrows, step labels
6. **Output constraints** — aspect ratio, language, readability, negative constraints

Keep each dimension short but concrete. Adapt emphasis to the use case:

- Social media: stronger color and composition
- GitHub/docs: stronger readability and structure
- Product graphics: stronger polish and hierarchy

## Prompt preview format

When asking for confirmation, show a compact preview like this:

- **Direction**: A / B / C
- **Use case**: social / docs / educational / product / poster / comparison
- **Six-dimension prompt**:
  - Subject: ...
  - Scene: ...
  - Style: ...
  - Color: ...
  - Details: ...
  - Constraints: ...
- **Final output**: poster / infographic / tutorial / social image / other

Then ask a single confirmation question:

> Which direction do you want? I will generate after you confirm.

## GitHub publishing mode

If the user asks to publish or document the project for GitHub, provide both Chinese and English sections in the response:

- Project overview
- Architecture overview
- Core components
- Image generation workflow
- Technical highlights
- Copy-ready README text

## Generation flow

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

- `codex: command not found` means the CLI is missing or not on PATH.
- `codex login status -> Not logged in` means the session is not authenticated yet.
- `401 Unauthorized` during `codex exec` usually means the ChatGPT/Codex auth is missing or expired.
- If browser-based auth is blocked, finish login locally on the machine instead of assuming the session can complete it.
- If `image_generation` is disabled, the session may run but never produce an image payload.

## Verification

After a successful run:

- Confirm the output file exists and is a valid image
- If the script prints a path, still verify the file on disk
- Prefer to attach or show the generated image, not just report success

## Failure handling

When something fails, name the broken layer briefly:

- CLI missing
- not logged in
- auth expired
- feature flag unavailable
- no image payload extracted
- reference file missing

Avoid dumping long raw stderr unless the user asks for diagnostics.
