# Changelog

## 2.10.12 — 2026-07-20

- Moved the China task inscription from the fixed chrome overlay into the task surface's `z-index: -1` background layer, so native messages, generated images, attachments, summary panels, and the composer always render above it.
- Reduced the inscription to 28% vermilion opacity before the existing ambient-layer animation, removed the foreground baseline ornament, and retained the restrained Songti typography and lower-right placement.
- Extended live checks to require a hidden task-page chrome quote, exact background copy, negative stacking order, click-through behavior, and a maximum 30% text alpha.

## 2.10.11 — 2026-07-20

- Added “一颗红心向祖国，一片赤诚为人民” as a dedicated inscription on the China theme's normal task background while preserving the home-page motto “为人民服务”.
- Typeset the inscription in restrained Songti with a low-saturation red-to-gold treatment, fine baseline, and compact ceremonial accent; it remains a click-through decorative layer outside the native task content and composer.
- Extended live verification to check the exact task-page copy, home/task separation, type treatment, lower-right placement, and safe clearance above the composer.

## 2.10.10 — 2026-07-20

- Replaced the China workbench's four generic/native action pictograms with a unified polished hammer-and-sickle emblem treatment across both native suggestion cards and the interactive four-card fallback deck.
- Added double gold rings, controlled red enamel shading, highlight and inset depth so the party-emblem badges remain crisp instead of reading as rough black glyphs.
- Added live badge rendering checks alongside the existing empty, one-line, five-line, and cleared-composer regression coverage.

## 2.10.9 — 2026-07-20

- Fixed the China workbench losing its home layout when Codex hides native suggestions after text input; home detection now follows the stable home composer route marker.
- Moved Codex 26.715's real absolute project-toolbar layer back into the home flex flow, ordered before the composer, and disabled only that layer's focus translation while preserving its buttons and project state.
- Removed the fallback-card height collapse that placed the composer behind the task deck, and added live empty, one-line, five-line, and cleared-draft screenshot regression coverage.

## 2.10.8 — 2026-07-20

- Rebalanced the China workbench home page with a wider hero and a consistent left/right alignment shared by the hero, mission deck, project panel, and native composer.
- Added deliberate vertical breathing room between the hero, mission cards, project selector, and composer; the project panel no longer overlaps the composer.
- Kept the normal task page palette and symbolic red treatment introduced in 2.10.7 unchanged.

## 2.10.7 — 2026-07-20

- 按“红色是政治与文化象征，而非整页具体红色”的反馈重做第 4 套普通任务页配色；主页五星红旗横幅保持不变。
- 任务工作区改用宣纸暖白、低饱和米金与极淡朱砂光晕，大面积高饱和红色底层全部移除。
- 红色收敛到五星红旗、主题按钮、细边框、粒子与少量强调元素，保留“人民叙事、庄重感、红旗精神”的抽象表达，同时提升长时间工作的舒适度。

## 2.10.6 — 2026-07-20

- 根据局部放大图继续消除第 4 套任务页底部的笔直拼接线：人物层在素材真实底边之前完成透明羽化，不再显示原图最后一行像素。
- 将底部红色环境渐变提前至页面约 66% 高度开始介入，跨过人物层交界区连续混色，避免“上方是原画、下方是纯色”的二段式效果。
- 保持人物、国旗和红金电路主体完整，底部输入区仍使用原生 DOM 与暖白玻璃层。

## 2.10.5 — 2026-07-20

- 将第 4 套任务页拆为两层独立渲染：全高红金环境底色直接铺满任务容器，五人人物原画保留为单独的静态装饰层。
- 为人物原画恢复宽幅椭圆羽化，但不再裁切环境底色；原画上下边缘柔和融入连续红金背景，消除 2.10.4 实机图中仍可辨认的水平素材边线。
- 保持人物面积、五星红旗和红金电路的视觉占比，并继续保护左侧正文和底部输入框的可读性。

## 2.10.4 — 2026-07-20

- 修复第 4 套任务页人物画面与上下暖白区域分层明显的问题：将纵向椭圆遮罩改为只控制左右过渡的横向渐隐，避免素材上下区域被整体裁掉。
- 在人物素材后增加贯穿完整任务页高度的中国红径向环境光与红金渐变底层，使顶部、中部和底部属于同一连续场景。
- 减弱页面顶端与底端的白色覆盖强度，保留输入框和正文可读性的同时消除明显水平断带。

## 2.10.3 — 2026-07-20

