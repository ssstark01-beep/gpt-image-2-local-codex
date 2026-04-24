---
name: gpt-image-2-local-codex
description: Use the local Codex CLI to generate GPT Image 2 images from a ChatGPT Plus/Pro session, with concise Docker/hermes-agent installation and usage guidance, text-to-image and image-to-image workflows, session extraction, local credential directories such as /opt/data/.codex, and common login pitfalls.
---

# GPT Image 2 via local Codex

Use this skill when the user explicitly wants GPT Image 2 / ChatGPT Images 2.0 generated through the local `codex` CLI.

## Docker / hermes-agent quick install

In a Dockerized `hermes-agent` setup, mount or copy this skill into the agent's skill directory, then make sure the container can reach the Codex auth/session directory.

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

## When to use

- User says: "use GPT Image 2", "gpt-image-2", "ChatGPT Images 2.0", "image 2"
- User wants image-to-image editing or multi-reference composition through their ChatGPT subscription
- User asks to generate an image and specifically wants the local Codex route

## What this workflow depends on

- `codex` installed and on PATH
- `python3` installed and on PATH
- A logged-in ChatGPT account with image-generation entitlement
- A persisted Codex session store. In this environment it may live at `~/.codex/sessions` or `/opt/data/.codex/sessions`

## Default interaction pattern

Before generating any image, do all of the following:

1. Interpret the user's request.
2. Propose **three possible creative directions** by default.
   - Example: conservative / balanced / expressive
   - Keep them short and clearly distinct
3. Convert the chosen direction into a prompt using the **six-dimensional image method**.
4. Ask the user to confirm the方案 before running Codex generation.
5. Only generate after the user explicitly chooses or approves a direction.

If the user has already given an extremely specific direction and asks to skip choices, you may proceed directly, but the default behavior is still to present three directions first.

## Default interaction pattern

Before generating any image, do all of the following:

1. Interpret the user's request.
2. Propose **three possible creative directions** by default.
   - Example: conservative / balanced / expressive
   - Keep them short and clearly distinct
3. Convert the chosen direction into a prompt using the **six-dimensional image method**.
4. Ask the user to confirm the方案 before running Codex generation.
5. Only generate after the user explicitly chooses or approves a direction.

If the user has already given an extremely specific direction and asks to skip choices, you may proceed directly, but the default behavior is still to present three directions first.

## GitHub publishing mode

If the user asks to publish, document, or describe the project for GitHub, produce the content in **two parts**:

1. **中文部分** — suitable for a README, project intro, or architecture section in Chinese
2. **English part** — a clean English counterpart for international readers

Default structure for such outputs:

- 项目简介 / Project Overview
- 架构概览 / Architecture Overview
- 核心组件 / Core Components
- 生图流程 / Image Generation Workflow
- 技术要点 / Technical Highlights
- 可复制的 README 文案 / Copy-ready README text

Keep terminology aligned across both languages. If the Chinese version uses a project-specific name, mirror it in English rather than translating it loosely.

## Three-direction default template

When the user gives a topic but no strong style constraints, present the options in this shape:

- **A. 稳妥版**：信息清晰、结构标准、适合说明型/科普型图像
- **B. 平衡版**：在清晰表达和视觉吸引力之间折中，默认优先
- **C. 创意版**：更夸张、更有记忆点、更强风格化

Adjust the wording to the topic. For example, for technical content, the three directions can become:

- **结构清晰版**
- **教学解释版**
- **视觉冲击版**

## Six-dimensional image method

Build the prompt from these six dimensions:

1. **Subject** — what is being drawn
2. **Scene / composition** — layout, framing, visual structure
3. **Style / medium** — cartoon, flat design, watercolor, infographic, etc.
4. **Color / lighting** — palette, contrast, atmosphere
5. **Details / labels** — text, annotations, icons, emphasis points
6. **Output constraints** — aspect ratio, quality, exclusions, negative prompt

When writing prompts, keep each dimension explicit and concise. If a dimension is not specified by the user, choose a sensible default and mark it as an assumption in the preview.

## Prompt preview format

