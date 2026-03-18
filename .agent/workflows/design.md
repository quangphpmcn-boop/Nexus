---
description: Thiết kế UI/UX cho phase — multi-stage design (Foundation → Screens → Components → Mockup) với Taste-Skill + Pencil MCP
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

## Design Engine

```
┌─────────────────────────────────────────────────────┐
│ TASTE-SKILL (Tầng Triết lý - LUÔN HOẠT ĐỘNG)       │
│ Anti-slop · Creative Arsenal · Configurable Dials   │
│ AI Tells · Bias Correction · Motion Principles      │
├─────────────────────────────────────────────────────┤
│ PENCIL MCP (Tầng Visual - BẮT BUỘC)                │
│ 🎯 Gợi ý: style guide · guidelines · inspiration   │
│ 🖌️ Mockup: wireframes · components · full mockup    │
│ 🔍 Kiểm tra: screenshot · layout check · export     │
│ ⛔ Không có Pencil = DỪNG workflow → sửa MCP        │
├─────────────────────────────────────────────────────┤
│ UI-UX-PRO-MAX DB (Tầng Data - BỔ TRỢ)              │
│ CSV database · Python search · palette/font lookup  │
│ Pre-delivery checklist · accessibility rules        │
└─────────────────────────────────────────────────────┘
```

## Multi-Stage Design Process

```
Stage 0: MCP Readiness Check  ─── kiểm tra Pencil + Python
  → Pencil BẮT BUỘC — dừng nếu thiếu

Stage 1: Foundation Design  ─── 1 lần per project (hoặc major redesign)
  → Phỏng vấn sâu → Taste dials → Design system → Visual preview Pencil

Stage 2: Screen Design  ─── lặp lại per screen/screen-group
  → Phỏng vấn ý tưởng → Pencil wireframe → Anti-slop validation → review

Stage 3: Component Design  ─── lặp lại per component-group
  → Phỏng vấn → Pencil component library → interaction specs → review

Stage 4: Visual Mockup  ─── full-fidelity trong Pencil
  → Pencil full mockup → validation → export → handoff
```

> **Stage 1 chỉ cần chạy 1 lần** cho dự án (hoặc khi major redesign). Stage 2-4 chạy cho mỗi phase có UI.
> Nếu Foundation đã tồn tại → skip Stage 1, bắt đầu từ Stage 2.

## Prerequisites

- [ ] `.nexus/state.md` exists
- [ ] `.nexus/requirements.md` has requirements for this phase
- [ ] `.nexus/roadmap.md` shows this phase
- [ ] Read `.agent/skills/frontend/design-taste/SKILL.md` → core design rules
- [ ] Read `.agent/agents/_shared/mcp-protocol.md` → Pencil MCP tools
- [ ] Read `.agent/agents/_shared/bilingual-protocol.md` → language rules
- [ ] Read `.agent/agents/_shared/behavioral-rules.md` → quality rules
- [ ] Read `.agent/agents/_shared/memory-protocol.md` → memory rules

## Workflow Steps

### Step 0: MCP Readiness Check (BẮT BUỘC)

```
Step 0.1: Pencil MCP Health Check
  → Gọi get_editor_state()
  → SUCCESS: ✅ Tiếp tục
  → FAIL: ⛔ DỪNG WORKFLOW
    ┌──────────────────────────────────────────────┐
    │ ⛔ PENCIL MCP KHÔNG KHẢ DỤNG                 │
    │                                              │
    │ Design workflow yêu cầu Pencil MCP hoạt động │
    │ để tạo mockup và gợi ý thiết kế.             │
    │                                              │
    │ Kiểm tra:                                    │
    │  1. Pencil MCP config trong mcp_config.json  │
    │  2. Pencil MCP server đã khởi động chưa      │
    │  3. Editor state có accessible không          │
    │                                              │
    │ Sau khi sửa xong, chạy lại /design           │
    └──────────────────────────────────────────────┘
    → KHÔNG tiếp tục. KHÔNG tự mockup bằng HTML/image.

Step 0.2: Python Check (cho design database)
  → python3 --version || python --version
  → FAIL: Cảnh báo (không block) — AI dùng built-in knowledge

Step 0.3: Hiện Design Engine Status
  ┌─────────────────────────────────────┐
  │ 🎨 DESIGN ENGINE STATUS             │
  │                                     │
  │ Taste-Skill  ✅ Core (luôn active)  │
  │ Pencil MCP   ✅ Active (bắt buộc)  │
  │ Design DB    ✅/⚠️ [python status]  │
  │                                     │
  │ ▶ Sẵn sàng thiết kế                 │
  └─────────────────────────────────────┘
```

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
> - PHẢI phân tích project domain/audience/content TRƯỚC khi đề xuất style

