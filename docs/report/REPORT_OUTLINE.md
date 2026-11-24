# AgroVision Final Project Report Outline & Specification

**Module**: SE205.3 - Mobile & Cloud Application Development  
**Academic Year**: 2026 / 2027  
**Project Title**: AgroVision — Smart Nightshade Crop Care & Disease Surveillance Platform  
**Target Users**: Smallholder Farmers and Home Gardeners in Sri Lanka  
**Tech Stack**: Flutter (Riverpod, Feature-First Layering), TensorFlow Lite (Edge ML), Firebase Suite (Auth, Firestore, Cloud Storage, Cloud Functions, FCM), OpenWeatherMap API  

---

## 1. Executive Summary & Problem Definition
- **Background**:
  - Sri Lankan smallholder agriculture faces significant yield losses in nightshade crops (Tomato, Chilli, Brinjal, Potato) due to fungal, bacterial, and pest diseases.
  - Rural farmers face limited agricultural extension support, inconsistent cellular network coverage, and delayed communication during seasonal disease outbreaks.
- **Proposed Solution**:
  - AgroVision delivers a native mobile solution featuring on-device edge AI disease diagnosis (zero-latency, offline functional), smart weather-integrated advisory and irrigation scheduling, and automated, privacy-preserving community outbreak detection.
- **Key Objectives & Success Metrics**:
  - Sub-second disease classification on commodity Android/iOS hardware without requiring internet connectivity.
  - Robust offline synchronization with Cloud Firestore persistence.
  - Early community alerting that respects farmer privacy by preventing farm location identification.

---

## 2. Requirement Analysis & Domain Modeling
- **Target User Personas**:
  - *Smallholder Commercial Farmer*: Needs rapid pest/blight diagnosis in the field, irrigation planning based on monsoon rains, and early warning when diseases spread across neighboring farms.
  - *Urban / Semi-Urban Home Gardener*: Cultivates backyard nightshades, requires step-by-step organic remedies and basic weather advice.
  - *Agricultural Cooperative / Extension Officer (Future Scope)*: Out of core app boundary; interested in aggregate regional health metrics.
- **Functional Requirements (FR)**:
  - FR1: Email/password authentication and personal farm profiling (soil type, region, land size, GPS location).
  - FR2: Offline leaf image capture, camera zoom/focus, and edge inference for nightshade disease classes.
  - FR3: Diagnosis result presentation with severity grading, organic treatments, and chemical alternatives.
  - FR4: Historical diagnosis logging with offline queueing and automatic cloud synchronization.
  - FR5: Hyper-local 5-day weather forecasting and proactive agro-climatic advisories.
  - FR6: Dynamic seasonal crop planning (Maha & Yala seasons) and weekly irrigation schedule generation.
  - FR7: Automated spatial outbreak surveillance triggered when diagnosis density exceeds configurable thresholds.
  - FR8: Real-time privacy-preserving push notifications delivered via FCM to farmers within outbreak radii.
  - FR9: Farm decision logging (History "Decisions" tab) tracking user-confirmed field actions and outcomes.
- **Non-Functional Requirements (NFR)**:
  - NFR1: Performance — On-device inference completed in < 150 ms; smooth 60 fps Flutter UI.
  - NFR2: Offline Resilience — Full scanning, diagnosis, and decision logging functional in airplane mode.
  - NFR3: Privacy & Security — Outbreak alerts omit personal identification and obfuscate precise GPS coordinates.
  - NFR4: Maintainability — Strict adherence to Feature-First architecture, clean repository abstractions, and theme tokenization.
- **Architectural Diagram References**:
  - Use Case Model: [use_case_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/use_case_diagram.png)
  - Data Model: [class_data_model_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/class_data_model_diagram.png)

---

## 3. System Architecture & Design Patterns
- **High-Level Architectural Topology**:
  - Client-Side: Cross-platform Flutter client with embedded TensorFlow Lite quantized model.
  - Server-Side Serverless Backend: Firebase ecosystem (`agrovision-dev` for continuous integration/testing, `agrovision-prod` for production release).
  - External Integrations: OpenWeatherMap REST API mediated exclusively via serverless Cloud Functions.
  - Diagram: [deployment_architecture_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/deployment_architecture_diagram.png)
- **Key Design Patterns**:
  - **Feature-First Layering**:
    - Each business capability (`auth`, `diagnosis`, `weather`, `planner`, `history`, `alerts`) is organized into `domain` (entities and repository interfaces), `data` (data sources, models, repository implementations), and `presentation` (controllers, state notifiers, widgets).
  - **Repository Pattern & Interface Segregation**:
    - Screens and presentation controllers interact only with abstract repository contracts. Presentation layers never directly import Firebase or platform SDKs.
  - **Dependency Injection & Reactive State Management (Riverpod)**:
    - Riverpod `Provider`, `NotifierProvider`, and `AsyncNotifier` provide compile-safe dependency injection and decoupled state propagation.
  - **The `USE_FAKES` Architecture Switch**:
    - Build-time and runtime flag (`--dart-define=USE_FAKES=true/false`).
    - Enables instantaneous UI testing, emulator-free development, and deterministic unit test execution by injecting in-memory fake repositories without altering presentation code.
  - **Offline-First Synchronization Pattern**:
    - Leverage Firestore SDK offline caching (LRU cache configuration) alongside local image queues.
    - Local reads and writes return immediately; synchronization occurs automatically when network connectivity resumes.
