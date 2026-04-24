# GPT Image 2 本地 Codex 生图技能

## 适用场景

当用户明确要求使用 **GPT Image 2 / ChatGPT Images 2.0**，并希望通过本地 `codex` CLI 生成图片时使用本技能。

适用请求包括：
- 使用 GPT Image 2
- 使用 gpt-image-2
- 使用 ChatGPT Images 2.0
- 图生图、参考图编辑、多参考融合
- 走本地 Codex 路线而不是其它图片模型

## 前置条件

- `codex` 已安装并可在 PATH 中找到
- `python3` 已安装
- 用户账号已具备 ChatGPT 图像生成权限
- Codex 会话目录已持久化，通常位于 `~/.codex/sessions` 或 `/opt/data/.codex/sessions`

## Docker / hermes-agent 快速安装

在 Dockerized 的 `hermes-agent` 环境里，建议把本技能挂载或复制到 agent 的技能目录，同时确保容器能访问 Codex 的登录态和 session 目录。

最小检查步骤：

1. 把 skill 安装到 Hermes Agent 的技能路径中。
2. 如果已经有登录态，就把 Codex home 目录挂载进去。
3. 在容器内确认登录状态。
4. 用户确认方案后再执行生成。

示例运行方式：

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

如果返回已登录，再执行生成：

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
bash scripts/gen.sh --prompt "<原始提示词>" --out /absolute/path/output.png
```

## 默认交互流程

在真正生成图片之前，默认先做下面几步：

1. 理解用户需求。
2. 默认给出 **3 个基于场景的方向**。
3. 依据 **六维生图法** 组织提示词。
4. 先让用户确认方案，再正式生成。
5. 只有在用户明确选择或同意后才执行生成。

如果用户已经给得非常明确，也可以直接生成，但默认仍然优先给 3 个方向。

## 三方向默认模板

方向要基于用户的**使用场景**来选，而不是只给抽象风格词。

常见场景：
- **社交媒体**：吸睛封面 / 信息清晰 / 传播感强
- **GitHub / 文档**：易读 / 结构化 / 实用导向
- **产品介绍图**：卖点突出 / 画面高级 / 品牌感强
- **教育科普图**：解释清楚 / 分层表达 / 易于学习
- **技术架构图**：模块化 / 流程化 / 组件关系清楚
- **对比分析图**：左右对比 / 多维矩阵 / 结论导向
- **活动海报**：氛围浓 / 视觉冲击强 / 主题突出
- **卡片列表图**：条目统一 / 方便扫读 / 文案精炼

技术类示例三方向：
- **结构清晰版**
- **教学解释版**
- **视觉冲击版**

## 六维生图法

用一个简洁但具体的提示词骨架，包含六个维度：

1. **Subject（主体）**：画什么，核心对象是什么
2. **Scene / composition（场景 / 构图）**：怎么布局，怎么分区，中心/分栏/流程/卡片式等
3. **Style / medium（风格 / 媒介）**：扁平信息图、卡通、编辑海报、技术示意图、社交媒体海报等
4. **Color / lighting（颜色 / 光线）**：配色、氛围、渐变、阴影、发光、明暗对比
5. **Details / labels（细节 / 标注）**：标题、副标题、箭头、编号、注释、图标、强调词
6. **Output constraints（输出约束）**：比例、语言、可读性、负面约束、不要什么

提示词要短，但要具体。根据场景调整重点：
- 社交媒体图：更强调颜色和构图
- GitHub / 文档图：更强调可读性和结构
- 产品图：更强调精致度、层次和品牌感

## 预览格式

在让用户确认时，按下面这个结构展示：

- **方向**：A / B / C
- **适用场景**：社交媒体 / 文档 / 科普 / 产品 / 海报 / 对比图
- **六维提示词**：
  - Subject: ...
  - Scene: ...
  - Style: ...
  - Color: ...
  - Details: ...
  - Constraints: ...
- **最终用途**：海报 / 信息图 / 教学插画 / 社媒配图 / 其他

然后只问一句：

> 你想用哪一个方向？我确认后再生成。

## GitHub 发布模式

如果用户要发布到 GitHub，或要写项目说明、架构说明、生图流程说明，回复里默认给 **中文 + 英文两部分**：

- 项目简介 / Project Overview
- 架构概览 / Architecture Overview
- 核心组件 / Core Components
- 生图流程 / Image Generation Workflow
- 技术要点 / Technical Highlights
- 可复制的 README 文案 / Copy-ready README text

## 生成流程

用户确认后，使用脚本生成：

```bash
bash scripts/gen.sh \
  --prompt "<原始提示词>" \
  --out /absolute/path/output.png
```

如果是图生图或多参考：

```bash
bash scripts/gen.sh \
  --prompt "<原始提示词>" \
  --ref /abs/ref1.png \
  --ref /abs/ref2.png \
  --out /absolute/path/output.png
```

## 常见问题

- `codex: command not found`：说明 CLI 没装好或不在 PATH 中。
- `codex login status -> Not logged in`：说明当前没有登录态。
- `401 Unauthorized`：通常是登录态失效或未授权。
- 如果浏览器登录被拦截，就建议用户在本机完成登录，而不是假定远程会话能继续。
- 如果 `image_generation` 被禁用，可能会跑完但拿不到图像 payload。

## 校验

生成成功后：

- 确认输出文件真实存在且是有效图片
- 如果脚本只打印了路径，也要再检查文件本身
- 最好直接交付图片文件，而不是只给路径

## 失败处理

失败时简短说明是哪一层出问题：

- CLI 缺失
- 未登录
- 登录过期
- feature flag 不可用
- 没提取到 image payload
- 参考图缺失

不要直接堆很长的 stderr，除非用户要求排错。