### Step 3: User Research — Chỉ lần đầu

Câu hỏi cốt lõi:
- Ai là người dùng chính? Goals?
- Có brand guidelines / design system sẵn không?
- Dark/light mode preference?

Câu hỏi Taste Profile (MỚI):
```
5. Design Variance: "Bạn muốn layout..."
   □ Clean, chuẩn mực (1-3) — corporate, government
   □ Sáng tạo vừa phải (4-7) — startup, product
   □ Experimental (8-10) — creative, portfolio

6. Motion Intensity: "Mức animation..."
   □ Tĩnh (1-3) — admin, enterprise
   □ Mượt mà (4-7) — SaaS, consumer
   □ Cinematic (8-10) — landing, showcase

7. Visual Density: "Mật độ nội dung..."
   □ Thoáng đãng (1-3) — portfolio, luxury
   □ Cân bằng (4-7) — webapp, general
   □ Dày đặc (8-10) — dashboard, admin

8. Design Archetype: "Phong cách tổng thể..."
   □ Standard Premium (design-taste base)
   □ Minimalist Editorial (+ design-minimalist overlay)
   □ Awwwards-tier Luxury (creative arsenal max)
   □ Tùy chỉnh — mô tả thêm
```

Output: **Taste Profile**
```yaml
DESIGN_VARIANCE: [1-10]
MOTION_INTENSITY: [1-10]
VISUAL_DENSITY: [1-10]
ARCHETYPE: standard | minimalist | luxury | custom
SKILL_OVERLAY: [design-minimalist | none]
```

**Initialize tracking:**
```
TRACKING: Agents: [designer] | Skills: [design-taste] | MCP Tools: [pencil] | Sự cố: []
```

---

## Stage 1: Foundation Design (1 lần per project)

> Mục tiêu: Xác lập identity thiết kế. Chạy 1 lần duy nhất.

### 1.1 Context Analysis + Taste Configuration

```
Inputs:
  - project.md → domain, audience, vision
  - requirements.md → loại app, tính năng chính
  - User Research → Taste Profile (3 dials + archetype)

Actions:
  - Set DESIGN_VARIANCE, MOTION_INTENSITY, VISUAL_DENSITY
  - Load skill overlay (design-minimalist nếu chọn)
  - Apply Bias Correction rules từ design-taste

Outputs:
  - Domain keywords
  - Audience keywords
  - Mood keywords
  - Active Taste Profile
```

### 1.2 Design Direction Proposals (BẮT BUỘC — KHÔNG hardcode)

```
Bước 1 — Data lookup (design database — bổ trợ):
  IF PYTHON_AVAILABLE:
    → python3 .agent/skills/frontend/design-taste/scripts/search.py "{keywords}" --design-system -p "{project_name}" -f markdown
    → Lấy palette, font, style recommendations
  ELSE:
    → AI dùng built-in design-taste knowledge

Bước 2 — Creative filtering (design-taste — chủ đạo):
  → Apply AI Tells filter: loại bỏ kết quả generic
  → Apply Bias Correction: đảm bảo không trùng AI clichés
  → Apply Dials: filter theo DESIGN_VARIANCE/MOTION/DENSITY
  → Tạo 3 Direction Proposals qua lăng kính taste-skill

Bước 3 — Design inspiration (Pencil — gợi ý):
  → Pencil get_style_guide(tags) → visual inspiration
  → Pencil get_guidelines("web-app"/"mobile-app"/"landing-page") → layout best practices
  → Kết hợp Pencil inspiration + taste-skill filtering → refine 3 directions

Bước 4 — Visual preview (Pencil — mockup):
  → Tạo file foundation.pen
  → Pencil batch_design() → 3 visual direction mockups
  → Pencil get_screenshot() → render preview images

Bước 5 — User review:
  → Hiện 3 directions kèm hình preview từ Pencil
  → AI khuyến nghị Direction [X] vì [lý do]
  → User chọn → Lock direction

⛔ CẤM dùng giá trị mặc định cố định (như #2563EB, Inter)
   → Palette và font PHẢI được chọn dựa trên domain analysis
```

### 1.3 Anti-Repetition Check

```
Nếu KIs có design decisions từ dự án trước:
  → So sánh palette + font + style đề xuất vs 3 dự án gần nhất
  → Nếu trùng > 2/3 yếu tố → PHẢI đề xuất alternatives khác biệt
```

### 1.4 Create Foundation Artifacts

Sau khi user chọn direction:

| Artifact | File | Content |
|----------|------|---------|
| Design System | `design-system.md` | Color tokens, typography, spacing, shadows, radius |
| Brand Guide | `brand-guide.md` | Tone of voice, visual principles, do's & don'ts |
| Taste Profile | `taste-profile.yaml` | 3 dials + archetype + active overlays |
| Foundation Visual | `foundation.pen` | Pencil file: swatches, font samples, spacing scale |

