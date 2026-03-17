# Nexus Framework

> **Unified Agentic Development Framework for Antigravity IDE**

Nexus là framework phát triển phần mềm agentic có cấu trúc, thiết kế cho Antigravity IDE. Framework biến AI từ trợ lý trả lời câu hỏi thành **đội ngũ phát triển phần mềm chuyên nghiệp** với quy trình bài bản: phân tích → thiết kế → lập kế hoạch → thực thi → kiểm tra → nghiệm thu.

---

## 📌 Mục lục

- [Tổng quan](#-tổng-quan)
- [Điểm đặc biệt](#-điểm-đặc-biệt)
- [Kiến trúc](#-kiến-trúc)
- [Workflow Engine](#-workflow-engine)
- [6 Agents chuyên biệt](#-6-agents-chuyên-biệt)
- [116 Skills](#-116-skills)
- [3 MCP tích hợp](#-3-mcp-tích-hợp)
- [Shared Protocols](#-shared-protocols)
- [Self-Learning (Reasoning Bank)](#-self-learning-reasoning-bank)
- [Cấu hình](#%EF%B8%8F-cấu-hình)
- [Cài đặt](#-cài-đặt)
- [Sử dụng](#-sử-dụng)
- [Bảo trì & Health Check](#-bảo-trì--health-check)
- [Giấy phép](#-giấy-phép)

---

## 🎯 Tổng quan

Nexus giải quyết vấn đề cốt lõi của AI-assisted development: **thiếu quy trình**. Thay vì để AI tự do sinh code mà không có kiểm soát, Nexus cung cấp:

| Vấn đề | Giải pháp Nexus |
|--------|----------------|
| AI code không có kế hoạch | Workflow bắt buộc: plan → execute → verify |
| Không nhất quán giữa các phiên | State management + session handover |
| Bỏ sót requirements | Requirement tracking từ init đến verify |
| Không phân chia trách nhiệm | 6 agents chuyên biệt, mỗi agent một vai trò |
| Không kiểm tra chất lượng | Verify + Review + Quality gates tự động |
| Lặp lại lỗi cũ | Reasoning Bank (self-learning từ patterns) |
| Thiếu documentation | Usage log + session metrics tự động |

### Đặc trưng ngôn ngữ

Nexus được thiết kế cho **phát triển phần mềm dành cho người dùng Việt Nam**:

- **Giao tiếp AI ↔ Developer**: Tiếng Việt
- **Code internals**: Tiếng Anh (biến, hàm, class, commit messages, comments kỹ thuật)
- **UI/UX cho người dùng cuối**: Tiếng Việt (labels, messages, tooltips, notifications)

---

## ✨ Điểm đặc biệt

### 1. Workflow-Driven Development

Không phải chatbot — mà là **quy trình phát triển có cấu trúc**. Mỗi lệnh kích hoạt một workflow hoàn chỉnh với prerequisites, steps, error handling, và output format chuẩn hóa.

### 2. Multi-Agent Architecture

6 agents chuyên biệt hoạt động như một team thực sự. Orchestrator tự động routing task đến agent phù hợp, hỗ trợ **thực thi song song** theo wave.

### 3. Wave-Based Execution

Plans được nhóm thành waves có dependency:
```
Wave 1 (độc lập):  [Plan A, Plan B]  → Thực thi song song
Wave 2 (phụ thuộc W1): [Plan C]      → Chờ Wave 1 xong
Wave 3 (phụ thuộc W2): [Verify]      → Chạy cuối
```

### 4. Self-Learning (Reasoning Bank)

Framework **tự học** từ mỗi task đã hoàn thành. Patterns thành công được lưu và tái sử dụng, patterns thất bại được ghi nhận để tránh lặp lại.

### 5. Smart Guide

Sau mỗi workflow, Nexus tự động đề xuất 2-3 bước tiếp theo dựa trên vị trí hiện tại trong lifecycle. Kèm **Complexity Router** tự động đánh giá độ phức tạp task (0-10) và suggest workflow phù hợp.

### 6. Requirements Elicitation

Hệ thống hỏi đáp thông minh với 3 mức độ (thorough/balanced/quick). AI không tự đoán — mà xác nhận với developer trước khi tiến hành.

### 7. Design-First Approach

Phase nào có UI đều phải qua `/design` trước khi `/plan`. Tạo wireframes, user flows, design system, component inventory — tất cả trước khi viết dòng code đầu tiên.

---

## 🏗 Kiến trúc

### Cấu trúc thư mục

```
project/
├── .agent/                          # ← Framework (Antigravity native format)
│   ├── rules/
│   │   └── nexus-guide.md           # Auto-loaded rules
│   ├── workflows/                   # 14 workflow definitions
│   │   ├── init.md                  # Khởi tạo dự án
│   │   ├── design.md                # Thiết kế UI/UX
│   │   ├── plan.md                  # Lập kế hoạch phase
│   │   ├── execute.md               # Thực thi (wave-based)
│   │   ├── verify.md                # Xác minh
│   │   ├── review.md                # Kiểm tra chất lượng
│   │   ├── quick.md                 # Tác vụ nhanh
│   │   ├── progress.md              # Xem tiến độ
│   │   ├── guide.md                 # Hướng dẫn bước tiếp
│   │   ├── health.md                # Kiểm tra sức khỏe framework
│   │   ├── start.md                 # Khởi đầu phiên làm việc
│   │   ├── end.md                   # Kết thúc phiên làm việc
│   │   ├── learn.md                 # Extract patterns → reasoning-bank
│   │   └── evolve.md                # Cluster patterns → skill amendments
│   ├── skills/                      # 116 skills — Antigravity auto-discover
│   │   ├── nexus/SKILL.md           # Framework entry point
│   │   ├── SKILL-INDEX.md           # Bảng tra cứu keyword
│   │   └── {14 categories}/         # Xem chi tiết bên dưới
│   ├── agents/                      # 6 agents + 14 shared protocols
│   │   ├── architect/SKILL.md       # Phân tích yêu cầu, kiến trúc
│   │   ├── designer/SKILL.md        # Wireframes, design system
│   │   ├── planner/SKILL.md         # Tạo plan XML atomic
│   │   ├── executor/SKILL.md        # Code theo plan
│   │   ├── reviewer/SKILL.md        # Verify, security audit
│   │   ├── debugger/SKILL.md        # Root cause analysis
│   │   └── _shared/                 # 14 protocols dùng chung
│   ├── orchestration/               # Điều phối đa agent
│   │   ├── orchestrator.md          # Wave scheduling + error escalation
│   │   ├── memory-schema.md         # Memory file schemas
│   │   └── subagent-prompt.md       # Agent prompt composition
│   ├── maintenance/                 # Bảo trì
│   │   ├── health-check.md          # Health check methodology
│   │   └── usage-logger.md          # Log format specification
│   └── templates/                   # Templates cho .nexus/
│       ├── reasoning-bank.json      # Self-learning store
│       ├── plan.md                  # XML plan template
│       ├── state.md                 # Project state template
│       ├── summary.md               # Execution summary template
│       └── usage-log.md             # Usage log template
├── GEMINI.md                        # Antigravity auto-load rules
├── nexus.json                       # Cấu hình framework
└── .nexus/                          # Trạng thái dự án (tạo bởi /init)
    ├── state.md                     # Trạng thái hiện tại
    ├── project.md                   # Tầm nhìn, tech stack
    ├── requirements.md              # Yêu cầu đã phạm vi hóa
    ├── roadmap.md                   # Lộ trình phases
    ├── memory/                      # Shared memory giữa agents
    │   ├── reasoning-bank.json      # Self-learning patterns
    │   ├── task-board.md            # Task tracking
    │   └── progress-*.md            # Progress files
    ├── phases/                      # Kế hoạch + design theo phase
    │   ├── phase-1/
    │   │   ├── design/              # Design artifacts
    │   │   ├── phase-1-1-PLAN.md    # Plans
    │   │   └── wave-structure.md    # Wave dependencies
    │   └── ...
    └── logs/
        └── usage-log.md             # Lịch sử sử dụng framework
```

### Hai lớp tách biệt

| Lớp | Thư mục | Mục đích | Git |
|-----|---------|----------|-----|
| **Framework** | `.agent/` | Engine + skills + agents (không đổi) | Track |
| **Project State** | `.nexus/` | Trạng thái dự án cụ thể (thay đổi liên tục) | Track |

---

## 🔄 Workflow Engine

### Chu trình phát triển

```
/init → /design → /plan → /execute → /verify → /review
                                        ↑         |
                                        └─────────┘ (loop nếu có issues)
```

### Bảng lệnh đầy đủ

| Lệnh | Giai đoạn | Khi nào dùng | Mô tả |
|-------|-----------|-------------|-------|
| `/init` | Khởi tạo | Đầu dự án | Hỏi đáp → tạo `.nexus/` với state, project, requirements, roadmap |
| `/design [N]` | Thiết kế | Phase có UI | Wireframes, user flows, design system, component inventory |
| `/plan [N]` | Kế hoạch | Mỗi phase | Phân rã thành plans atomic, nhóm waves, định nghĩa tasks |
| `/execute [N]` | Xây dựng | Sau plan | Thực thi từng task theo wave, atomic commits |
| `/verify [N]` | Kiểm tra | Sau execute | Automated tests, gap analysis, cross-plan integration |
| `/review [scope]` | Chất lượng | Sau verify | Security, performance, accessibility audit |
| `/quick` | Ad-hoc | Bất kỳ | Bug fix, task nhỏ không cần full lifecycle |
| `/progress` | Tiến độ | Bất kỳ | Xem vị trí hiện tại + guide |
| `/guide` | Điều hướng | Tự động | Đề xuất 2-3 bước tiếp theo |
| `/health` | Bảo trì | Định kỳ | Kiểm tra sức khỏe nội bộ framework |
| `/start` | Phiên | Đầu phiên | Khôi phục context, kiểm tra MCP, hiện state |
| `/end` | Phiên | Cuối phiên | Lưu state, tạo handover, nhắc commit, auto-learn |
| `/learn` | Học | Bất kỳ | Extract patterns từ usage-log vào reasoning-bank |
| `/evolve` | Tiến hóa | Định kỳ | Cluster patterns → suggest amendments cho skills |

### Workflow chi tiết

Mỗi workflow file (`.agent/workflows/*.md`) có cấu trúc chuẩn:

```yaml
---
description: Mô tả ngắn
---
# Prerequisites    ← Đọc files cần thiết trước khi chạy
# Steps           ← Từng bước chi tiết với error handling
# Error Triggers  ← Xử lý khi gặp lỗi
# Output          ← Kết quả mong đợi
# Usage Log       ← Format ghi log bắt buộc
```

### Complexity Router

Khi developer hỏi "nên làm gì?", Nexus tự đánh giá complexity (0-10):

| Factor | 0 | 1 | 2 |
|--------|---|---|---|
| Files affected | 1 file | 2-3 files | 4+ files |
| Module scope | Same module | 2 modules | Cross-module |
| Task type | Bug fix / typo | Enhancement | New feature |
| Risk level | Low (styling) | Medium (logic) | High (data, security) |
| Test impact | No test changes | Update tests | New test suite |

| Score | Workflow đề xuất |
|-------|-----------------|
| 0-2 | `/quick` — xong trong 10 phút |
| 3-5 | `/plan → /execute` — cần plan nhưng không cần design |
| 6-8 | `/plan → /execute → /verify` — cần full cycle |
| 9-10 | `/design → /plan → /execute → /verify → /review` — toàn bộ lifecycle |

---

## 🤖 6 Agents chuyên biệt

### Agent Profiles

| Agent | Vai trò | Khi nào invoke | Skills chính |
|-------|---------|---------------|-------------|
| **Architect** | Phân tích yêu cầu, thiết kế kiến trúc, chọn tech stack | `/init`, tasks kiến trúc | DDD, C4, microservices |
| **Designer** | Wireframes, user flows, design system, component inventory | `/design` | UI/UX, Figma, accessibility |
| **Planner** | Phân rã features thành plans atomic, nhóm waves | `/plan` | Task decomposition, dependency analysis |
| **Executor** | Code theo plan, atomic commits, verify từng task | `/execute`, `/quick` | All programming languages |
| **Reviewer** | Verify, security/performance/accessibility audit | `/verify`, `/review` | OWASP, WCAG, code quality |
| **Debugger** | Root cause analysis, minimal fix, pattern logging | Khi có errors | Stack trace analysis, bisect |

### Agent Routing

Orchestrator tự động route task đến agent phù hợp:

| Task Type | Primary | Support | Workflow |
|-----------|---------|---------|----------|
| Bug Fix | executor | debugger | `/quick` |
| New Feature | executor + designer | reviewer | `/design → /plan → /execute` |
| Refactor | executor | reviewer | `/plan → /execute → /verify` |
| Security Audit | reviewer | executor | `/review` |
| UI/UX Design | designer | executor | `/design` |
| Architecture | architect + planner | reviewer | Full lifecycle |

### Parallelization

Agents có thể chạy **song song** trong cùng wave:

```json
{
  "agents": {
    "parallelization": true,
    "max_parallel": 3,
    "max_retries": 2
  }
}
```

### Error Escalation

```
Task fails → retry (same agent, up to max_retries)
  → Retry fails → Debugger agent
    → Debugger fails → log + notify user
      → 3+ retries on same wave → flag ARCHITECTURAL ISSUE → stop + notify
```

---

## 📚 116 Skills

Skills là các chuyên môn domain mà Antigravity IDE tự động discover và áp dụng. Tổ chức thành **14 categories**:

| Category | Skills | Ví dụ |
|----------|--------|-------|
| **ai/** | 8 | RAG pipelines, prompt engineering, LLM applications, MCP tools |
| **architecture/** | 10 | DDD, C4 diagrams, microservices, saga patterns, monorepo |
| **backend/** | 5 | NestJS, Django, FastAPI, Laravel, Node.js |
| **frontend/** | 7 | React, Next.js, Angular, Tailwind, accessibility |
| **mobile/** | 2 | Flutter/Dart, React Native |
| **languages/** | 15 | TypeScript, Python, Go, Rust, Java, C#, C++, Kotlin, Ruby... |
| **testing/** | 8 | TDD, E2E, Playwright, pytest, bug finding |
| **security/** | 6 | DevSecOps, OWASP, authentication, secrets management |
| **database/** | 8 | PostgreSQL, Prisma, GraphQL, API design, OpenAPI |
| **devops/** | 9 | Docker, Kubernetes, CI/CD, Git, monitoring |
| **data/** | 6 | Data engineering, finance, scraping, quantitative analysis |
| **workflow/** | 11 | Planning, research, multi-agent orchestration |
| **quality/** | 21 | Code quality, documentation, debugging, developer tools |

### Cách hoạt động

1. Antigravity IDE tự động quét `.agent/skills/` khi mở project
2. Keyword matching: khi task liên quan đến "React" → skill `react-patterns` được activate
3. Skill cung cấp best practices, patterns, và conventions cho agent đang thực thi
4. Usage log ghi lại **tên skill cụ thể** (không phải category) để tracking

### SKILL-INDEX.md

Bảng tra cứu nhanh keyword → skill:
```
React hooks → react-patterns
Flutter state → flutter-expert
API security → api-security-hardening
Docker compose → docker-containerization
```

---

## 🔌 3 MCP tích hợp

MCP (Model Context Protocol) mở rộng khả năng của AI bằng cách kết nối với external tools.

### Serena — Symbolic Tools + Memory

| Khả năng | Tool | Mô tả |
|----------|------|-------|
| **Code analysis** | `get_symbols_overview()` | Hiểu cấu trúc file không cần đọc toàn bộ |
| **Symbol search** | `find_symbol()` | Tìm class/function/method theo pattern |
| **Targeted edit** | `replace_symbol_body()` | Sửa chính xác một method mà không đọc cả file |
| **Rename** | `rename_symbol()` | Rename across codebase |
| **Impact analysis** | `find_referencing_symbols()` | Kiểm tra breaking changes |
| **Agent memory** | `write/read/edit_memory()` | Giao tiếp liên agent qua shared memory |
| **Reasoning** | `think_about_*()` | Self-check trước khi commit |

> **Fallback**: Nếu Serena không khả dụng → fall back sang file-based operations.

### Context7 — Library Documentation

| Khả năng | Tool | Mô tả |
|----------|------|-------|
| **Resolve** | `resolve-library-id()` | Tìm library ID từ tên |
| **Query** | `query-docs()` | Tra cứu API docs mới nhất |

**Khi nào dùng:**
- Import library mới → auto-invoke tra docs
- Unsure về API → query specific method
- Version mismatch → check breaking changes

> **Fallback**: Nếu Context7 không khả dụng → dùng training knowledge.

### Pencil — IDE-Native Vector Design

| Khả năng | Tool | Mô tả |
|----------|------|-------|
| **Design** | `batch_design()` | Tạo/sửa/xóa design elements trong `.pen` file |
| **Read** | `batch_get()` | Đọc components, search patterns, inspect hierarchy |
| **Preview** | `get_screenshot()` | Render preview image để verify visual |
| **Analyze** | `snapshot_layout()` | Phân tích layout, detect overlap/spacing |
| **Tokens** | `get/set_variables()` | Đọc/cập nhật design tokens ↔ CSS vars |
| **Export** | `export_nodes()` | Export sang PNG/JPEG/WEBP/PDF |

**Flow trong `/design`:**
1. Tạo/mở `.pen` file → design elements → user review → iterate
2. `get_variables()` → extract design tokens → save to `design-system.md`
3. AI reads `.pen` → generates code reference (React/Vue/Svelte/HTML)

> **Fallback**: Nếu Pencil không khả dụng → ASCII wireframes + manual tokens.

---

## 📋 Shared Protocols

14 protocols dùng chung giữa tất cả agents (`_shared/`):

| Protocol | Mục đích |
|----------|----------|
| **bilingual-protocol.md** | Quy tắc ngôn ngữ: VN giao tiếp, EN code |
| **behavioral-rules.md** | Kỷ luật file, security, quality |
| **context-loading.md** | Load context theo priority (Always/Conditional/On-Demand) |
| **memory-protocol.md** | Quy tắc đọc/ghi memory files |
| **mcp-protocol.md** | Hướng dẫn sử dụng 3 MCP servers |
| **quality-gates.md** | Tiêu chí chất lượng phải đạt |
| **security-protocol.md** | Input validation, secrets detection, pre-commit scan |
| **requirements-elicitation.md** | 3 loại hỏi đáp: scope, implementation, content |
| **skill-routing.md** | Mapping task type → agent + skill |
| **session-metrics.md** | Metrics tracking per session |
| **evidence-first.md** | Evidence before claims — verify trước khi báo cáo |
| **skill-enforcement.md** | Bắt buộc đọc skill trước mỗi task |
| **structured-memory.md** | Memory types chuẩn: DECISION/PATTERN/ERROR/INSIGHT/CONVENTION |
| **parallel-dispatch.md** | Quy tắc thực thi song song nhiều agents |

---

## 🧠 Self-Learning (Reasoning Bank v2)

Nexus tự học từ mỗi task đã hoàn thành thông qua **Reasoning Bank v2** (`.nexus/memory/reasoning-bank.json`).

### Cách hoạt động

```
                    ┌─────────────────┐
   Task completed   │  Record Pattern │
   ─────────────►   │  • approach     │
                    │  • outcome      │
                    │  • confidence   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
   /learn extracts  │  Evolution Log  │
   ─────────────►   │  • evidence     │
                    │  • confidence∆  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
   /evolve clusters │  Amend Skills   │
   ─────────────►   │  • cluster      │
                    │  • suggest      │
                    │  • user review  │
                    └─────────────────┘
```

### Pattern Structure (v2)

```json
{
  "id": "P001",
  "description": "Service bridge null check",
  "approach_summary": "Add null guard before bridge call",
  "outcome": "success",
  "confidence": 0.85,
  "tags": ["flutter", "bridge", "null-safety"],
  "reuse_count": 3,
  "evolution_log": [{"date": "2026-01-15", "event": "created", "evidence": "..."}],
  "skill_candidate": true
}
```

### Auto-Prune & Evolution

- Patterns tự động được dọn dẹp khi `confidence < 0.2` hoặc `age > prune_days`
- `/learn` tự động chạy cuối mỗi `/end` để extract patterns mới
- `/evolve` cluster patterns → suggest amendments cho skills hiện có
- Configurable qua `nexus.json → performance` và `nexus.json → evolution`

---

## ⚙️ Cấu hình

File `nexus.json` tại root project:

### Các section chính

| Section | Mục đích | Key settings |
|---------|----------|-------------|
| `bilingual` | Ngôn ngữ | `user_language: "vi"`, `technical_language: "en"` |
| `workflow` | Hành vi workflow | `mode`, `plan_check`, `verifier`, `guide` |
| `elicitation` | Mức độ hỏi đáp | `depth: "thorough" / "balanced" / "quick"` |
| `agents` | Agent config | `parallelization`, `max_retries`, `turn_limits` |
| `memory` | Memory provider | `provider: "serena"`, `base_path` |
| `serena` | Serena settings | `symbolic_tools`, `thinking_tools` |
| `maintenance` | Logging | `track: ["agents", "skills", "workflows", "memory", "mcp"]` |
| `git` | Git settings | `atomic_commits`, `commit_docs` |
| `performance` | Limits | `max_file_lines`, `reasoning_bank_max_patterns` |
| `evolution` | Skill evolution | `auto_learn_on_end`, `confidence_decay_days`, `min_cluster_size` |
| `health_checks` | Health check flags | 7 boolean flags |

### Parallelization Config

Nexus hỗ trợ thực thi song song agents trong cùng wave — cấu hình qua `agents.parallelization`, `agents.max_parallel`, `agents.max_retries`.

### Elicitation Depths

| Depth | Mô tả | Khi nào |
|-------|-------|---------|
| **thorough** | Hỏi chi tiết tất cả — user chỉ định mọi thứ | First-time setup |
| **balanced** | AI đề xuất + user duyệt | Mặc định |
| **quick** | AI đề xuất, chỉ hỏi khi mơ hồ | Speed runs |

---

## 🚀 Cài đặt

### Prerequisites

- **Antigravity IDE** (bắt buộc)
- **PowerShell** (Windows)
- **Node.js** (cho Context7 MCP)
- **uv** (cho Serena MCP)

### Cài đặt nhanh

```powershell
# Cài Nexus vào dự án hiện tại
H:\Kit\Nexus\install.ps1

# Chỉ định đường dẫn dự án
H:\Kit\Nexus\install.ps1 -ProjectPath "D:\MyProject"

# Ghi đè nếu đã cài trước đó
H:\Kit\Nexus\install.ps1 -Force
```

### Installer thực hiện 4 bước

| Bước | Hành động |
|------|----------|
| **1. Dependencies** | Kiểm tra Node.js, uv, npx |
| **2. MCP Config** | Kiểm tra + cấu hình Serena, Context7, Pencil trong Antigravity settings |
| **3. Copy Framework** | Copy `.agent/`, `GEMINI.md`, `nexus.json` vào project |
| **4. Hướng dẫn** | Hiện next steps |

### Sau khi cài

1. Mở project trong Antigravity IDE
2. Chạy `/init` → AI hỏi đáp, tạo `.nexus/`, thiết lập lộ trình
3. Bắt đầu phát triển theo guide

---

## 📖 Sử dụng

### Dự án mới — Full Lifecycle

```
Bước 1: /init                    # Khởi tạo — AI hỏi đáp về dự án
Bước 2: /design 1                # Thiết kế UI/UX cho phase 1
Bước 3: /plan 1                  # Tạo kế hoạch thực thi
Bước 4: /execute 1               # Thực thi code theo plan
Bước 5: /verify 1                # Kiểm tra kết quả
Bước 6: /review                  # Quality review
Bước 7: /plan 2                  # Lặp lại cho phase tiếp theo
```

### Task nhỏ / Bug fix

```
/quick                            # Xử lý nhanh không cần full lifecycle
```

### Quản lý phiên

```
/start                            # Đầu phiên — khôi phục context
/end                              # Cuối phiên — lưu state + handover
```

### Theo dõi & bảo trì

```
/progress                         # Xem tiến độ + guide
/health                           # Kiểm tra sức khỏe framework
/guide                            # Hướng dẫn bước tiếp theo
```

### Usage Log

Mỗi workflow tự động ghi log theo format bảng chuẩn:

```markdown
## [2026-03-06 15:30] Execute — Phase 1

| Loại | Đã sử dụng |
|---|---|
| **Agents** | executor, debugger |
| **Skills** | react-patterns, typescript-strict |
| **Workflows** | execute.md |
| **Memory** | write: task-board.md, progress-executor.md |
| **MCP Tools** | Context7: query-docs, Serena: find_symbol |
| **Protocols** | bilingual, behavioral-rules, mcp-protocol |

**Kết quả**: 4/4 tasks | 1 error | 3 commits
**Thời gian**: ~25 phút

### Chi tiết Tasks
| # | Task | Trạng thái | Sự cố & Fix |
|---|------|-----------|-------------|
| 1 | Setup routing | ✅ | — |
| 2 | Login page | ✅ | — |
| 3 | Dashboard | ✅ | Import path sai → fix |
| 4 | API integration | ✅ | — |
```

---

## 🔧 Bảo trì & Health Check

### Health Check (`/health`)

Kiểm tra **nội bộ framework** — không phải dự án:

| Kiểm tra | Nội dung |
|----------|----------|
| **Config Integrity** | nexus.json valid, GEMINI.md sync, critical files tồn tại |
| **MCP Connectivity** | Test kết nối + function cho Serena, Context7, Pencil |
| **Workflow Compliance** | Log format đúng, workflow coverage, lifecycle sequence |
| **Agent Balance** | Load distribution, red flags (overloaded, unused agents) |
| **Skill Usage** | Naming compliance, category coverage |
| **Reasoning Bank** | Pattern count, success rate, stale ratio |
| **Storage** | File count, log size |

### Khi nào chạy Health Check

- Sau khi cài framework vào dự án mới
- Khi nghi ngờ framework hoạt động sai
- Định kỳ sau mỗi 3-5 sessions
- Trước khi release version mới

---

## 📄 Giấy phép

MIT
