# Usage Logger Protocol

## Purpose
Ghi nhận chi tiết framework usage sau mỗi workflow để phục vụ `/health` health check.

## CRITICAL RULE

> **Mỗi workflow PHẢI ghi log CHÍNH XÁC theo format bên dưới.**
> Log thiếu thông tin = health check không hoạt động = framework mù mờ.
> AI KHÔNG ĐƯỢC ghi log tóm tắt hoặc bỏ qua bất kỳ field nào.
> AI KHÔNG ĐƯỢC viết prose tự do thay thế cho format bảng.

## Incremental Tracking (BẮT BUỘC)

> **Không chờ cuối workflow mới ghi log** — track dần trong quá trình thực thi.

Agent PHẢI duy trì một **mental checklist** trong suốt quá trình thực thi:

```
TRACKING CHECKLIST (cập nhật liên tục):
□ Agents đã dùng: [executor, debugger, ...]
□ Skills đã đọc/tham chiếu: [flutter-expert, python-pro, ...] ⛔ KHÔNG ghi "nexus"
□ MCP Tools đã gọi: [find_symbol, get-library-docs, ...]
□ Memory operations: [read(file), write(file), ...]
□ Protocols đã load: [bilingual, guide, ...]
□ Sự cố gặp phải: [task X fail do Y, fix bằng Z, ...]
```

**Quy tắc tracking:**
1. Mỗi khi invoke MCP tool → ghi nhận tên tool
2. Mỗi khi đọc agent SKILL.md → ghi nhận agent
3. Mỗi khi tham chiếu domain skill → ghi nhận skill
4. Mỗi khi gặp lỗi và fix → ghi nhận vào "Sự cố"
5. Cuối workflow: tổng hợp checklist → paste vào format bên dưới

## When to Log
- Sau mỗi wave hoàn thành (trong `/execute`)
- Sau mỗi quick task (trong `/quick`)
- Sau mỗi review (trong `/review`)
- Sau mỗi design phase (trong `/design`)
- Sau mỗi plan phase (trong `/plan`)
- Sau mỗi verify (trong `/verify`)

## Log Location
`.nexus/logs/usage-log.md`

## Log Entry Format (BẮT BUỘC)

```markdown
## [{YYYY-MM-DD HH:MM}] {Workflow} — Phase {N} Wave {M}

| Loại | Đã sử dụng |
|---|---|
| **Agents** | {liệt kê tên agent: executor, planner, debugger...} |
| **Skills** | {domain skills từ SKILL-INDEX — xem bảng Skill Inference bên dưới. ⛔ KHÔNG ghi "nexus"} |
| **Workflows** | {workflow đã trigger: execute.md, quick.md...} |
| **Memory** | {memory operations: read(file), write(file), edit(file)} |
| **MCP Tools** | {tên tool MCP đã gọi: find_symbol, get-library-docs, batch_design, get_screenshot...} |
| **Protocols** | {shared protocols đã load: bilingual, guide, elicitation...} |

**Kết quả**: {X}/{Y} tasks completed | {N} errors | {M} commits
**Thời gian**: ~{X} phút
**Chế độ**: {interactive / autonomous}

### Chi tiết Tasks
| # | Task | Trạng thái | Sự cố & Fix | Ghi chú |
|---|------|-----------|-------------|---------|
| 1 | {task name} | ✅/❌ | {lỗi gì, fix thế nào — hoặc "—" nếu OK} | {ghi chú ngắn} |
| 2 | {task name} | ✅/❌ | | |
```

> **KHÔNG CHẤP NHẬN** viết prose thay cho bảng. Ví dụ SAI:
> ```
> - **Details**: Plan 1-1: Tauri v2..., Plan 1-2: DatabaseService...
> ```
> → PHẢI dùng bảng format ở trên.

## Ví dụ Đúng ✅

```markdown
## [2026-03-04 14:30] Execute — Phase 1 Wave 1

| Loại | Đã sử dụng |
|---|---|
| **Agents** | executor, debugger |
| **Skills** | flutter-expert, python-pro, systematic-debugging |
| **Workflows** | execute.md |
| **Memory** | read(task-board.md), write(progress-executor.md), write(results-1-1.md) |
| **MCP Tools** | find_symbol, replace_symbol_body, context7 (fastapi: lifespan pattern), context7 (react-router: v7 API) |
| **Protocols** | bilingual, guide, elicitation, context-loading |

**Kết quả**: 4/5 tasks completed | 1 error | 4 commits
**Thời gian**: ~25 phút
**Chế độ**: interactive

### Chi tiết Tasks
| # | Task | Trạng thái | Sự cố & Fix | Ghi chú |
|---|------|-----------|-------------|---------|
| 1 | Tạo database schema | ✅ | — | SQLite WAL mode |
| 2 | Implement Python CLI | ✅ | — | |
| 3 | Tạo Flutter models | ✅ | — | |
| 4 | Implement service bridge | ❌ | TypeError: missing null check → thêm null guard | escalate to debugger |
| 5 | Fix service bridge | ✅ | — | Retry from task 4 |
```

## Ví dụ Sai ❌ (KHÔNG CHẤP NHẬN)

