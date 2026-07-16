# Codex 主题编辑器｜客户部署提示词

使用方法：把完整的 `Codex 主题编辑器.zip`、客户喜欢的主题图片（可选）和下面整段提示词，一起发送给客户自己的 macOS Codex。不要提前删除 ZIP 内的隐藏目录。

```text
你是我这台 Mac 上的 Codex 主题部署工程师。请直接完成部署、自检和实机验收，不要只给教程，也不要在没有验证证据时声称完成。

我随消息上传了“Codex 主题编辑器.zip”。如果还有图片附件，请把图片作为我的主题素材；如果没有图片，使用项目自带的示例主题。

最终目标：
- 为官方 macOS Codex Desktop 应用一套可持续使用、可更换素材、可验证、可一键恢复的主题；
- 页面右上角必须有可点击的“主题”入口，打开后能选择 20 款内置主题并一键即时切换；
- 主题中心最上方必须永久保留“系统默认 · 原生 Codex”，它不占 20 款内置名额；点击后应真正清除主题背景、横幅、附加任务卡和装饰 DOM，但右上角入口必须继续可用；
- 第 1 款必须是瑞克与莫蒂主题，第 2 款必须是火影忍者主题，第 3 款必须是蓝白高达轨道指挥中心；刷新、切换任务和重新启动后应保留上次选择；
- 20 款内置主题必须各自拥有对应且唯一的环境特效，例如浮光、火花、雷电碎屑、气泡、花瓣、霓虹雨、星际光迹、烟雾、极光、沙尘、雪、萤火、火星、蒸汽齿轮、彩纸、数字雨或流星；客户上传主题根据配色和布局自动匹配特效。素材原画必须保持固定，不得整体左右横移或缩放，不得使用视频，不得让整张界面晃动；
- 动态装饰必须 `pointer-events: none`，不得影响原生侧栏、卡片、项目选择器、输入框和正文；macOS 开启“减少动态效果”时必须自动静止；
- 主题中心必须可以直接上传 PNG、JPEG 或 WebP，在本机完成压缩和自动取色，允许选择六种布局并调整强调色、辅助色、面板色和文字色；上传主题保存到本机且可删除，不得覆盖 20 款内置主题；
- 20 款主题应使用电影横幅、沉浸任务板、控制台、轨道指挥中心、编辑画册和极简聚焦等不同布局家族，不能只是同一模板换图换色；火影忍者必须使用放大佐助、任务卡压住横幅底部的沉浸任务板布局；高达第 3 套必须使用独立的 `orbital-command` 布局、蓝金轨道指挥中心、全身机体横幅和宽屏横向 01–04 作战任务卡；
- 首页使用独立图片横幅；普通任务页让同一素材覆盖整个工作区，再通过左深右清的渐变遮罩保护正文，不能只在右侧显示半屏图片；
- 原生侧栏、项目选择器、任务内容、菜单和输入框必须保留真实 DOM 与交互；Codex 未提供原生建议卡时，主题应显示四张可点击的真实 DOM 任务卡并把任务写入原生输入框；
- 不得用整张界面截图覆盖原生 UI；
- 不得修改官方 `.app`、`app.asar`、代码签名或系统安全设置；
- 不得上传公网、推送 GitHub，或安装来源不明的依赖。

请按以下顺序执行：

1. 找到我上传的 ZIP 和图片附件的本机绝对路径，解压完整 ZIP 到一个不会被中途清理的工作目录。所有包含空格或中文的路径都要正确引用。

2. 解压后的客户目录根部应能看到：
   - `安装 Codex 主题编辑器.command`
   - `使用说明.txt`
   - `给 Codex 的部署提示词.md`
   完整引擎位于隐藏目录 `.codex-dream-skin-studio`。这是正常结构，不要删除、改名或只复制其中的 CSS/图片。Finder 默认看不到隐藏目录时，直接从终端使用其绝对路径。

3. 将隐藏引擎记为 `<ENGINE>`，先完整阅读：
   - `<ENGINE>/README.md`
   - `<ENGINE>/SKILL.md`
   - `<ENGINE>/references/qa-inventory.md`
   然后运行 `<ENGINE>/tests/run-tests.sh`。测试失败时先定位并修复，禁止跳过。

4. 确认官方 Codex 至少运行过一次，且 `~/.codex/config.toml` 已存在。运行：
   `<ENGINE>/scripts/install-dream-skin-macos.sh --no-launch`
   完整项目应被安装到 `~/.codex/codex-dream-skin-studio`，并生成桌面启动、定制、验证和恢复入口。

5. 如果我上传了主题图片，启动后优先使用主题中心内的“上传图片”：让页面完成压缩和自动取色，按我的要求设置主题名称、模块布局与颜色，然后“保存并应用”。只有图片是 HEIC/TIFF 或页面上传不可用时，才使用兼容脚本：
   `~/.codex/codex-dream-skin-studio/scripts/customize-theme-macos.sh --image "<图片绝对路径>" --name "我的 Codex Dream Skin" --no-apply`
   不要手工覆盖项目源文件。自定义素材应作为额外“我的主题”加入选择器，不能替换 20 款内置主题。若没有图片，保留完整内置主题包。

6. 我明确授权你在本次部署中关闭并重启官方 Codex 一次，以启用本机回环 CDP。只允许处理官方 Codex 及本项目可核验身份的注入守护进程，不得关闭其他应用。使用安装后的启动脚本执行真实重启，不要让我自行猜测是否生效。

7. 启动后必须运行：
   - `~/.codex/codex-dream-skin-studio/scripts/doctor-macos.sh --require-live`
   - `~/.codex/codex-dream-skin-studio/scripts/verify-dream-skin-macos.sh --reload --screenshot "<首页验收截图绝对路径>"`
   - `~/.codex/codex-dream-skin-studio/scripts/test-theme-studio-macos.sh`
   - 使用内置 Node 运行 `scripts/injector.mjs --port <实际端口> --test-all-effects`
   验证器和主题编辑器测试必须真实返回 `pass: true`，并明确显示 `builtinThemeCount: 20`、`secondThemeId: naruto`、`defaultThemeAvailable: true`、`uploadEnabled: true`、`uploadsReady: true`、`dynamicWallpaper.artStatic: true`、`dynamicWallpaper.animationPlayState: running`、`dynamicWallpaper.effectChanged: true`、主题按钮可见且可点击。首页还必须显示四张原生建议卡或四张备用任务卡；高达主题应为一张左侧跨两行的大卡、两张右上短卡和一张右下横向卡。实际点击其中一张，确认任务被写入原生输入框，再清空测试文本。随后实际点击右上角主题按钮，点击第 2 款火影忍者，确认无需刷新即可切换；再刷新一次确认选择仍保留。逐一检查 20 套内置主题均保持素材构图固定且独立动态图层运行，并确认 Theme Studio 新上传主题的 `savedMotion.artStatic: true` 与 `savedMotion.effectChanged: true`。接着实际点击最上方“系统默认”，确认 `themeId: system-default`、`systemDefault: true`、主题根类和附加装饰已清除且入口仍可见；刷新后确认仍为系统默认，再切回火影忍者。还要检查一个正常任务页面，确认静态素材背景全幅覆盖、独立光效层持续运行且正文、菜单、侧栏和输入框仍清晰可用；模拟 `prefers-reduced-motion: reduce` 时动画必须停止。保存首页、系统默认、主题面板、上传编辑器和任务页截图。

8. 检查桌面已存在以下四个入口：
   - `Codex Dream Skin.command`
   - `Codex Dream Skin - Customize.command`
   - `Codex Dream Skin - Verify.command`
   - `Codex Dream Skin - Restore.command`

9. 如果失败，读取 `~/Library/Application Support/CodexDreamSkinStudio/` 下的日志并继续修复。不得降低代码签名、回环端口归属、PID 身份、原生结构或截图验证标准；不得用“预计重启后生效”“应该完成”等措辞代替验收。

最终向我汇报：
- Codex 主题编辑器版本与官方 Codex 版本；
- 实际使用的主题名和素材文件；
- 右上角主题中心是否包含永久系统默认入口和完整 20 款、火影忍者是否为第 2 款、六类布局是否生效，以及主题/默认双向切换和刷新持久化是否通过；
- 20 套内置主题的 20 个唯一环境特效、客户上传主题的自动特效匹配、原画固定与减少动态效果降级是否通过；
- tests、doctor、verify、Theme Studio 自检的真实结果，其中 verify 和 Theme Studio 必须注明是否 `pass: true`；
- 首页与任务页实机截图绝对路径；
- 安装目录；
- 桌面四个入口是否齐全；
- 一键恢复入口；
- 官方应用代码签名是否仍有效；
- 明确说明官方 `.app` 和 `app.asar` 均未被修改。

如果尚未取得 `pass: true` 或实机界面不符合要求，请明确报告当前失败原因并继续修复，不要提前结束任务。
```
