---
phase: [N]
plan: [N]
name: [Plan Name]
requirements: [REQ-001, REQ-002]
wave: [N]
autonomous: true
gap_closure: false
---

<objective>
[2-3 sentences: what this plan builds and why it matters]
</objective>

<context>
[Key decisions, constraints, or patterns that affect implementation]
</context>

<resources>
  <agents>[executor, debugger, reviewer — agents dự kiến sử dụng]</agents>
  <skills>[frontend, database, testing — domain skills cần thiết]</skills>
  <mcp>[Context7: tra API docs | Serena: symbolic analysis | Pencil: design trong .pen — nếu cần]</mcp>
</resources>

<tasks>

<task type="auto">
  <name>[Task name]</name>
  <files>[file paths this task creates or modifies]</files>
  <action>
    [Specific implementation instructions]
  </action>
  <verify>[How to verify this task is complete]</verify>
  <done>[Definition of done]</done>
</task>

<task type="auto">
  <name>[Task name]</name>
  <files>[file paths]</files>
  <action>
    [Specific implementation instructions]
  </action>
  <verify>[How to verify]</verify>
  <done>[Definition of done]</done>
</task>

</tasks>

<verification>
[Overall verification steps for the entire plan]
</verification>
