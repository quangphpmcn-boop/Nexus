---
description: Thực thi phase — chạy kế hoạch theo thứ tự wave với đa agent song song
---

# /nexus:execute [phase_number] — Phase Execution

## Prerequisites
- Read `.nexus/state.md` → confirm ready to execute
- Read `.nexus/phases/phase-{N}/wave-structure.md` → get execution order
- Read `.agent/agents/_shared/bilingual-protocol.md` → language rules
- Read `.agent/agents/_shared/behavioral-rules.md` → file discipline, security, quality rules
- Read `.agent/agents/_shared/security-protocol.md` → input validation, secrets detection, pre-commit scan
- Read `.agent/agents/_shared/memory-protocol.md` → memory read/write rules
- Read `.agent/agents/_shared/mcp-protocol.md` → Serena for progress tracking, Context7 for library docs

## Steps

### Step 1: Load Plans
Discover all plans in `.nexus/phases/phase-{N}/`:
- Parse wave assignments
- Verify all plans exist and are valid
- Check if any plans already completed (resume support)
- **Memory read**: đọc `.nexus/memory/task-board.md` (nếu tồn tại) → biết plans nào đã chạy, plans nào chờ

**Initialize tracking checklist** (duy trì suốt quá trình):
```
TRACKING (cập nhật liên tục):
□ Agents: []
□ Skills: [] ⛔ KHÔNG ghi "nexus" — ghi domain skill (xem cuối usage-logger.md)
□ MCP Tools: []
□ Memory: []
□ Protocols: [bilingual, mcp-protocol]
□ Sự cố: []
```

### Step 1.5: Query Intelligence (Reasoning Bank)

Trước khi bắt đầu execute, query reasoning bank để tận dụng patterns đã học:

1. **Read** `.nexus/memory/reasoning-bank.json` (nếu tồn tại)
2. **Match** task descriptions từ current plans against existing `patterns[]`:
   - So khớp `domain` + `tags` với tech stack của plan
   - Lọc patterns có `confidence >= 0.7` và `outcome == "success"`
3. **If matches found**:
   - Hiển thị: "🔎 Pattern match: [P{id}] — {approach_summary} (confidence: {score})"
   - Increment `reuse_count` của matched pattern
   - Agent SHOULD consider matched approach (không bắt buộc follow)
4. **If no matches**: proceed normally — no delay

> Pattern match là **gợi ý**, không phải bắt buộc. Agent tự quyết định có áp dụng hay không.

### Step 2: Execute Waves Sequentially

For each wave (in order):

#### 2a. Pre-wave Check
- All previous wave plans completed? → Proceed
- Any blockers from previous wave? → Report and ask user

#### 2b. Execute Plans in Wave (Parallel if enabled)
For each plan in current wave:

1. **Load plan** — read XML structure
2. **Context7 Lookup (BẮT BUỘC nếu dùng thư viện ngoài)**:
   - Scan task description → xác định thư viện/framework bên ngoài sẽ dùng (vd: Tauri API, TanStack Table, Shadcn, python-docx, openpyxl...)
   - **Nếu có thư viện ngoài** → gọi `resolve-library-id` + `query-docs` để verify API chính xác
   - **Ưu tiên tra cứu khi**: dùng API lần đầu, version mới, plugin ít phổ biến, hoặc API có breaking changes
   - **Được bỏ qua khi**: HTML/CSS/JS thuần, logic nghiệp vụ nội bộ, CRUD patterns cơ bản không dùng thư viện đặc biệt
   - → **Track** vào MCP Tools checklist: `context7 ({library}: {query summary})`
3. **Select agent** — use `skill-routing.md` to pick appropriate agent → **track agent name**
4. **Compose prompt** — use `.agent/orchestration/subagent-prompt.md`
5. **Execute tasks** — iterate through `<task>` elements → **track skills/MCP tools used**
6. **Verify each task** — run `<verify>` step
7. **Commit** — atomic commit per task (if `git.atomic_commits`)

> **ON TASK VERIFY FAIL** → Thêm vào tracking "Sự cố", retry.

> **ON BACKTRACK** (sửa code vừa viết) → Thêm vào tracking "Sự cố".

> **ON STUCK** (phải hỏi user) → Thêm vào tracking "Sự cố".

> **ON RETRY > 1** → Thêm vào tracking "Sự cố".

