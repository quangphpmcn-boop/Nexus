---
description: Khởi đầu phiên làm việc — kiểm tra môi trường, MCP, đăng ký Serena, khôi phục context
---

# /nexus:start — Khởi Đầu Phiên Làm Việc

## When to Run
- Mỗi khi bắt đầu làm việc trên máy mới (nhà ↔ cơ quan)
- Khi mở dự án sau thời gian dài
- Phiên đầu tiên trong ngày

## Prerequisites
- Dự án đã có `.nexus/` (đã chạy `/init` trước đó)

## Steps

### Step 1: Environment Check

Đọc `.nexus/project.md` → xác định tech stack → kiểm tra tools:

```
Với mỗi tech trong stack:
  → Chạy [command] --version
  → Có: ✅ [version]
  → Không: ❌ Thiếu [tool] — hướng dẫn cài
```

Ví dụ kiểm tra phổ biến:

| Tech Stack | Commands kiểm tra |
|------------|-------------------|
| Flutter/Dart | `flutter --version`, `dart --version` |
| Python | `python --version`, `pip --version` |
| Node.js | `node --version`, `npm --version` |
| TypeScript | `npx tsc --version` |
| Rust | `rustc --version`, `cargo --version` |
| Go | `go version` |
| Java | `java --version`, `javac --version` |

> Chỉ kiểm tra tools liên quan đến tech stack của dự án, KHÔNG kiểm tra tất cả.

Nếu thiếu tool bắt buộc → cảnh báo và hướng dẫn cài, có thể dừng resume.

### Step 2: MCP Health Check

Kiểm tra từng MCP server:

| MCP | Cách kiểm tra | Kết quả |
|-----|--------------|---------|
| **Serena** | Gọi `get_current_config` | ✅ Active / ❌ Unavailable |
| **Context7** | Gọi `resolve-library-id` với query đơn giản | ✅ Active / ❌ Unavailable |
| **Pencil** | Gọi `get_editor_state` | ✅ Active / ❌ Unavailable |

Hiện bảng status:

```
━━━ 🔌 MCP STATUS ━━━
  Serena   ✅ Active
  Context7 ✅ Active
  Pencil   ❌ Unavailable
━━━━━━━━━━━━━━━━━━━━━
```

> MCP không phải bắt buộc. Nếu unavailable → ghi nhận và tiếp tục. Framework có fallback cho tất cả MCP.

### Step 3: Serena Project Registration

Nếu Serena active (từ Step 2):

1. Gọi `activate_project` với đường dẫn dự án hiện tại
2. Gọi `check_onboarding_performed`
   - Nếu chưa onboarding → gọi `onboarding`
   - Nếu đã onboarding → bỏ qua
3. Xác nhận ngôn ngữ Serena nhận diện đúng tech stack

> Nếu Serena unavailable → bỏ qua bước này.

### Step 4: Context Recovery

Đọc và tổng hợp trạng thái:

1. Đọc `.nexus/state.md` → vị trí, last session, next step
2. Đọc `.nexus/roadmap.md` → tiến độ tổng thể
3. Kiểm tra file `.nexus/session-handover.md`:
   - Nếu tồn tại → đọc và hiện cho user
   - Xóa file sau khi đã đọc (đã phục vụ mục đích)
4. **Memory read**: đọc `.nexus/memory/handover.md` (nếu tồn tại) → context từ Serena sync
5. **Memory list**: liệt kê files trong `.nexus/memory/` → hiện cho user biết memory state
6. **Reasoning Bank check**: đọc `.nexus/memory/reasoning-bank.json` (nếu tồn tại) → hiện pattern count + success rate
7. **Evolution check**: nếu reasoning-bank có patterns với `skill_candidate: true` ≥ 3:
   - Gợi ý: "🧬 Có {N} patterns sẵn sàng evolve. Chạy `/evolve` trước khi bắt đầu phase mới."

Hiện báo cáo phục hồi:

```
━━━ 🔄 PHỤC HỒI PHIÊN ━━━

📍 Vị trí: Phase [X]/[Y] — [Phase Name]
📅 Phiên trước: [date] | Máy: [machine]
🛑 Dừng tại: [description]

📋 Handover notes:
  [nội dung session-handover.md nếu có]

🗃️ Memory files: [N] files (task-board, progress, etc.)
🧠 Reasoning Bank: [N] patterns | {success_rate}% success rate
🧬 Skill Candidates: [M] patterns sẵn sàng evolve [nếu M ≥ 3: "→ Chạy /evolve"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 5: Guide → Next Steps

Invoke `guide.md` → hiện bước tiếp theo dựa trên state.

## Output

```
━━━ ✅ PHIÊN LÀM VIỆC SẴN SÀNG ━━━

🖥️ Môi trường: [X]/[Y] tools ✅
🔌 MCP: Serena ✅ | Context7 ✅ | Pencil ❌
📍 Vị trí: Phase [X] — [Phase Name]

▶ Bước tiếp: [suggestion from guide]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
