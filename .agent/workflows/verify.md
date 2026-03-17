---
description: Xác minh công việc hoàn thành — kiểm tra tự động + nghiệm thu người dùng
---

# /nexus:verify [phase_number] — Phase Verification

## Iron Law

> **NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**
> Đọc `evidence-first.md` — mọi claim PHẢI có evidence (command output, test result).

## Prerequisites
- Load profile: **review** (xem `context-loading.md`)
- Read `.nexus/requirements.md` → acceptance criteria
- Read `_shared/skill-enforcement.md` → skill check
- Read `_shared/behavioral-rules.md` → file discipline, code integrity
- **Memory read**: `.nexus/memory/results-{phase}-{wave}.md` (nếu tồn tại)

## Steps

### Step 1: Requirement Coverage Check
For each requirement in this phase:
- [ ] Has at least one completed plan covering it
- [ ] Plan summary confirms requirement addressed
- [ ] No gaps between requirement and implementation

**Initialize tracking:**
```
TRACKING: Agents: [reviewer] | Skills: [] ⛔ KHÔNG "nexus" | MCP Tools: [] | Sự cố: []
```

### Step 1.5: Auto-Detect Test Commands (Pre-Verify Hook)

Tự động phát hiện cách chạy test/build/lint từ project config:

| File | Check for | Command |
|------|-----------|----------|
| `package.json` | `scripts.test`, `scripts.build`, `scripts.lint` | `npm run test/build/lint` |
| `pubspec.yaml` | Flutter project | `flutter analyze`, `flutter test` |
| `pyproject.toml` | pytest/ruff config | `pytest`, `ruff check .` |
| `Makefile` | `test`, `build`, `lint` targets | `make test/build/lint` |
| `Cargo.toml` | Rust project | `cargo test`, `cargo clippy` |

> Nếu không tìm thấy config → dùng commands từ plan `<verification>` section. Nếu plan cũng không có → hỏi user.

### Step 2: Automated Verification (Evidence Required)
Run verification steps from each plan's `<verification>` section:
- Build check (compiles without errors)
- Test execution (all tests pass)
- Lint check (no new warnings)

**Evidence Rule:** Mỗi check PHẢI:
1. **RUN** command (fresh, complete — không dùng cache)
2. **READ** full output + exit code
3. **CITE** output khi claim pass/fail

> ⛔ "Should pass" = KHÔNG CHẤP NHẬN. Phải có output.

> **ON VERIFY FAIL** → Thêm vào tracking "Sự cố" trước khi tiến hành fix.

### Step 3: Cross-Plan Integration Check
Verify plans work together:
- No conflicting file changes
- API contracts match between consumer and provider
- No broken imports or references
- If design exists: UI matches wireframes, design tokens, responsive breakpoints

**Context7 API Verification** (BẮT BUỘC nếu code dùng thư viện ngoài):
- Với thư viện chính trong phase → gọi `resolve-library-id` + `query-docs`
- So sánh API usage trong code vs docs hiện tại → phát hiện deprecated/breaking changes
- Track vào MCP Tools: `context7 ({library}: API verification)`

### Step 4: Quality Gate
Invoke Reviewer agent → **track agent**:
- Code quality review on changed files
- Security quick scan
- Performance review (if applicable)
- Accessibility review (if applicable)

### Step 5: Gap Analysis
Identify any gaps:
- Requirements partially implemented → create follow-up plan
- Edge cases uncovered → add to requirements
- Technical debt introduced → log as todo

> Gaps found → document in gap analysis for future phases.

### Step 5.5: Claim Audit (BẮT BUỘC — v2.1)

> Inspired by Rune `completion-gate`. Kiểm chứng mọi claims bằng evidence.

1. **Thu thập claims**: liệt kê tất cả claims agent đã phát biểu (tests pass, build ok, fixed...)
2. **Match evidence**: với mỗi claim → tìm command output tương ứng (stdout từ Bash)
3. **Tạo Claim Audit table** theo format trong `evidence-first.md` → "Claim Audit Template"
4. **Evaluate**:
   - ALL CONFIRMED → proceed to Step 6
   - ANY UNCONFIRMED → run missing verification, cập nhật table
   - ANY CONTRADICTED → fix trước, re-verify

> Claim Audit table PHẢI được trình bày trong Step 6 (User Acceptance).

### Step 5.7: Score Patterns (Reasoning Bank)

Cập nhật reasoning-bank patterns dựa trên kết quả verify:

1. **Read** `.nexus/memory/reasoning-bank.json`
2. **For each pattern** được tạo trong phase này (từ execute Step 3.7):
   - Verify passed → `confidence = max(confidence, 0.8)`, `outcome = "success"`
   - Verify failed → `confidence = min(confidence, 0.4)`, `outcome = "failure"`
   - Partial pass → `confidence = 0.6`, `outcome = "partial"`
3. **Update** stats: recalculate `success_rate`

> Nếu reasoning-bank chưa tồn tại → skip.

### Step 6: User Acceptance (Present Evidence)
Present results to user (in `user_language`):
- Summary of what was built
- **Verification evidence**: test output, build log, lint results (không chỉ summary)
- Any gaps found
- Ask for sign-off

> User PHẢI thấy evidence cụ thể — không chỉ "tests pass" mà phải kèm output.

**Memory write**: ghi `.nexus/memory/verification-report.md` theo schema từ `memory-schema.md` (requirements coverage, automated checks, gaps, verdict).

### Step 7: Phase Transition
If user accepts:
- Mark phase complete in `roadmap.md`
- Update `state.md` → next phase
- Update progress bar
- Clear resolved blockers
- **Memory cleanup**: xóa memory files cũ của phase đã xong (`progress-*.md`, `results-*.md`, `task-board.md`) — theo rule "Clean up" trong memory-protocol

### Step 7.5: Finalize Usage Log (BẮT BUỘC)

Ghi vào `.nexus/logs/usage-log.md`.

> **Format**: Theo ĐÚNG format trong `.agent/maintenance/usage-logger.md`.
> **Self-check**: 6 fields bảng? Bảng Chi tiết? Không prose? Skills ≠ "nexus"?

### Step 8: Guide → Next Steps
Invoke `guide.md`:
- If more phases → suggest `/nexus:plan [next_phase]`
- If all phases done → suggest final review
- If gaps found → suggest `/nexus:quick` or next plan
- If recurring error patterns detected (Step 5.7) → suggest `/learn` to extract patterns thủ công
- If reasoning-bank has ≥ 3 skill candidates → suggest `/evolve` trước phase tiếp theo

## Output
- Verification report
- Phase marked complete (or gaps documented)
- State advanced to next phase
- Usage logged (full format)