When asking for confirmation, show the user a compact preview like this:

- **方向**：A / B / C 之一
- **六维提示词**：
  - Subject: ...
  - Scene: ...
  - Style: ...
  - Color: ...
  - Details: ...
  - Constraints: ...
- **最终用途**：海报 / 信息图 / 教学插画 / 社媒配图 / 其他

Then ask a single confirmation question such as:

> 你想用哪一个方向？我确认后再生成。

## Six-dimension prompt writing style

Prefer prompts that are:

- concrete instead of abstract
- concise instead of verbose
- explicit about layout and labels
- clear about what must not appear

Example pattern:

```text
Subject: ...
Scene: ...
Style: ...
Color: ...
Details: ...
Constraints: ...
```

You can then pass the combined prompt to GPT Image 2 after confirmation.

When the user gives a topic but no strong style constraints, present the options in this shape:

- **A. 稳妥版**：信息清晰、结构标准、适合说明型/科普型图像
- **B. 平衡版**：在清晰表达和视觉吸引力之间折中，默认优先
- **C. 创意版**：更夸张、更有记忆点、更强风格化

Adjust the wording to the topic. For example, for technical content, the three directions can become:

- **结构清晰版**
- **教学解释版**
- **视觉冲击版**

## Six-dimensional image method

Build the prompt from these six dimensions:

1. **Subject** — what is being drawn
2. **Scene / composition** — layout, framing, visual structure
3. **Style / medium** — cartoon, flat design, watercolor, infographic, etc.
4. **Color / lighting** — palette, contrast, atmosphere
5. **Details / labels** — text, annotations, icons, emphasis points
6. **Output constraints** — aspect ratio, quality, exclusions, negative prompt

When writing prompts, keep each dimension explicit and concise. If a dimension is not specified by the user, choose a sensible default and mark it as an assumption in the preview.

## Prompt preview format

When asking for confirmation, show the user a compact preview like this:

- **方向**：A / B / C 之一
- **六维提示词**：
  - Subject: ...
  - Scene: ...
  - Style: ...
  - Color: ...
  - Details: ...
  - Constraints: ...
- **最终用途**：海报 / 信息图 / 教学插画 / 社媒配图 / 其他

Then ask a single confirmation question such as:

> 你想用哪一个方向？我确认后再生成。

## Six-dimension prompt writing style

Prefer prompts that are:

- concrete instead of abstract
- concise instead of verbose
- explicit about layout and labels
- clear about what must not appear

Example pattern:

```text
Subject: ...
Scene: ...
Style: ...
Color: ...
Details: ...
Constraints: ...
```

You can then pass the combined prompt to GPT Image 2 after confirmation.

## Important implementation details

- Pass the user's prompt through raw unless they explicitly ask for rewriting or style changes.
- Default output path can be something like `./image-<YYYYMMDD-HHMMSS>.png` if the user does not specify one.
- Do not use `--ephemeral`; the image payload is usually recovered from persisted session rollout files.
- The generation flow typically needs `--enable image_generation`.
- The output is often extracted from new files under the Codex session directory after the run.

## Local credential path handling

If the environment stores Codex auth under `/opt/data/.codex`, align the runtime paths before invoking Codex:

```bash
HOME=/opt/data CODEX_HOME=/opt/data/.codex codex login status
```

If that reports logged in, use the same `HOME` and `CODEX_HOME` values for generation:

```bash
HOME=/opt/data CODEX_HOME=/opt/data/.codex bash scripts/gen.sh \
  --prompt "<raw prompt>" \
  --out /absolute/path/output.png
```

This avoids stale or missing session paths from the default home directory.

## Common pitfalls

- `codex: command not found` means the CLI is missing or not on PATH.
- `codex login status -> Not logged in` means the session is not authenticated yet.
- `401 Unauthorized` during `codex exec` usually means the ChatGPT/Codex auth is missing or expired.
- Device-code login (`codex login --device-auth`) may open a browser flow that can be blocked by bot protection in some environments.
- If browser-based auth is blocked, tell the user to complete login locally on their machine rather than assuming the session can finish it.
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
