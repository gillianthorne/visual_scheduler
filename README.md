# Daily Visual Schedule & To‑Do App  
A Flutter + Hive productivity app designed for minute‑level planning, overlapping tasks, reusable templates, and customizable visual schedules.

This project serves two purposes:
1. A real tool I use to plan my day.
2. A polished portfolio project demonstrating Flutter architecture, state management, and local persistence with Hive.

---

## ✨ Features

### 🕒 Minute‑Level Scheduling
- Plan tasks down to the minute (or 5‑minute increments).
- Smooth, scrollable daily timeline.

### 🔁 Overlapping Tasks
- Schedule tasks that run concurrently (e.g., laundry during homework).
- Layered visual representation for clarity.

### 🎨 Customizable Colors & Categories
- Full color picker for categories and tasks.
- Visual organization that adapts to your workflow.

### 📦 Reusable Templates
- Create preset blocks (e.g., “3‑hour class”, “Doctor’s appointment”, “Study block”).
- Drag‑and‑drop into your schedule.

### 📅 Custom Day Profiles
- Save entire day layouts (e.g., “Wednesday class schedule”).
- Apply profiles to future dates.

### 📆 Plan Ahead
- Add tasks to any future day.
- Weekly and monthly views for long‑term planning.

---

## 🧱 Tech Stack

- **Flutter** (UI)
- **Hive** (local storage)
- **Riverpod / Bloc** (state management — TBD)
- **Custom timeline rendering** for overlapping tasks

---

## 🗄️ Data Model Overview

### Task
- id, title, startTime, endTime  
- categoryId, templateId  
- allowOverlap  
- isReminder  

### Category
- id, name, colorValue  

### Template
- id, name, duration, categoryId  

### DayProfile
- id, name, tasks[], repeatOnWeekdays[]  

---

## 🚧 Current Status
- [x] Core models + Hive adapters  
- [x] Basic timeline UI  
- [x] Task creation + editing  
- [ ] Overlap rendering  
- [ ] Templates  
- [ ] Day profiles  
- [ ] Weekly/monthly views  
- [ ] Polished UI + animations  

---

## 🛣️ Roadmap (No Hard Deadlines)

This project is intentionally flexible. I’m building it iteratively as both a learning tool and a daily‑use app.

### Phase 1 — Foundations
- Set up Hive boxes  
- Implement models + adapters  
- Build basic daily timeline  

### Phase 2 — Scheduling Features
- Overlapping task logic  
- Minute‑level timeline  
- Task creation UI  

### Phase 3 — Templates & Profiles
- Template library  
- Day profile system  
- Apply profiles to future days  

### Phase 4 — UI Polish
- Animations  
- Color picker  
- Themes (light/dark/pastel)  

### Phase 5 — Portfolio Polish
- README refinement  
- Screenshots / demo video  
- Code cleanup + documentation  

---

## 🙋‍♀️ About This Project
This app is built to support my own daily planning needs while demonstrating clean architecture, thoughtful UX, and learning practical Flutter development.