```markdown
### 2026-03-05 00:30 — /execute 1
- **Workflow**: execute
- **Duration**: ~40 min
- **Result**: ✅ 4 plans / 13 tasks
- **Details**: Plan 1-1: Tauri setup, Plan 1-2: Database...
```

→ Thiếu: bảng Agents/Skills/MCP Tools/Memory/Protocols, bảng Chi tiết Tasks, cột Sự cố & Fix.

## Self-Check (PHẢI làm trước khi ghi log)

Trước khi append vào `usage-log.md`, agent PHẢI tự kiểm tra:

- [ ] Có đúng format bảng 6 fields không? (không phải prose)
- [ ] Agents: liệt kê ĐỦ agent đã invoke? (không chỉ "executor")
- [ ] Skills: liệt kê ĐỦ domain skills? ⛔ **Nếu ghi "nexus" → SAI, phải thay bằng domain skill cụ thể**
- [ ] MCP Tools: liệt kê ĐỦ tool names đã gọi? (find_symbol, query-docs, etc.)
- [ ] **Context7 Check**: nếu task dùng thư viện ngoài → MCP Tools CÓ chứa `context7 ({library})` entries? ⛔ Nếu thiếu → bổ sung hoặc ghi `⚠️ Context7 N/A`
- [ ] Memory: liệt kê ĐỦ read/write/edit operations?
- [ ] Protocols: liệt kê ĐỦ _shared/ protocols đã load?
- [ ] Bảng Chi tiết Tasks: CÓ cột "Sự cố & Fix"?
- [ ] Mỗi task có ghi sự cố nếu đã xảy ra? (không bỏ trống khi có lỗi)

Nếu bất kỳ field nào trống → ghi "không sử dụng" (KHÔNG để trống).

## Auto-Detection Guide

AI detect usage bằng cách tự ghi nhớ trong session:
1. Agent SKILL.md nào đã load → **Agents**
2. Domain skill nào đã tham chiếu/đọc → **Skills** (xem bảng Skill Inference bên dưới)
3. Workflow .md nào là entry point → **Workflows**
4. Memory tool calls nào đã thực hiện → **Memory**
5. MCP server tools nào đã invoke → **MCP Tools**
6. `_shared/` protocols nào đã read → **Protocols**

## Skill Inference Guide (BẮT BUỘC đọc trước khi ghi log)

> `nexus` là skill **điều phối**, KHÔNG phải domain skill.
> Agent PHẢI suy luận domain skill từ context task, dùng bảng bên dưới.
> Tham chiếu đầy đủ: `.agent/skills/SKILL-INDEX.md`

### Workflow → Suggested Skills

| Workflow | Luôn ghi | Ghi thêm nếu liên quan |
|----------|----------|------------------------|
| `/init` | `architecture` | `brainstorming`, `domain-driven-design` |
| `/design` | `design-taste` | `tailwind-design-system`, `react-patterns`, `flutter-expert` |
| `/plan` | `writing-plans` | `concise-planning`, `executing-plans` |
| `/execute` | *suy luận từ tech stack* | xem bảng Tech Stack Mapping bên dưới |
| `/verify` | `verification-before-completion` | `testing-patterns`, `e2e-testing` |
| `/review` | `code-reviewer` | `security-auditor`, `clean-code`, `wcag-audit-patterns` |
| `/quick` | *suy luận từ task* | `systematic-debugging`, `error-handling-patterns` |

### Tech Stack → Domain Skills (cho `/execute`)

| Nếu task liên quan đến... | Ghi skill |
|--------------------------|----------|
| HTML/CSS/JS frontend | `javascript-mastery`, `web-performance-optimization` |
| React / Next.js | `react-best-practices`, `react-patterns`, `nextjs-best-practices` |
| Angular | `angular` |
| Flutter / Dart | `flutter-expert` |
| Node.js / Express | `nodejs-best-practices` |
| NestJS | `nestjs-expert` |
| Python backend | `python-pro`, `fastapi-pro` hoặc `django-pro` |
| TypeScript | `typescript-expert` |
| Database / Schema | `database-design`, `postgresql`, `prisma-expert` |
| Docker / Deploy | `docker-expert`, `deployment-procedures` |
| CI/CD | `github-actions-templates` |
| API design | `api-design-principles` |
| CSS / Tailwind | `tailwind-design-system` |
| Security / Auth | `auth-implementation-patterns`, `security-auditor` |
| Testing | `test-driven-development`, `testing-patterns` |
| Design system / UI | `design-taste` |
| Code quality / Refactor | `clean-code`, `codebase-cleanup-tech-debt` |
| Documentation | `documentation`, `readme` |

### Ví dụ Suy Luận

**Task**: "Initialize Vite project + implement CSS design system + build app shell"
→ Skills: `javascript-mastery`, `design-taste`, `web-performance-optimization`, `clean-code`

**Task**: "Build Flutter login screen with auth API"
→ Skills: `flutter-expert`, `auth-implementation-patterns`, `api-design-principles`

**Task**: "Fix database connection timeout bug"
→ Skills: `systematic-debugging`, `database-design`, `error-handling-patterns`
