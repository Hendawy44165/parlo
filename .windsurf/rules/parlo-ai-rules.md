---
trigger: always_on
---

# Workspace Rules for Working on My Codebase

## DO's
1. Follow my exact coding style.  
2. Always ask about anything that is unclear or vague in the codebase.  
3. Always plan before starting any given task.  
4. Always ask for permission before executing the plan you generated when told to perform a task.  
5. Always update the plan if you are told to modify it.  
6. Always stick to the provided UI screenshots when implementing features.  
7. If you are told to modify the UI beyond the screenshots, do ONLY what you are told.  
8. Always connect the UI with temporary test data, and do NOT connect it with actual logic if and ONLY if you are implementing UI code.  
9. When explicitly instructed to connect the UI with the actual logic in other layers, always do that.  
10. Keep your changes small and scoped; avoid large PRs that mix unrelated tasks.  
11. Document the code only when explicitly told to do so.  
12. Stick strictly to the agreed plan.  
13. When working with the database schema, read the schema provided.  
14. If you are not given the schema, ask for it and do NOT proceed without it unless instructed otherwise.
15. When creating any UI component, ask for the screenshot.  
16. If not given the screenshot, ask for it and do NOT proceed without it unless instructed otherwise.
17. Read only the files you are told to read, unless instructed otherwise.  
18. If you find a potential issue (logical or otherwise), mention it, and I will make the decision on how to proceed.
19. When planning, always mention any platform specific changes for android files.
20. When planning, always mention any platform specific changes for iOS files.

## DON'Ts
1. Do not modify any files I did NOT tell you to modify.  
2. Do not read any files I did NOT tell you to read.
3. Do not assume anything you do NOT know about the codebase or its intent.
4. Do not go beyond the provided UI screenshots when implementing features unless instructed otherwise. 
5. Do not connect the UI with other layers while still in the UI implementation phase.  
6. Do not create any files I did NOT tell you to create.  
7. Do not delete any files I did NOT tell you to delete.  
8. Never commit anything on your own; I will handle commits manually.  
9. Do not search for files outside the ones explicitly provided.  
10. Do not act upon any potential issue (logical or otherwise) unless explicitly instructed to do so.  

## INFO
1. The database in use is **Supabase**.  
2. The state management solution is **Riverpod**.  
3. The app will be deployed for **Android** and **iOS** only.  
