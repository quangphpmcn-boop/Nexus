---
description: Thiết kế UI/UX cho phase — multi-stage design (Foundation → Screens → Components) với phỏng vấn ý tưởng per screen
---

# /nexus:design [phase-number]

Design workflow — creates visual design artifacts before planning and coding.

## Position in Lifecycle

```
/nexus:init → /nexus:design → /nexus:plan → /nexus:execute → /nexus:verify → /nexus:audit → /nexus:review
                  →
            YOU ARE HERE
```

> Design runs AFTER init (requirements exist) and BEFORE plan (technical tasks).
> Not all phases need design — only phases with UI changes.

## Multi-Stage Design Process

Design chia thành **3 stages**, mỗi stage có phỏng vấn + review riêng:

```
Stage 1: Foundation Design  ─── 1 lần per project (hoặc major redesign)
  → Brand identity, design system, color + typography + spacing tokens

Stage 2: Screen Design  ─── lặp lại per screen/screen-group
  → Phỏng vấn ý tưởng → wireframe → user flow → review per screen

Stage 3: Component Design  ─── lặp lại per component-group
  → Phỏng vấn ý tưởng → component specs → interaction specs → review per group
```

> **Stage 1 chỉ cần chạy 1 lần** cho dự án (hoặc khi major redesign). Stage 2+3 chạy cho mỗi phase có UI.
> Nếu Foundation đã tồn tại từ phase trước → skip Stage 1, bắt đầu từ Stage 2.

## Prerequisites

- [ ] `.nexus/state.md` exists
- [ ] `.nexus/requirements.md` has requirements for this phase
- [ ] `.nexus/roadmap.md` shows this phase
- [ ] Read `.agent/agents/_shared/mcp-protocol.md` → use Pencil MCP for mockup generation
- [ ] Read `.agent/agents/_shared/bilingual-protocol.md` → language rules
- [ ] Read `.agent/agents/_shared/behavioral-rules.md` → file discipline, security, quality rules
- [ ] Read `.agent/agents/_shared/memory-protocol.md` → memory read/write rules

## Workflow Steps

### Step 1: Determine Scope

```
Read requirements for phase N
→ Has UI screens or user-facing changes?
  → YES: Continue
  → NO: Skip design, go to /nexus:plan

Check if Foundation exists (.nexus/design/design-system.md):
  → EXISTS: Skip Stage 1, start at Stage 2
  → NOT EXISTS: Start at Stage 1
```

### Step 2: Load Context

Read (in order):
1. `.nexus/requirements.md` — UI requirements for this phase
2. `.nexus/project.md` — Brand, vision, tech stack
3. Existing UI code (if redesign/evolution)
4. Previous phase design artifacts (if any)

> **⛔ FRESH DESIGN RULE**: Thiết kế dựa trên requirements và project.md của DỰ ÁN NÀY.
> - KHÔNG copy layout, color scheme, component structure từ dự án cũ qua KIs
> - KHÔNG giả định dự án mới muốn phong cách giống dự án trước
> - PHẢI phân tích project domain/audience/content TRƯỚC khi đề xuất style

### Step 3: User Research (5 min) — Chỉ lần đầu

Ask user (if not already defined):
- Ai là người dùng chính? (Who are the primary users?)
- Họ muốn đạt được gì? (What are their goals?)
- Có brand guidelines / design system sẵn không? (Existing brand/design system?)
- Preferences: dark/light mode, style (minimal/rich/corporate)?

Sau khi thu thập thông tin → chuyển sang Stage phù hợp.

**Initialize tracking:**
```
TRACKING: Agents: [designer] | Skills: [] ⛔ KHÔNG "nexus" | MCP Tools: [] | Sự cố: []
```

---

## Stage 1: Foundation Design (1 lần per project)

> Mục tiêu: Xác lập identity thiết kế cho toàn bộ dự án. Chạy 1 lần duy nhất.

### 1.1 Context Analysis

Phân tích project để tạo keywords thiết kế:

```
Inputs:
  - project.md → domain, audience, vision
  - requirements.md → loại app (desktop/web/mobile), tính năng chính
  - User Research → preferences, brand

Outputs:
  - Domain keywords (ví dụ: "military administrative", "beauty spa wellness", "fintech crypto")
  - Audience keywords (ví dụ: "professional enterprise", "young casual", "admin power-user")
  - Mood keywords (ví dụ: "serious trustworthy", "playful vibrant", "clean minimal")
```

### 1.2 Design Direction Proposals (BẮT BUỘC — KHÔNG hardcode)

