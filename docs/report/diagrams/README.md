# AgroVision System Architecture & Report Diagrams

This directory contains the formal architectural diagrams for the AgroVision project report and technical documentation. Each diagram is provided in three formats:
1. **Mermaid source (`.mmd`)**: Direct markdown rendering in GitHub, GitLab, and documentation viewers.
2. **PlantUML source (`.puml`)**: Industry-standard UML notation for PlantUML generators and IDE extensions.
3. **High-resolution PNG render (`.png`)**: Standalone, print-ready image for inclusion in final Word / PDF submission reports.

---

## 1. Use Case Diagram
- **Files**: 
  - Mermaid: [use_case_diagram.mmd](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/use_case_diagram.mmd)
  - PlantUML: [use_case_diagram.puml](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/use_case_diagram.puml)
  - PNG: [use_case_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/use_case_diagram.png)
- **Scope & Boundary**:
  - **Actors**: Smallholder Farmer (primary user), Home Gardener (nightshade crop cultivator), and Agricultural Cooperative (placed explicitly outside the system boundary as future scope for aggregated bulk analytics).
  - **Core Use Cases**: User authentication and farm profile management, edge-first offline crop leaf disease diagnosis (Tomato, Chilli, Brinjal, Potato), diagnosis history caching and cloud sync, hyper-local weather advisory, seasonal crop planning, smart irrigation scheduling, automated outbreak detection triggers, and privacy-preserving push notifications.

---

## 2. Domain Class & Firestore Data Model Diagram
- **Files**:
  - Mermaid: [class_data_model_diagram.mmd](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/class_data_model_diagram.mmd)
  - PlantUML: [class_data_model_diagram.puml](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/class_data_model_diagram.puml)
  - PNG: [class_data_model_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/class_data_model_diagram.png)
- **Entities & Collections**:
  - `users`: User profiles containing authentication UID, contact info, farm location (`GeoPoint`), region, soil type, land size, and FCM token.
  - `cropProfiles`: Farm crop plots specifying crop variety, planting date, soil type, growth stage, and acreage.
  - `diagnoses`: Scan records with leaf image URL, model predicted class, confidence score, GPS coordinates (`GeoPoint`), geohash, and timestamp.
  - `plantingRecommendations`: Seasonal crop recommendations tailored to soil type, climate, and region.
  - `irrigationSchedules`: Weekly watering schedules generated according to rainfall and crop stage.
  - `weatherCache`: Server-side cached 5-day / 3-hour forecasts keyed by geographic region.
  - `outbreakAlerts`: Aggregated outbreak surveillance records containing disease type, obfuscated centroid (`centerPoint`), radius, report count, and preventive measures.
  - `notifications`: User-specific notification records referencing outbreak alerts.
  - `decisionLogs`: **Specification addition** developed for the History screen Decisions tab, capturing user-confirmed crop interventions and action records.
- **Privacy Design**: `outbreakAlerts` explicitly avoids storing farmer UIDs or raw coordinates to ensure privacy.

---

## 3. Deployment & Physical Architecture Diagram
- **Files**:
  - Mermaid: [deployment_architecture_diagram.mmd](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/deployment_architecture_diagram.mmd)
  - PlantUML: [deployment_architecture_diagram.puml](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/deployment_architecture_diagram.puml)
  - PNG: [deployment_architecture_diagram.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/deployment_architecture_diagram.png)
- **System Components**:
  - **Edge Mobile Device**: Flutter client structured with feature-first layering, Riverpod state management & dependency injection, `USE_FAKES` toggle switch, local SQLite / Firestore offline cache, and on-device TensorFlow Lite inference runtime (`model.tflite` + `labels.txt`).
  - **Firebase Cloud Ecosystem (`agrovision-dev` / `agrovision-prod`)**: Firebase Authentication, Cloud Firestore NoSQL store, Cloud Storage for leaf imagery, Firebase Cloud Messaging (FCM), and Cloud Functions runtime (Node 20, TypeScript).
  - **Cloud Functions**:
    1. `getWeatherForecast`: HTTPS callable with regional cache fallback.
    2. `refreshWeatherCache`: Hourly scheduled Pub/Sub cron.
    3. `onDiagnosisCreated`: Firestore trigger for density-based spatial outbreak clustering.
    4. `onOutbreakAlertCreated`: Firestore trigger querying affected regional devices and dispatching FCM notifications.
  - **External Cloud APIs**: OpenWeatherMap API authenticated securely via backend environment variables (`OPENWEATHER_API_KEY`).

---

## 4. Sequence Diagram: Scan, Diagnose, Save, and Outbreak Alert
- **Files**:
  - Mermaid: [sequence_diagram_diagnosis_outbreak.mmd](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/sequence_diagram_diagnosis_outbreak.mmd)
  - PlantUML: [sequence_diagram_diagnosis_outbreak.puml](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/sequence_diagram_diagnosis_outbreak.puml)
  - PNG: [sequence_diagram_diagnosis_outbreak.png](file:///c:/Users/ASUS/Downloads/AgroVision_All_Prompt_Files/backend/AgroVision/docs/report/diagrams/sequence_diagram_diagnosis_outbreak.png)
- **Execution Lifecycle**:
  - **Phase 1: Edge Diagnosis (100% Offline)**: Farmer captures image -> UI delegates to Riverpod provider -> TFLite classifier processes quantized tensor -> Result and treatments rendered without network.
  - **Phase 2: Save & Cloud Sync**: Tap save -> Immediate write to local cache -> When online, image uploaded to Cloud Storage and document committed to Firestore `/diagnoses`.
  - **Phase 3: Outbreak Cluster Detection**: Firestore trigger `onDiagnosisCreated` evaluates spatial density against thresholds (`OUTBREAK_RADIUS_KM`, `OUTBREAK_MIN_REPORTS`, `OUTBREAK_WINDOW_HOURS`) -> Generates privacy-safe record in `/outbreakAlerts`.
  - **Phase 4: Privacy-Preserving Push Notification**: Firestore trigger `onOutbreakAlertCreated` finds nearby active farmer tokens -> Stores notification logs -> Dispatches FCM push alert to community devices.
