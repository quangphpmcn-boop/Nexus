---
description: Nexus Framework — quy tắc bắt buộc cho mọi phiên làm việc
---

# Nexus Framework Rules

> **Lưu ý**: Rules chi tiết nằm ở `GEMINI.md` (root). File này bổ sung thêm workflow table và quy tắc cho AI reference.

Dự án này sử dụng **Nexus Framework** — framework phát triển agentic có cấu trúc cho Antigravity IDE.

## Chế độ Song ngữ
- Giao tiếp với tôi bằng **tiếng Việt**
- Code, commit messages, tên biến/hàm → **tiếng Anh**

## Vòng đời Workflow

| Lệnh | Mô tả | Antigravity Mode |
|-------|-------|--------------------|
| `/init` | Khởi tạo dự án | PLANNING |
| `/design [phase]` | Thiết kế UI/UX | ALL |
| `/plan [phase]` | Lập kế hoạch | PLANNING |
| `/execute [phase]` | Thực thi | EXECUTION |
| `/verify [phase]` | Xác minh | VERIFICATION |
| `/review [scope]` | Kiểm tra chất lượng | VERIFICATION |
| `/quick` | Tác vụ nhanh | EXECUTION |
| `/start` | Khởi đầu phiên làm việc | — |
| `/end` | Kết thúc phiên làm việc | — |
| `/progress` | Xem tiến độ | — |
| `/guide` | Hướng dẫn bước tiếp | — |
| `/health` | Kiểm tra sức khỏe framework | — |
| `/learn` | Extract patterns từ session | — |
| `/evolve` | Cluster patterns → suggest skill amendments | — |

## Quy tắc Bắt buộc

1. **Ghi log đúng FORMAT** → `.agent/maintenance/usage-logger.md`
2. **Luôn hiện guide** sau mỗi workflow
3. **Không bỏ qua verification**
4. **Atomic commits** — conventional format
5. **Phần mềm tiếng Việt** — Nội dung người dùng cuối phải tiếng Việt
6. **Forward slash** — `C:/Users/...` không bao giờ `C:\Users\...`
7. **Evidence before claims (v2.0)** — đọc `evidence-first.md`
8. **Check skills before tasks (v2.0)** — đọc `skill-enforcement.md`
9. **Claim Audit before done (v2.1)** — Evidence table (CONFIRMED/UNCONFIRMED/CONTRADICTED)
10. **Scope Guard (v2.1)** — git diff vs plan sau mỗi wave
11. **Critical functions (v2.1)** — Nếu `.nexus/critical-functions.md` tồn tại → đọc trước khi edit

## Trạng thái Dự án
- `.nexus/state.md` — ĐỌC ĐẦU TIÊN mỗi phiên
- `.nexus/roadmap.md` — lộ trình phase
- `.nexus/project.md` — tầm nhìn, tech stack

## Framework Location
- `.agent/workflows/` — 14 workflows
- `.agent/skills/` — 119 skills (auto-discover)
- `.agent/agents/` — 6 agents + 14 protocols
- `.agent/orchestration/` — Orchestrator
- `.agent/maintenance/` — Logging + self-learning
- `.agent/templates/` — Project templates