```
1. Chạy ui-ux-pro-max → generate design system recommendations:
   python3 .agent/skills/frontend/ui-ux-pro-max/scripts/search.py "{keywords}" --design-system -p "{project_name}" -f markdown

2. Từ kết quả, tạo 2-3 Design Direction proposals:

   | Tiêu chí | Direction A | Direction B | Direction C |
   |----------|-------------|-------------|-------------|
   | Style | [tên style] | [tên style] | [tên style] |
   | Palette | [colors] | [colors] | [colors] |
   | Typography | [heading/body] | [heading/body] | [heading/body] |
   | Mood | [mô tả] | [mô tả] | [mô tả] |
   | Phù hợp khi | [context] | [context] | [context] |

   → AI khuyến nghị: Direction [X] vì [lý do dựa trên project context]
   → User chọn: ☐ A / ☐ B / ☐ C / ☐ Khác

3. ⛔ CẤM dùng giá trị mặc định cố định (như #2563EB, Inter)
   → Palette và font PHẢI được chọn dựa trên domain analysis
```

### 1.3 Anti-Repetition Check

```
Nếu KIs có design decisions từ dự án trước:
  → So sánh palette + font + style đề xuất vs 3 dự án gần nhất
  → Nếu trùng > 2/3 yếu tố → PHẢI đề xuất alternatives khác biệt
  → Giải thích cho user: "Style này khác [dự án cũ] ở [điểm X, Y, Z]"
```

### 1.4 Create Foundation Artifacts

Sau khi user chọn direction:

| Artifact | File | Content |
|----------|------|---------|
| Design System | `design-system.md` | Color tokens, typography, spacing, shadows, radius |
| Brand Guide | `brand-guide.md` | Tone of voice, visual principles, do's & don'ts |

Saved to: `.nexus/design/` (project-level, không phải per-phase)

### 1.5 Foundation Review

Present Foundation to user:
- Palette swatches với usage context
- Font pairing ví dụ
- Spacing scale
- Component style preview (border, shadow, radius)

Ask: "Bạn duyệt Foundation Design này không?"
Loop until approved → **Foundation locked** ✅

---

## Stage 2: Screen Design (per screen/screen-group)

> Mục tiêu: Wireframe + layout chi tiết cho từng screen. Chạy per screen hoặc nhóm screens liên quan.

### 2.0 Screen Inventory

Liệt kê tất cả screens dự kiến cho phase này:

```
Phase {N} — Screens cần thiết kế:
1. [Screen A] — [mô tả ngắn]
2. [Screen B] — [mô tả ngắn]
3. [Screen C] — [mô tả ngắn]
...

→ User xác nhận danh sách hoặc bổ sung
```

### 2.1 Screen Ideation Interview (per screen)

Read `_shared/requirements-elicitation.md` → apply **Loại 4: Design Ideation — Screen-Level**.

Với mỗi screen (hoặc nhóm screens liên quan):

```
1. Purpose: "Mục đích chính của [screen]? User đến đây để làm gì?"
2. Content: "Thông tin quan trọng nhất? Nội dung đặc biệt (charts, forms, tables)?"
3. Layout: Đề xuất 2-3 layout alternatives → user chọn
4. Interaction: "User tương tác chính là gì? Cảm giác mong muốn?"
5. References: "Có inspiration/reference nào bạn thích?"

→ Tổng hợp thành Screen Brief
→ User xác nhận → rồi mới wireframe
```

> Gom câu hỏi thành **1 block per screen** — không hỏi lẻ tẻ từng câu.

### 2.2 Create Screen Artifacts

Invoke **Designer agent** per screen:

| Artifact | File | Content |
|----------|------|---------|
| User Flows | `user-flows.md` | Mermaid flowcharts for user journeys (updated per screen) |
| Wireframes | `wireframes.md` | Wireframe per screen with annotations |
| Screen Briefs | `screen-briefs/{screen-name}.md` | Interview results + decisions per screen |

All files saved to: `.nexus/phases/phase-{N}/design/`

> **Context7**: Nếu dự án dùng component library (Fluent UI, Material, Ant Design...) → gọi Context7 tra cứu design tokens & component API trước khi tạo wireframe.

### 2.3 Screen Review (per screen/group)

Present each screen to user:
1. Screen brief recap
2. User flow cho screen
3. Wireframe với annotations

Ask: "Bạn duyệt wireframe cho [Screen X] không? Có gì cần thay đổi?"
Loop until approved per screen.

### 2.4 Update Design Brief (incremental)

Sau mỗi screen approved, cập nhật `design-brief.md`:
- Thêm screen vào priority list
- Update component needs
- Update responsive notes

---

## Stage 3: Component Design (per component-group)

> Mục tiêu: Chi tiết states, variants, interactions cho từng component. Chạy per component-group.

### 3.0 Component Grouping

Từ wireframes đã duyệt, nhóm components tự nhiên:

```
Component Groups:
1. Form Controls — Button, Input, Select, Checkbox, DatePicker, ...
2. Navigation — Sidebar, Tabs, Breadcrumb, Pagination, ...
3. Data Display — Table, Card, Badge, Tag, Avatar, ...
4. Feedback — Toast, Modal, Alert, Progress, Skeleton, ...
5. Overlays — Dialog, Drawer, Popover, Tooltip, ...
```

### 3.1 Component Ideation Interview (per group)

Read `_shared/requirements-elicitation.md` → apply **Loại 4: Design Ideation — Component-Level**.

```
Với mỗi component group:
1. Inventory: "Bạn cần components nào trong nhóm [group]?"
   → Đề xuất danh sách dựa trên wireframes
2. Behavior: "States cần thiết? Interaction đặc biệt? Responsive variants?"
   → Đề xuất based on context

→ Tổng hợp thành Component Brief
→ User xác nhận
```

### 3.2 Create Component Artifacts

| Artifact | File | Content |
|----------|------|---------|
| Component Inventory | `component-inventory.md` | All components + states + variants |
| Interaction Specs | `interaction-specs.md` | Animations, transitions, behaviors |
| Component Briefs | `component-briefs/{group-name}.md` | Interview results per group |

### 3.3 Component Review (per group)

Present component specs per group:
1. Component list with states
2. Interaction specs
3. Responsive behavior

Ask: "Bạn duyệt component specs cho nhóm [Group X] không?"
Loop until approved per group.

---

## Finalization

### Step F1: Generate Final Design Brief

After all stages approved, create/update `design-brief.md`:
- Screen priority list (from Stage 2)
- Component dependency order (from Stage 3)
- Design token reference (from Stage 1)
- Responsive breakpoint rules

This file is the **handoff artifact** — Planner reads it when creating technical plans.

### Step F2: Update State

```markdown
## State Update
- current_phase: N
- current_step: "design-complete"
- design_status: "approved"
- stages_completed: [foundation, screens, components]
- next_action: "/nexus:plan N"
```

### Step F3: Guide

```
━━━ 🧭 HƯỚNG DẪN TIẾP THEO ━━━

Phase {N}: {name} │ Design: ✅ Approved (3 stages)

▶ Thiết kế đã được duyệt. Các bước tiếp:

  1. /nexus:plan {N}   → Tạo kế hoạch kỹ thuật từ design (khuyến nghị)
  2. /nexus:design {N}  → Chỉnh sửa thiết kế nếu cần
  3. /nexus:review {N}  → Review thiết kế trước khi plan

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step F4: Finalize Usage Log (BẮT BUỘC)

Ghi vào `.nexus/logs/usage-log.md`.

> **Format**: Theo ĐÚNG format trong `.agent/maintenance/usage-logger.md`.
> **Self-check**: 6 fields bảng? Bảng Chi tiết? Không prose? Skills ≠ "nexus"?

## Design File Structure

```
.nexus/
├── design/                         # Project-level (Stage 1)
│   ├── design-system.md            # Color, typography, spacing tokens
│   └── brand-guide.md              # Visual principles, do's & don'ts
│
└── phases/phase-{N}/design/        # Phase-level (Stage 2 + 3)
    ├── user-flows.md               # Mermaid flow diagrams
    ├── wireframes.md               # Wireframes per screen
    ├── component-inventory.md      # Component list + states
    ├── interaction-specs.md        # Animation + behavior specs
    ├── design-brief.md             # Handoff artifact for Planner
    ├── screen-briefs/              # Per-screen interview results
    │   ├── dashboard.md
    │   ├── settings.md
    │   └── ...
    └── component-briefs/           # Per-group interview results
        ├── form-controls.md
        ├── navigation.md
        └── ...
```

## Integration with Antigravity Mode

| Antigravity Mode | Design Mapping |
|-----------|---------------|
| PLANNING | Step 1-2: Determine scope, load context |
| EXECUTION | Stage 1-3: Create design artifacts with user interviews |
| VERIFICATION | Finalization: Confirm all stages approved, update state |

## When to Skip Design

- Phase has **no UI changes** (backend-only, infra, data)
- Phase is a **bug fix** or **refactor** with no visual changes
- User explicitly says "bỏ qua design"

## When to Skip Stages

| Stage | Skip khi |
|-------|----------|
| Stage 1 (Foundation) | Foundation đã tồn tại từ phase trước |
| Stage 3 (Components) | Phase chỉ dùng components đã thiết kế ở phase trước, không có component mới |

## Related Workflows

- `/nexus:plan` — Reads design brief as input
- `/nexus:review` — Checks implementation against design specs
- `/nexus:init` — Creates requirements that feed into design