- 放大第 4 套普通任务页的五人人物主视觉，将素材宽度由 88% 提升至 116%，并扩大椭圆渐隐高度，使人物与五星红旗从右下局部贴片升级为右侧半屏叙事背景。
- 提升中国红饱和度、人物对比度和右侧红金环境光，同时保留正文左侧暖白阅读遮罩与底部输入区可读性。
- 视觉资源通过 2.10.2 引入的热更新机制即时生效，不重启 Codex，也不修改官方 `app.asar`。

## 2.10.2 — 2026-07-20

- 修复常驻注入器长期运行时继续使用旧版内存主题包的问题：CSS、主题清单、素材或本机自定义主题发生变化后，代理会自动重新载入并热应用，不再在页面刷新后回退到旧布局。
- 重启看门狗新增版本漂移检测：安装目录版本与运行状态不一致时，只刷新后台注入器，不关闭或重启 Codex。
- 自检新增资源热更新与版本漂移恢复守卫，继续保持 CDP 回环注入且不修改官方 `app.asar`。

## 2.10.1 — 2026-07-19

- 调整第 4 套主页纵向节奏：横幅增高至约 342px，任务卡增高至约 128px，并将横幅、四卡、项目栏和输入区的稳定间距统一到 22–27px，避免模块过度挤在上半屏。
- 重构第 4 套普通任务页背景过渡：人物原画改为更宽、更低透明度的椭圆渐隐环境层，消除超宽图片上下边界形成的矩形贴片感。
- 将中国红金主题的任务信息面板、滚动页脚和输入区周边从通用深色玻璃层切换为暖白红金玻璃层，修复顶部黑面板与底部黑块破坏浅色主题一致性的问题。
- 主页与任务页继续保留原生侧栏、项目选择器、输入框、任务正文和主题切换交互；本轮仍未修改官方 `app.asar`。

## 2.10.0 — 2026-07-19

- 第 4 套“人民 AI · 中国特色科创工作台”主视觉升级为五人构图：新增 Donald Trump 并置于人物组正中 C 位，Sam Altman、Elon Musk、Jensen Huang 与 Dario Amodei 分列两侧；人物画面仍为不代表真实合作或背书的概念编辑视觉。
- 重排新建任务主页：压缩横幅与任务卡总高度，将四张任务卡改为紧凑横向信息结构，并收紧任务区、项目选择器和输入框之间的垂直节奏。
- 为普通任务页增加独立背景裁切：不再将超宽人物横幅强制 `cover` 放大，而是在右侧以受控比例展示，叠加上下柔化和左侧高可读遮罩，避免人物压住正文与输入区。
- 素材登记、槽位断言与版本自检同步更新至 `2.10.0`。

## 2.9.0 — 2026-07-18

- 第 6–9 套更新为《恶搞之家》太空冒险、多元宇宙、庄园悬疑与时间旅行四个非官方粉丝剧情主题，全部使用独立无 UI 超宽海报，不以整张界面截图覆盖 Codex。
- 新增 `sitcom-cosmos`、`portal-episode`、`mystery-mansion`、`time-machine` 四个布局：横向发射甲板、海报内 2×2 传送门选集、不对称案件证据板和纵向时间线，内置布局从八类扩展到十二类。
- 四套主题分别提供太空任务、多元宇宙、案件调查和时间线专属任务文案；原生建议卡可用时同步替换标题，缺失时使用可写入真实输入框的四张备用卡。
- 新增宇宙漂移、传送门能量、庄园雷雨和时间残影四个独立动态特效；海报原画继续保持 `animation: none` 与 `transform: none`。
- 修复普通任务页在 Codex 26.707 浅色基底下 Markdown/表格文字对比不足的问题，并将底部渐变、用户消息与右侧任务信息面板统一为可读的主题玻璃层；实机验收新增任务前景亮度门槛。
- 将大体积主题包重注入及主题/路由操作的 CDP 时限提升到 30–120 秒；截图前的鼠标、键盘清理改为非阻断操作，避免繁忙渲染器造成假失败。
- 扩充槽位顺序、布局白名单、唯一特效映射、素材来源、版本与实机验收要求。

## 2.8.0 — 2026-07-17

