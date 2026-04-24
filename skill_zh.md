# GPT Image 2 本地 Codex 生图技能

## 用途

当用户明确要用 **GPT Image 2 / ChatGPT Images 2.0**，并希望通过本地 `codex` CLI 生成图片时使用本技能。

适用场景：
- 文生图
- 图生图
- 多参考融合
- 通过本地 Codex 走图像生成流程

## 前置条件

- `codex` 已安装并可在 PATH 中找到
- `python3` 已安装
- 用户账号已具备 ChatGPT 图像生成权限
- 本地有 Codex session 存储

### 当前环境规则

当前 Docker / hermes-agent 环境固定使用：

```bash
HOME=/opt/data
CODEX_HOME=/opt/data/.codex
```

在这个环境里，不要直接相信裸跑的 `codex login status`。必须用下面这个命令验证：

```bash
HOME=/opt/data \
CODEX_HOME=/opt/data/.codex \
codex login status
```

只有这条命令明确显示未登录时，才认为会话未认证。

## 安装方式

### Docker / hermes-agent

把 skill 放进 agent 的技能目录，并确保容器能访问 Codex 的 auth / session 目录。

### 非 Docker 直接安装

把 skill 放进本地 Hermes Agent 的技能目录，并使用**该机器真实的 Codex home**。不要默认写死 `/opt/data/.codex`，除非那台机器本来就是这个路径。

## 默认流程

1. 理解用户需求
2. 默认给出 **3 个基于场景的方向**
3. 用 **六维生图法** 组织提示词
4. 先让用户确认
5. 用户确认后再生成

## 三方向模板

方向要按场景来选，而不是只给抽象风格词。

常见场景：
- 社交媒体：吸睛 / 清晰 / 传播感强
- GitHub / 文档：易读 / 结构化 / 实用
- 产品图：高级 / 精致 / 品牌感强
- 教育科普：解释清楚 / 分层表达 / 易理解
- 技术图：模块化 / 流程化 / 关系清楚
- 对比图：左右对比 / 多维矩阵 / 结论明确

技术类示例三方向：
- 结构清晰版
- 教学解释版
- 视觉冲击版

## 六维生图法

1. **Subject（主体）**：画什么
2. **Scene / composition（构图）**：怎么排版、怎么分区
3. **Style / medium（风格）**：扁平信息图、卡通、海报、示意图等
4. **Color / lighting（颜色 / 光线）**：配色、氛围、渐变、发光、对比
5. **Details / labels（细节 / 标注）**：标题、箭头、编号、注释、图标
6. **Output constraints（输出约束）**：比例、语言、可读性、不要什么

## 确认格式

确认时按这个结构给用户看：

- 方向：A / B / C
- 适用场景：社交 / 文档 / 科普 / 产品 / 海报 / 对比图
- 六维提示词：
  - Subject
  - Scene
  - Style
  - Color
  - Details
  - Constraints
- 最终用途：海报 / 信息图 / 教学插画 / 社媒配图 / 其他

然后只问一句：

> 你想用哪一个方向？我确认后再生成。

## GitHub 发布模式

如果用户要发布到 GitHub，或者要写项目介绍 / 架构 / 生图流程，默认输出 **中文 + 英文两部分**：

- 项目简介 / Project Overview
- 架构概览 / Architecture Overview
- 核心组件 / Core Components
- 生图流程 / Image Generation Workflow
- 技术要点 / Technical Highlights
- 可复制的 README 文案 / Copy-ready README text

## 生成

确认后再执行：

```bash
bash scripts/gen.sh \
  --prompt "<原始提示词>" \
  --out /absolute/path/output.png
```

图生图 / 多参考：

```bash
bash scripts/gen.sh \
  --prompt "<原始提示词>" \
  --ref /abs/ref1.png \
  --ref /abs/ref2.png \
  --out /absolute/path/output.png
```

## 常见问题

- `codex: command not found`：CLI 没装好或不在 PATH 中
- `codex login status -> Not logged in`：当前没有登录态
- `401 Unauthorized`：登录态失效或未授权
- 裸跑 `codex login status` 在当前环境可能误判
- 浏览器登录被拦截时，建议用户在本机完成登录
- `image_generation` 被禁用时，可能拿不到图像 payload

## 校验

先用环境变量版本的登录检查，确认 auth 状态。
生成成功后，确认输出文件存在且是有效图片。
