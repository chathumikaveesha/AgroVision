# AgroVision Individual Contributions & Git Provenance

This document records the specific contributions, owned architectural components, branch workflows, and pull requests for each development team member on the AgroVision project (SE205.3). Each member maintains their individual section in their own words for viva voce defense and assessment verification.

---

## Team Roster & Review Partner Pairings

| Member Name | Student ID / Git Identity | Core Responsibility Area | Review Partner |
|---|---|---|---|
| **JKVC Kaveesha** | `jkvckaveesha@students.nsbm.ac.lk` / `ChathumiKaveesha` | Repo Hygiene, Architecture Diagrams, Outline, Submission Pack | KMCA Kumarasighe |
| **KMCA Kumarasighe** | University Student Email | Back-End Services, Database & Auth Integration | JKVC Kaveesha |
| **AHMS Team Member** | University Student Email | Weather Callable & Cache Pipeline | Peer Review Partner |
| **PDS Team Member** | University Student Email | Planning Engine & Irrigation Scheduling | Peer Review Partner |
| **RMO Team Member** | University Student Email | Diagnosis Synchronization & Outbreak Cloud Function | Peer Review Partner |
| **SDL Team Member** | University Student Email | Alerts, FCM Push Distribution & Farm Profile | Peer Review Partner |
| **Lead / Sahan** | `masnweerasingha@students.nsbm.ac.lk` / `sahannavo` | Project Architecture, CI/CD, Deployment & Releases | Team Lead |

---

## 1. JKVC Kaveesha
- **Student ID**: JKVC Kaveesha (`jkvckaveesha@students.nsbm.ac.lk`)
- **Review Partner**: KMCA Kumarasighe
- **Assigned Tasks**:
  - **Task 1: Repository hygiene and Git fixes** (`fix/repo/hygiene`)
    - Root `.gitignore` expansion (Dart/Flutter, Node.js/Functions, Python/ML, Firebase, OS entries).
    - University identity mapping via `.mailmap`.
    - Redundant `.gitkeep` cleanup.
    - Dynamic user profile header binding in `profile_header.dart` (replacing hard-coded 'Nimal Perera').
    - Branch lifecycle documentation in `docs/BRANCH_CLEANUP.md` and repository guidelines in `CONTRIBUTING.md`.
  - **Task 2: Report diagrams and outline** (`feature/docs/report`)
    - Authored end-to-end Mermaid and PlantUML diagram specifications with custom high-resolution PNG renders:
      1. Use Case Diagram (Farmer, Gardener, Cooperative external scope).
      2. Domain & Firestore Data Model Diagram (entities, relations, privacy rule, `decisionLogs` specification addition).
      3. Physical Deployment & System Architecture Diagram (Flutter client, TFLite engine, Firebase Suite, OpenWeatherMap).
      4. End-to-End Sequence Diagram (Image scan, on-device inference, offline persistence, cloud sync, outbreak detection, FCM alert).
    - Authored comprehensive project report outline matching assessment criteria in `docs/report/REPORT_OUTLINE.md`.
    - Created team contributions matrix in `docs/report/CONTRIBUTIONS.md`.
  - **Task 3: Demo and submission pack** (`feature/docs/submission`)
    - Detailed 5–7 minute walkthrough demo script with offline failover procedures in `docs/demo/DEMO_SCRIPT.md`.
    - Farmer end-user operating manual in `docs/USER_GUIDE.md`.
    - Assessment submission checklist with ownership status in `docs/SUBMISSION_CHECKLIST.md`.
- **Branches & Pull Requests**:
  - Personal Branch: `main` / personal task branches
  - PR Titles:
    - `[Docs] Report diagrams and outline specification`
    - `[Repo] Repository hygiene and Git configuration fixes`
    - `[Docs] Demo script and submission pack`
- **Key Files Created / Owned**:
  - `docs/report/diagrams/*` (`.mmd`, `.puml`, `.png`, `README.md`)
  - `docs/report/REPORT_OUTLINE.md`
  - `docs/report/CONTRIBUTIONS.md`
  - `docs/demo/DEMO_SCRIPT.md`
  - `docs/USER_GUIDE.md`
  - `docs/SUBMISSION_CHECKLIST.md`

---

## 2. KMCA Kumarasighe
- **Review Partner**: JKVC Kaveesha
- **Assigned Tasks**:
  - Authentication repository implementation (`AuthRepository`) connecting Firebase Auth with the presentation layer.
  - Farm profile data management (`UserRepository`) and Firestore synchronization.
  - Unit and emulator integration testing for authentication states and token validation.
- **Branches & Pull Requests**:
  - Pull Requests into `dev` reviewed by JKVC Kaveesha.
- **Key Files Owned**:
  - `lib/features/auth/data/auth_repository.dart`
  - `lib/features/profile/data/user_repository.dart`
  - Corresponding emulator test suites in `test/features/auth/`

---

## 3. AHMS Team Member
- **Assigned Tasks**:
  - Serverless weather service (`getWeatherForecast` callable Cloud Function).
  - Hourly scheduled Pub/Sub cron function (`refreshWeatherCache`) in TypeScript/Node 20.
  - Client-side `WeatherRepository` and caching engine respecting OpenWeatherMap rate limits.
- **Key Files Owned**:
  - `functions/src/getWeatherForecast.ts`
  - `functions/src/refreshWeatherCache.ts`
  - `lib/features/weather/data/weather_repository.dart`

---

## 4. PDS Team Member
- **Assigned Tasks**:
  - Smart seasonal crop planning engine (`PlantingRepository`) tailored for Sri Lankan Maha and Yala seasons.
  - Dynamic irrigation scheduling algorithm (`IrrigationRepository`) computing weekly water requirements from cached rainfall forecasts.
- **Key Files Owned**:
  - `lib/features/planner/data/planting_repository.dart`
  - `lib/features/planner/data/irrigation_repository.dart`
  - Domain tests in `test/features/planner/`

---

## 5. RMO Team Member
- **Assigned Tasks**:
  - Diagnosis recording and image storage pipeline (`DiagnosisRepository`).
  - Cloud Storage upload integration with local Firestore offline write persistence.
  - Density-based spatial outbreak detection Cloud Function (`onDiagnosisCreated`).
  - Privacy-preserving geohash cluster radius calculations.
- **Key Files Owned**:
  - `functions/src/onDiagnosisCreated.ts`
  - `lib/features/diagnosis/data/diagnosis_repository.dart`
  - Firestore security rules for diagnoses and images.

---

## 6. SDL Team Member
- **Assigned Tasks**:
  - Outbreak notification dispatch Cloud Function (`onOutbreakAlertCreated`).
  - Firebase Cloud Messaging (FCM) integration and device token registration.
  - Alerts presentation feed and local push notifications setup.
  - Farm crop profile management (`CropPlotsRepository`).
- **Key Files Owned**:
  - `functions/src/onOutbreakAlertCreated.ts`
  - `lib/features/alerts/data/alerts_repository.dart`
  - `lib/features/crop_plots/data/crop_plots_repository.dart`

---

## 7. Project Lead (Sahan)
- **Git Identity**: `sahannavo <masnweerasingha@students.nsbm.ac.lk>`
- **Responsibilities**:
  - Repository initialization, clean architecture skeleton, and base Flutter app scaffolding.
  - Firebase projects management (`agrovision-dev` and `agrovision-prod`).
  - CI/CD workflow configuration (`.github/workflows/ci.yml`).
  - Merging approved feature PRs into `dev`, managing release tags (`v0.1-ui`, `v0.2-backend`, `v1.0-rc`, `v1.0`).
  - Final production deployment and sign-off.