- **Specification Additions**:
  - *Decision Logs Entity (`decisionLogs` collection)*: Added to fulfill the History screen "Decisions" tab, documenting farmer response actions and intervention efficacy over crop cycles.

---

## 4. Architectural & Engineering Decisions (With Trade-Offs)
| Decision | Rationale | Alternatives Considered | Trade-Off & Mitigation |
|---|---|---|---|
| **On-Device TFLite Inference vs. Cloud Vision API** | Rural connectivity in Sri Lanka is intermittent; immediate in-field classification is critical. | Cloud Vision / Vertex AI inference endpoint | Higher client app bundle size (~15MB larger); mitigated by model INT8 quantization and asset compression. |
| **Serverless Cloud Functions (Node 20 / TypeScript)** | Zero server maintenance, automatic scaling, native event-driven Firestore triggers for outbreak clustering. | Dedicated Express.js / NestJS VPS instance | Cold-start latency; mitigated by optimizing bundle imports and utilizing lightweight scheduled keep-alives. |
| **Privacy-Preserving Geohash Centroid for Outbreak Alerts** | Prevents social stigmatization and economic harm to farmers whose crops are infected. | Precise farm pin drops on public map | Slight loss in geographic precision; mitigated by providing radial hazard buffers (e.g., 5–10 km). |
| **Cached Weather Aggregation via Cloud Functions** | Eliminates API rate limits on free-tier OpenWeatherMap and prevents API key exposure in client source code. | Direct client-to-OpenWeatherMap HTTP requests | Cache staleness; mitigated by 1-hour cache invalidation windows and manual pull-to-refresh triggers. |
| **Riverpod over BLoC or GetX** | Compile-time safety, seamless provider overriding in unit tests, minimal boilerplate compared to BLoC. | Provider, BLoC, GetX | Learning curve for junior developers; mitigated by standardized repository/notifier templates. |

---

## 5. Security, Privacy & Cloud Rules Architecture
- **Firebase Security Rules**:
  - Firestore Rules: Strict document ownership checks (`request.auth.uid == resource.data.userId`).
  - Public Outbreak Feed: Read-only access to `/outbreakAlerts` for authenticated farmers; write access restricted strictly to Cloud Functions admin context.
  - Cloud Storage Rules: Images restricted to authenticated users writing to `/users/{uid}/diagnoses/` with 5MB max payload limits.
- **Environment & Secret Hygiene**:
  - Zero secrets committed to Git (`.gitignore` excludes `.env`, `google-services.json`, `GoogleService-Info.plist`, service account keys).
  - Backend API keys (`OPENWEATHER_API_KEY`) and cluster thresholds (`OUTBREAK_RADIUS_KM`, `OUTBREAK_MIN_REPORTS`, `OUTBREAK_WINDOW_HOURS`) managed via Cloud Functions `.env`.

---

## 6. Verification, Testing & Quality Assurance
- **Static Analysis & Linting**:
  - Flutter static analysis configured via `flutter_lints` (`flutter analyze` reports 0 issues).
  - Cloud Functions TypeScript ESLint check passing with strict typing.
- **Testing Pyramid**:
  - **Unit Tests**: Mocked business logic tests for planning algorithms, degree-day irrigation calculators, and state notifiers.
  - **Repository & Emulator Integration Tests**: Real Firestore and Auth tests executed against the local Firebase Emulator Suite (`firebase emulators:start`).
  - **Edge ML Verification**: Offline classification confidence tests across representative disease test suites.
  - **UI & Widget Tests**: Component testing verifying theme adherence (no hard-coded colors or sizing).

---

## 7. Individual Contributions & Git Provenance
- Detailed member-by-member breakdown based on repository commit history, pull requests, and feature ownership (see [CONTRIBUTIONS.md](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/CONTRIBUTIONS.md)).
- Summary of review partner pairings (e.g., JKVC Kaveesha & KMCA Kumarasighe).

---

## 8. Limitations & Future Roadmap
- Expanding beyond nightshades to broader cereal and cash crops (Tea, Paddy, Rubber).
- Integrating automated drone survey imagery for plantation-scale field scanning.
- External cooperative portal integration for regional chemical supply chain management and subsidized fertilizer allocation.
- Multilingual Voice UI for non-literate rural farmers in Sinhala and Tamil dialects.