- 第 4 套升级为“人民 AI · 中国特色科创工作台”：独立横幅加入规范五星红旗、中国现代化城市，以及 Sam Altman、Elon Musk、Jensen Huang、Dario Amodei 四位人物的概念编辑肖像；主标题更新为“为人民服务的 AI 才是好 AI”，任务卡改为服务人民、自主创新、安全责任和解决一线问题。人物画面不代表任何真实合作或背书。
- 第 5 套替换为“AI 巨擘 · 黑金圆桌”：使用用户提供的人物主视觉，新增黑金圆桌舞台、嵌入横幅右上方的 2×2 决策模块和战略、算力、产品、风险四类专属提示词。
- 新增 `china-workbench` 与 `executive-stage` 两个布局家族，内置布局从六类扩展到八类；第 4、5 套不再继承通用电影横幅或编辑画册模板。
- 新增赤金流光与黑金聚光两套独立动态环境特效；素材原画保持静止，动画只作用于光流、星点、聚光和颗粒层。
- 主题中心的上传编辑器同步开放八种布局选择；自动化测试新增第 4、5 槽位、布局、素材和版本检查。

## 2.7.0 — 2026-07-17

- 20 款内置主题各自绑定唯一环境特效：传送门火花、忍者雷暴、轨道扫描、深海气泡、樱花飘落、霓虹雨、星际跃迁、水墨雾、极光、沙尘、冰雪、合成激光、萤火、锻炉余烬、蒸汽齿轮、糖果彩纸、矩阵数字雨、海岸闪光、月夜流星与银色颗粒。
- 原画层继续保持 `animation: none` 与 `transform: none`；动画仅作用于独立的光效、粒子、烟雾、碎屑和扫描层，原生界面与素材构图不发生整体横移。
- 粒子不再只有统一圆点：根据主题呈现花瓣、气泡、雨线、雪点、火星、雾团、纸屑、流星、扫描短线等不同轮廓和轨迹。
- 新增 `--test-all-effects` 实机循环验收：一次切换 20 套主题并核对唯一特效映射、原画静止、动画运行、时间线变化、点击穿透、无横向溢出及原主题恢复。
- 客户上传主题根据强调色和布局在本机选择合适环境特效；Theme Studio 自检同步验证新特效层。

## 2.6.0 — 2026-07-17

- 修正动态视觉方向：主页横幅和任务页的素材图保持固定构图，不再左右平移或整体缩放；运动改由独立的星点流、扫描光束、能量辉光和环境呼吸层完成。
- 新增显式 `dream-skin-hero-fx` 与 `dream-skin-viewport-fx` 动态层，全部 `pointer-events: none`，不会移动或遮挡 Codex 原生界面与交互。
- 高达主页任务区按已确认预览重排为非对称指挥面板：左侧任务简报纵向跨两行，右侧两个短面板与一个横向执行面板，区别于四张同尺寸卡片。
- 主页纵向空间改为根据 382px 主视觉和 214px 非对称任务区预留，项目选择器与输入框紧随任务模块，不再依赖旧的四卡单行高度。
- 实机验收器改为同时要求“素材图静止”和“独立特效层确实在运动”，并验证高达主页非对称任务布局、刷新恢复与减少动态效果降级。

## 2.5.0 — 2026-07-16

- 为 20 套内置主题和客户上传主题加入通用动态壁纸引擎：主页横幅与普通任务页素材均以低速景深平移、轻微缩放和环境光呼吸呈现。
- 内置主题按槽位分配六种不同运动轨迹；上传主题按本地主题 ID 稳定分配轨迹，避免所有主题同向、同速运动。
- 动态图片与光效全部位于 `pointer-events: none` 的独立装饰层，原生侧栏、任务卡、项目选择器、输入框、正文和菜单继续保持真实交互。
- 新增 `prefers-reduced-motion` 降级：macOS 开启“减少动态效果”后，壁纸、环境光和粒子立即静止。
- 验收器现在会实测动画名称、运行状态、短时间位移变化、全幅任务背景和点击穿透；Theme Studio 自检也会验证新上传主题自动获得动态背景。
- 修复窄窗口高达主页中横幅裁切层遮住四张任务卡的问题：图片只在独立容器内裁切，任务卡保持完整可见。

## 2.4.1 — 2026-07-16

- 高达普通任务页由右侧半屏定位改为全工作区 `cover` 背景，并加入左深右清的分区遮罩与轻磨砂内容层。
- 主页 01–04 作战卡收拢到与原生输入框相同的 1128px 基线，项目栏取消原生横向边距并与输入框完全对齐。
- 重建横幅、作战卡、项目栏和输入框的垂直节奏：横幅到卡片约 20px，卡片到项目栏约 18px，避免粘连或错位。
- 验收器新增主页任务区左右基线、卡片到项目栏间距以及任务页全幅背景检查。

## 2.4.0 — 2026-07-16