Saved to: `.nexus/design/`

Pencil sync: `set_variables()` → đồng bộ design tokens vào `.pen` file

### 1.5 Foundation Review

Present Foundation to user:
- Pencil screenshots: palette swatches, font pairing, component style preview
- Spacing scale
- Active Taste Profile values

Ask: "Bạn duyệt Foundation Design này không?"
Loop until approved → **Foundation locked** ✅

---

## Stage 2: Screen Design (per screen/screen-group)

> Mục tiêu: Wireframe + layout chi tiết cho từng screen trong Pencil.

### 2.0 Screen Inventory

Liệt kê tất cả screens dự kiến cho phase này:

```
Phase {N} — Screens cần thiết kế:
1. [Screen A] — [mô tả ngắn]
2. [Screen B] — [mô tả ngắn]
...
→ User xác nhận hoặc bổ sung
```

### 2.1 Screen Ideation Interview (per screen)

Read `_shared/requirements-elicitation.md` → apply **Loại 4: Design Ideation — Screen-Level**.

```
Với mỗi screen:
1. Purpose: "Mục đích chính? User đến đây để làm gì?"
2. Content: "Thông tin quan trọng nhất? Nội dung đặc biệt?"
3. Layout: Đề xuất 2-3 layout alternatives (gợi ý từ Creative Arsenal)
   → Pencil get_guidelines() → layout suggestions per screen type
4. Interaction: "User tương tác chính? Cảm giác mong muốn?"
5. References: "Có inspiration nào bạn thích?"

→ Tổng hợp thành Screen Brief
→ User xác nhận → rồi mới wireframe
```

> Gom câu hỏi thành **1 block per screen** — không hỏi lẻ tẻ.
> Nhắc anti-patterns: chiếu theo AI Tells (tránh centered hero nếu DESIGN_VARIANCE > 4, etc.)

### 2.2 Create Screen Artifacts

Per screen:

| Artifact | File | Content |
|----------|------|---------|
| User Flows | `user-flows.md` | Mermaid flowcharts (updated per screen) |
| Wireframes | `wireframes.pen` | Pencil wireframe per screen |
| Screen Briefs | `screen-briefs/{screen-name}.md` | Interview results |

```
→ Pencil get_guidelines("web-app"/"mobile-app") → layout rules
→ Pencil batch_design() → wireframe .pen per screen
→ Apply design-taste rules trong thiết kế
→ Pencil get_screenshot() → preview cho review
```

> **Context7**: Nếu dự án dùng component library → tra cứu design tokens & component API.

### 2.3 Anti-Slop Validation (per screen)

```
Checklist tự động (từ design-taste Section 7):
  □ Không centered hero (nếu DESIGN_VARIANCE > 4)
  □ Không 3-column equal cards
  □ Không Inter/Roboto/Arial
  □ Không purple-blue AI gradient
  □ Không generic placeholder names
  □ Không emoji icons
  □ Content có organic data

IF vi phạm → tự fix trong Pencil trước khi review
```

### 2.4 Screen Review (per screen/group)

Present each screen to user:
1. Screen brief recap
2. User flow cho screen
3. Pencil screenshot với annotations

Ask: "Bạn duyệt wireframe cho [Screen X] không?"
Loop until approved per screen.

### 2.5 Update Design Brief (incremental)

Sau mỗi screen approved, cập nhật `design-brief.md`.

---

## Stage 3: Component Design (per component-group)

> Mục tiêu: Chi tiết states, variants, interactions. Tạo component library trong Pencil.

### 3.0 Component Grouping

Từ wireframes đã duyệt, nhóm components:

```
Component Groups:
1. Form Controls — Button, Input, Select, Checkbox, ...
2. Navigation — Sidebar, Tabs, Breadcrumb, ...
3. Data Display — Table, Card, Badge, Tag, Avatar, ...
4. Feedback — Toast, Modal, Alert, Progress, Skeleton, ...
5. Overlays — Dialog, Drawer, Popover, Tooltip, ...
```

### 3.1 Component Ideation Interview (per group)

Read `_shared/requirements-elicitation.md` → apply **Loại 4: Design Ideation — Component-Level**.

```
Với mỗi component group:
1. Inventory: "Bạn cần components nào?"
   → Đề xuất danh sách dựa trên wireframes
2. Behavior: "States? Interactions? Responsive variants?"
3. Motion: Áp dụng design-taste motion principles per component type
   → Nếu MOTION_INTENSITY > 5: thêm specs cho hover physics, spring animations

→ Tổng hợp thành Component Brief → User xác nhận
```

### 3.2 Create Component Artifacts

