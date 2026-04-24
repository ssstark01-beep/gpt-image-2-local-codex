# GPT Image 2 Local Codex Skill

## 中文

通过本地 `codex` 调用 **GPT Image 2** 的 Hermes skill。

### 适用场景
- 文生图
- 图生图
- 多参考生成
- Docker / hermes-agent / 直接安装环境

### 依赖
- `codex`
- `python3`
- 已开通 ChatGPT 图像生成权限
- 本地 Codex session

### 当前环境
在当前 Docker / hermes-agent 环境中使用：
```bash
HOME=/opt/data
CODEX_HOME=/opt/data/.codex
```
验证登录：
```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

### 工作流
1. 读取需求
2. 默认给出 3 个场景方向
3. 用六维生图法组织提示词
4. 先确认方案
5. 确认后再生成

### 六维生图法
1. Subject
2. Scene / composition
3. Style / medium
4. Color / lighting
5. Details / labels
6. Output constraints

## English

Hermes skill for calling **GPT Image 2** through local `codex`.

### Use cases
- Text-to-image
- Image-to-image
- Multi-reference generation
- Docker / hermes-agent / direct installs

### Dependencies
- `codex`
- `python3`
- ChatGPT image-generation access
- Local Codex session store

### Current environment
Use:
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

### Workflow
1. Read the request
2. Offer 3 scenario directions
3. Build the prompt with the six-dimensional image method
4. Ask for confirmation
5. Generate only after confirmation

### Six-dimensional image method
1. Subject
2. Scene / composition
3. Style / medium
4. Color / lighting
5. Details / labels
6. Output constraints
