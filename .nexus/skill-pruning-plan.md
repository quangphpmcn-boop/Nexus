# Skill Pruning — Tự động loại bỏ skills không liên quan sau `/init`

## Bối cảnh

Installer copy toàn bộ 116 skills (2.3MB) vào mỗi project. Nhưng mỗi project chỉ cần 20-40 skills tùy tech stack. Phần còn lại chiếm context khi agent search SKILL-INDEX.

**Giải pháp:** Thêm Step vào `/init` — sau khi xác định tech stack → tạo "skill manifest" → prune skills thừa.

## Thiết kế

### Flow

```
/init Step 1: Discovery Interview → xác định tech stack
/init Step 1.3: Serena Registration
/init Step 3: Tạo .nexus/
                  ↓
/init Step 3.5: Skill Pruning (MỚI)
  1. Đọc tech stack từ project.md
  2. Match → skill-manifest.json (mapping table)
  3. List skills cần GIỮ (always-keep + matched)
  4. List skills cần XÓA
  5. Trình user review danh sách
  6. Xóa folders + cập nhật SKILL-INDEX.md
  7. Ghi manifest vào .nexus/skill-manifest.json
```

### Mapping: Tech Stack → Skill Categories

| Tech Stack Keyword | Categories GIỮ | Skills GIỮ |
|-------------------|----------------|------------|
| Flutter/Dart | `mobile/flutter-expert`, `languages/` (dart implicit) | + UI skills core |
| Python | `languages/python-*`, `backend/django,fastapi` | + testing/python-* |
| React/Next.js | `frontend/react-*,nextjs-*`, `languages/typescript-*` | |
| Angular | `frontend/angular`, `languages/typescript-*` | |
| Vue | `languages/javascript-*,typescript-*` | |
| Node.js | `backend/nodejs-*,nestjs-*`, `languages/typescript-*` | |
| Rust | `languages/rust-pro` | |
| Go | `languages/golang-pro` | |
| Java/Kotlin | `languages/java-pro,kotlin-*` | |

### Always-Keep Skills (14 categories → giữ toàn bộ)

| Category | Lý do |
|----------|-------|
| `workflow/` (11 skills) | Core framework operation |
| `nexus/` (1 skill) | Framework self-reference |
| `quality/clean-code` | Mọi project cần |
| `quality/code-reviewer` | Mọi project cần |
| `quality/systematic-debugging` | Mọi project cần |
| `quality/error-handling-patterns` | Mọi project cần |
| `quality/documentation` | Mọi project cần |
| `quality/readme` | Mọi project cần |
| `quality/commit` | Mọi project cần |
| `quality/mermaid-expert` | Dùng cho diagrams |
| `quality/import-guard` | v2.1 verification |
| `devops/git-*` (2 skills) | Mọi project dùng git |
| `security/security-auditor` | Review scope |
| `testing/find-bugs` | Debug scope |
| `testing/vibe-code-auditor` | Audit scope |

### Skill Manifest Format (.nexus/skill-manifest.json)

```json
{
  "tech_stack": ["flutter", "python"],
  "kept_categories": ["mobile", "languages", "workflow", "nexus", ...],
  "kept_skills": ["flutter-expert", "python-pro", "python-patterns", ...],
  "pruned_categories": ["backend", "frontend"],
  "pruned_skills_count": 52,
  "pruned_at": "2026-03-16T11:40:00+07:00"
}
```

### Ví dụ: Flutter + Python project

| Category | Trước | Sau | Xóa |
|----------|-------|-----|-----|
| `workflow/` | 11 | 11 | 0 |
| `quality/` | 19 | 10 | 9 |
| `testing/` | 8 | 5 | 3 |
| `security/` | 6 | 3 | 3 |
| `mobile/` | 2 | 1 | 1 |
| `languages/` | 15 | 2 | 13 |
| `frontend/` | 7 | 1 | 6 |
| `backend/` | 5 | 0 | 5 |
| `database/` | 8 | 2 | 6 |
| `architecture/` | 10 | 3 | 7 |
| **Tổng** | **116** | **~50** | **~66 (57%)** |

## Proposed Changes

### Init Workflow

#### [MODIFY] [init.md](file:///H:/Kit/Nexus/.agent/workflows/init.md)

Thêm **Step 3.5: Skill Pruning** sau Step 3 (Create `.nexus/`).

### SKILL-INDEX

#### [MODIFY] [SKILL-INDEX.md](file:///H:/Kit/Nexus/.agent/skills/SKILL-INDEX.md)

- Thêm note: "File này sẽ được pruned bởi `/init` Step 3.5"
- Cập nhật sau prune: xóa entries đã prune

### Existing Files

#### Không cần sửa `install.ps1` — installer vẫn copy toàn bộ, `/init` mới prune.

## Verification Plan

- Chạy `/init` trên project test → verify skill-manifest.json đúng
- Đếm skills còn lại sau prune
- Test `/plan` + `/execute` → verify skills load đúng