| Artifact | File | Content |
|----------|------|---------|
| Component Library | `components.pen` | Pencil reusable components |
| Component Inventory | `component-inventory.md` | All components + states + variants |
| Interaction Specs | `interaction-specs.md` | Animations, transitions, behaviors |
| Component Briefs | `component-briefs/{group-name}.md` | Interview results |

```
→ Pencil batch_design() → component library .pen (reusable)
→ Pencil get_screenshot() → render component states
```

### 3.3 Component Review (per group)

Present component specs per group:
1. Pencil screenshots: component list with states
2. Interaction specs
3. Responsive behavior

Ask: "Bạn duyệt component specs cho nhóm [Group X] không?"
Loop until approved per group.

---

## Stage 4: Visual Mockup (FULL FIDELITY)

> Mục tiêu: Full-fidelity mockup trong Pencil. Review cuối cùng trước handoff.

### 4.1 Full Mockup

```
→ Pencil batch_design() → compose full screens từ wireframes + components
→ Apply design tokens từ foundation.pen
→ Apply design-taste premium polish:
  - Generous whitespace (per VISUAL_DENSITY)
  - Depth and layering
  - Motion annotations (per MOTION_INTENSITY)
  - Realistic content (no AI Tells)
```

### 4.2 Validation

```
→ Pencil snapshot_layout() → detect overlap, spacing issues
→ Anti-slop final check (design-taste Section 7 — AI Tells)
→ Pre-delivery checklist (design-taste Section 8):
  - Accessibility: contrast, focus, alt text, keyboard
  - Touch: target size, cursor, feedback
  - Visual: no emoji, consistent icons, smooth transitions
  - Layout: responsive, no horizontal scroll, no hidden content
  - Light/Dark: contrast, transparency, borders
```

### 4.3 Review + Export

```
→ Pencil get_screenshot() → preview per screen
→ User review → iteration loop until approved
→ Pencil export_nodes(format="png") → design handoff images
→ Save to .nexus/phases/phase-{N}/design/mockups/
```

---

## Finalization

### Step F1: Generate Final Design Brief

After all stages approved, create/update `design-brief.md`:
- Screen priority list (from Stage 2)
- Component dependency order (from Stage 3)
- Design token reference (from Stage 1)
- Responsive breakpoint rules
- Mockup file references (from Stage 4)

This file is the **handoff artifact** — Planner reads it when creating technical plans.

### Step F2: Update State

```markdown
## State Update
- current_phase: N
- current_step: "design-complete"
- design_status: "approved"
- stages_completed: [foundation, screens, components, mockup]
- next_action: "/nexus:plan N"
```

### Step F3: Guide

```
━━━ 🧭 HƯỚNG DẪN TIẾP THEO ━━━

Phase {N}: {name} │ Design: ✅ Approved (4 stages)

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
│   ├── brand-guide.md              # Visual principles, do's & don'ts
│   ├── taste-profile.yaml          # Dials + archetype config
│   └── foundation.pen              # Pencil visual foundation
│
└── phases/phase-{N}/design/        # Phase-level (Stage 2-4)
    ├── user-flows.md               # Mermaid flow diagrams
    ├── wireframes.pen              # Pencil wireframes
    ├── components.pen              # Pencil component library
    ├── mockups.pen                 # Pencil full mockups
    ├── mockups/                    # Exported images from Pencil
    │   ├── screen-1.png
    │   └── ...
    ├── component-inventory.md      # Component list + states
    ├── interaction-specs.md        # Animation + behavior specs
    ├── design-brief.md             # Handoff artifact for Planner
    ├── screen-briefs/              # Per-screen interview results
    │   ├── dashboard.md
    │   └── ...
    └── component-briefs/           # Per-group interview results
        ├── form-controls.md
        └── ...
```

## Integration with Antigravity Mode

| Antigravity Mode | Design Mapping |
|-----------|---------------|
| PLANNING | Step 0-2: MCP check, scope, context |
| EXECUTION | Stage 1-4: Create design artifacts with user interviews |
| VERIFICATION | Finalization: Confirm all stages approved, update state |

## When to Skip Design

- Phase has **no UI changes** (backend-only, infra, data)
- Phase is a **bug fix** or **refactor** with no visual changes
- User explicitly says "bỏ qua design"

## When to Skip Stages

| Stage | Skip khi |
|-------|----------|
| Stage 1 (Foundation) | Foundation đã tồn tại từ phase trước |
| Stage 3 (Components) | Phase chỉ dùng components đã có, không component mới |
| Stage 4 (Mockup) | Phase là minor UI tweak, không cần full mockup |

## Related Workflows

- `/nexus:plan` — Reads design brief as input
- `/nexus:review` — Checks implementation against design specs
- `/nexus:init` — Creates requirements that feed into design