#### 2c. Post-wave Verification
- All plans in wave completed?
- Any failures? → retry up to `agents.max_retries`
- Still failing? → ask user
- **Memory write**: ghi `.nexus/memory/progress-executor.md` — status, percent, last action
- **Memory write**: ghi `.nexus/memory/results-{phase}-{wave}.md` — plans completed, errors, files changed

#### 2d. Scope Guard (Post-wave)

> Inspired by Rune `scope-guard`. Phát hiện scope creep sau mỗi wave.

1. **Collect planned files**: liệt kê exact file paths từ plan XML (`<task>` file paths)
2. **Collect actual changes**: `git diff --stat HEAD` + `git diff --stat --cached`
3. **Compare**:
   - **IN_SCOPE**: file khớp plan hoặc là dependency tự nhiên (test files, lockfiles, config)
   - **OUT_OF_SCOPE**: file không có trong plan, không phải dependency
4. **Whitelist** (luôn IN_SCOPE): `*.lock`, `package-lock.json`, test files cho planned sources, `.nexus/*`
5. **Report**:
   - 0 out-of-scope → skip silently
   - 1-2 out-of-scope → `⚠️ Minor scope change: [files]. Intentional?`
   - 3+ out-of-scope → `🔴 Significant scope creep detected: [files]. Review before continuing.`
6. **Advisory only** — warn user, KHÔNG block execution

> Overhead: ~200 tokens. Skip nếu không có git hoặc chưa có commits.

### Step 3: Create Summaries
For each completed plan:
- Generate `phase-{N}-{M}-SUMMARY.md` from `.agent/templates/summary.md`
- Record decisions made, issues encountered

### Step 3.5: Enrich Summaries with Serena (if available)
If Serena is active, use symbolic tools to enrich summaries:
- `search_for_pattern(regex)` — find all modified patterns across files
- `git diff` — get precise list of all files changed and code modifications
- Append to execution summaries for accurate documentation

> Skip if Serena is not available — manual summaries from Step 3 are sufficient.

### Step 3.7: Record Patterns (Reasoning Bank)

Sau khi hoàn thành tất cả plans:

1. **For each completed task**, extract pattern entry:
   ```json
   {
     "id": "P{auto-increment}",
     "domain": "{tech domain from plan — e.g. flutter-ui, python-backend}",
     "task_type": "{feature|bugfix|refactor|performance}",
     "description": "{task name from plan}",
     "approach_summary": "{1-line summary of approach taken}",
     "outcome": "{success|partial|failure}",
     "confidence": "{0.0-1.0 based on verify result}",
     "tags": ["{relevant keywords}"],
     "created": "{YYYY-MM-DD}",
     "reuse_count": 0
   }
   ```
2. **Append** to `.nexus/memory/reasoning-bank.json` → `patterns[]`
3. **Update stats**: recalculate `total_patterns`, `success_rate`, `top_domains`
4. **Auto-prune** (nếu `total_patterns > nexus.json → performance.reasoning_bank_max_patterns`):
   - Remove patterns với `reuse_count == 0` + `confidence < 0.5` + age > `prune_days`

> Nếu `.nexus/memory/reasoning-bank.json` chưa tồn tại → copy từ `.agent/templates/reasoning-bank.json`

### Step 4: Finalize Usage Log (BẮT BUỘC — KHÔNG BỎ QUA)

Tổng hợp tracking checklist → ghi vào `.nexus/logs/usage-log.md`.

> **Format**: Theo ĐÚNG format trong `.agent/maintenance/usage-logger.md`.
> **Self-check**: 6 fields bảng? Bảng Chi tiết Tasks? Không prose? Skills ≠ "nexus"?

### Step 5: Update State
Update `.nexus/state.md`:
- Current position (plan X of Y)
- Progress bar
- Performance metrics
- Session continuity

**Memory update**: cập nhật `.nexus/memory/task-board.md` — mark completed plans `[x]`, update timestamps.

### Step 6: Guide → Next Steps
Invoke `guide.md`:
- If phase complete → suggest `/nexus:verify [phase]`
- If more waves remaining → show progress and suggest continue
- If errors → suggest `/nexus:quick` to fix before continuing

## Output
- All plans in phase executed
- Summaries generated
- Usage logged (with full detail)
- State updated