- 将第 3 套高达主题从共享的 `terminal-grid` 中拆出，新增独立 `orbital-command` 布局家族，避免刷新后退回通用 2×2 模板。
- 宽屏主页固定为横向 01–04 作战面板，并同时覆盖 Codex 原生建议卡和备用任务卡两种运行状态。
- 取消项目输入区的剩余高度贴底行为，使原生项目选择器和输入框紧跟作战面板，清除中部大块空白。
- 实机验证新增高达专属门槛：宽屏必须四卡同排、使用独立布局，且任务卡到项目选择器的间距不超过 120px。

## 2.3.0 — 2026-07-16

- 将第 3 个内置槽位从霓虹赛博替换为“高达 · 轨道指挥中心”，加入用户确认的经典蓝白红金机体横幅。
- 新增第 3 套专属蓝金指挥中心布局：左上 `MECHA OPS` 单元标识、顶部系统状态、巨幅中文任务标题和横向 01–04 作战任务卡。
- 新增高达主题专属可点击任务提示词，同时保留原生 Codex 侧栏、项目选择器、输入框、任务页和右上角主题中心。
- 完成热更新、刷新恢复、系统默认往返、无横向溢出和真实主页截图验收。

## 2.2.0 — 2026-07-16

- 主题中心新增页面内上传：直接选择 PNG、JPEG 或 WebP，最长边自动压缩到 1600×1000 范围并转成 WebP，全程不访问网络。
- 新增 48×48 采样自动取色，同时允许调整主题名称、五种模块布局、强调色、辅助色、面板色和文字色，保存后立即应用。
- 上传主题使用 Codex 本机 IndexedDB 持久化，最多保存 12 款；支持一键删除，不覆盖系统默认入口或 20 款内置主题。
- 新增主题编辑器端到端自检：自动生成测试图片，验证压缩、取色、预览、保存、布局应用、IndexedDB 删除与原主题恢复。
- 常驻注入器由临时 `launchctl submit` 改为正式用户级 LaunchAgent，避免冷却期和失败重试循环；安装、启动和恢复会清理遗留 repair 任务。
- `doctor --require-live` 现在同时要求重启看门程序和持久注入器均已安装、加载；刷新验证依赖真实常驻注入器重新应用，不再由验证命令代为注入。

## 2.1.0 — 2026-07-16

- 主题中心最上方新增永久“系统默认 · 原生 Codex”入口，不占 20 个内置主题位置。
- 系统默认会清除主题类、横幅、背景、附加任务卡与装饰 DOM，同时保留右上角入口；刷新后仍保持默认，客户可随时重新启用主题。
- 新增电影横幅、沉浸任务板、控制台、编辑画册、极简聚焦五种布局家族，20 款主题不再共用同一模块尺寸与位置。
- 火影忍者改为沉浸任务板：横幅增高、佐助放大、红蓝环境延伸到卡片，四张任务卡压住横幅底部并轻微错落。
- 瑞克与莫蒂保留电影横幅结构，与火影忍者形成可实测的高度、卡片位置和人物占比差异。
- 验证器新增系统默认可用性、主题清理状态、布局变量与 21 个选择项检查。

## 2.0.0 — 2026-07-15

- 新增右上角“Codex 主题中心”，点击即可浏览并即时切换主题。
- 内置 20 款独立主题，第 1 款保留瑞克与莫蒂，第 2 款固定为火影忍者。
- 新增主题选择持久化，刷新、任务切换和重新启动后仍保留上次选择。
- 客户上传图片生成的自定义主题作为“我的主题”加入选择器，不占用 20 个内置位置。
- 验证器新增主题按钮、20 款数量、火影忍者顺序与交互层可点击检查。
- 新增命令行实机切换与主题面板截图能力，用于自动化验收。
- 火影忍者主题改用用户母版的干净佐助/写轮眼/雷电裁切，素材内不含第三方 ID、网址或助手信息卡。
- 当 Codex 当前版本不提供原生首页建议卡时，自动显示四张真实可点击的备用任务卡；点击后把对应任务写入原生输入框，原生卡恢复时自动隐藏。

## 1.0.0 — 2026-07-15

- 发布 macOS 通用主题制作器，而不是固定角色皮肤。
- 加入 Finder 选图、自动 JPEG 转换、主题命名和高级配色参数。
- 主页使用独立横幅，任务页使用背景与磨砂层，完整保留原生交互。
- 改为复用并验证 Codex 官方签名 Node.js，不再附带大型运行时或依赖全局 Node。
- 增加独立安装目录、桌面启动/定制/验证/恢复入口。
- 增加官方签名、CDP 端口归属、PID 身份、刷新重注入和真实 DOM 自检。
- 增加原子配置备份、精确恢复、静态测试、安装恢复循环和发布打包脚本。
- 清理固定角色内部命名；传送门主题仅作为可替换示例素材。
