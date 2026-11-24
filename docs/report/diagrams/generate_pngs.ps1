Add-Type -AssemblyName System.Drawing

function Render-UseCaseDiagram {
    param([string]$outputPath)
    $bmp = New-Object System.Drawing.Bitmap 1400, 1000
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::White)

    # Fonts
    $titleFont = [System.Drawing.Font]::new("Arial", [float]16, [System.Drawing.FontStyle]::Bold)
    $subtitleFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Regular)
    $boxFont = [System.Drawing.Font]::new("Arial", [float]11, [System.Drawing.FontStyle]::Bold)
    $ucFont = [System.Drawing.Font]::new("Arial", [float]9, [System.Drawing.FontStyle]::Regular)
    $actorFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Bold)
    
    $blackBrush = [System.Drawing.Brushes]::Black
    $blueBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(41, 128, 185))
    $greenBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(39, 174, 96))
    $grayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(127, 140, 141))
    $lightGreenBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 247, 238))
    $lightBlueBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 245, 255))
    $lightGrayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(248, 249, 250))

    $borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(44, 62, 80), [float]2)
    $dashPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(149, 165, 166), [float]2)
    $dashPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    $linePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(52, 73, 94), [float]1.5)

    # Title
    $g.DrawString("AgroVision - Use Case Diagram", $titleFont, $blackBrush, 50, 20)
    $g.DrawString("Nightshade Crop Management & Disease Surveillance Platform (Sri Lanka)", $subtitleFont, $grayBrush, 50, 50)

    # System Boundary
    $g.FillRectangle($lightGrayBrush, 280, 80, 820, 880)
    $g.DrawRectangle($borderPen, 280, 80, 820, 880)
    $g.DrawString("AgroVision System Boundary", $boxFont, $blackBrush, 300, 95)

    # Helper function for drawing an actor
    function Draw-Actor($x, $y, $name, $desc, $isFuture = $false) {
        $p = if ($isFuture) { $dashPen } else { $borderPen }
        $b = if ($isFuture) { $grayBrush } else { $blackBrush }
        # Head
        $g.DrawEllipse($p, $x - 15, $y - 30, 30, 30)
        # Body
        $g.DrawLine($p, $x, $y, $x, $y + 40)
        # Arms
        $g.DrawLine($p, $x - 25, $y + 15, $x + 25, $y + 15)
        # Legs
        $g.DrawLine($p, $x, $y + 40, $x - 20, $y + 80)
        $g.DrawLine($p, $x, $y + 40, $x + 20, $y + 80)
        # Text
        $sf = [System.Drawing.StringFormat]::new()
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $g.DrawString($name, $actorFont, $b, [float]$x, [float]($y + 90), $sf)
        $g.DrawString($desc, $subtitleFont, $b, [float]$x, [float]($y + 110), $sf)
    }

    # Helper for drawing Use Case oval
    function Draw-UseCase($x, $y, $w, $h, $text, $subtext = "", $isPrimary = $true) {
        $brush = if ($isPrimary) { $lightGreenBrush } else { $lightBlueBrush }
        $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(39, 174, 96), [float]1.5)
        $g.FillEllipse($brush, $x, $y, $w, $h)
        $g.DrawEllipse($pen, $x, $y, $w, $h)

        $sf = [System.Drawing.StringFormat]::new()
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = [System.Drawing.RectangleF]::new([float]$x, [float]$y, [float]$w, [float]$h)
        $disp = if ($subtext) { "$text`n($subtext)" } else { $text }
        $g.DrawString($disp, $ucFont, $blackBrush, $rect, $sf)
    }

    # Draw Actors
    Draw-Actor 120 220 "Smallholder Farmer" "(Primary User)"
    Draw-Actor 120 540 "Home Gardener" "(Nightshade Crops)"
    Draw-Actor 1220 380 "Agricultural Cooperative" "(Future Work / External)" $true

    # Draw Use Cases
    # Authentication & Farm Profile
    Draw-UseCase 320 140 240 60 "Register & Login" "Firebase Auth"
    Draw-UseCase 600 140 240 60 "Manage Farm Profile" "Location, Soil, Land Size"
    
    # Offline First Diagnosis
    Draw-UseCase 320 230 250 65 "Capture Leaf Image" "Tomato, Chilli, Brinjal, Potato"
    Draw-UseCase 610 230 250 65 "<<Edge ML>> Run Inference" "Quantized TFLite Model"
    Draw-UseCase 610 320 250 65 "View Diagnosis & Treatment" "Remedies & Prevention"
    Draw-UseCase 320 320 250 65 "Save & Sync Diagnosis" "Local Cache & Cloud Sync"

    # Advisory & Planning
    Draw-UseCase 320 420 260 65 "View Hyper-Local Weather" "Hourly Cache / OpenWeatherMap"
    Draw-UseCase 620 420 260 65 "Seasonal Crop Plan" "Maha / Yala Recommendations"
    Draw-UseCase 320 520 260 65 "Smart Irrigation Schedule" "Weekly Plan based on Rain"

    # Community Surveillance
    Draw-UseCase 620 620 270 70 "<<Cloud Trigger>> Outbreak Detection" "Geohash Radius Clustering"
    Draw-UseCase 320 620 270 70 "Receive Outbreak Push Alert" "FCM Privacy-Preserving Alert"

    # History & Decision Logs
    Draw-UseCase 320 730 250 65 "Browse Diagnosis History" "Timeline & Crop Filter"
    Draw-UseCase 620 730 260 65 "Track Decision Logs" "Decisions Tab Addition"

    # Farmer Connections
    $g.DrawLine($linePen, 150, 220, 320, 170)
    $g.DrawLine($linePen, 150, 240, 600, 170)
    $g.DrawLine($linePen, 150, 260, 320, 260)
    $g.DrawLine($linePen, 150, 280, 320, 450)
    $g.DrawLine($linePen, 150, 300, 620, 450)
    $g.DrawLine($linePen, 150, 320, 320, 550)
    $g.DrawLine($linePen, 150, 340, 320, 650)
    $g.DrawLine($linePen, 150, 360, 320, 760)
    $g.DrawLine($linePen, 150, 380, 620, 760)

    # Gardener Connections
    $g.DrawLine($linePen, 150, 540, 320, 170)
    $g.DrawLine($linePen, 150, 560, 320, 260)
    $g.DrawLine($linePen, 150, 580, 320, 450)
    $g.DrawLine($linePen, 150, 600, 320, 650)
    $g.DrawLine($linePen, 150, 620, 320, 760)

    # Internal Use Case Links (includes / triggers)
    $g.DrawLine($dashPen, 570, 260, 610, 260)
    $g.DrawLine($dashPen, 735, 295, 735, 320)
    $g.DrawLine($dashPen, 610, 350, 570, 350)
    $g.DrawLine($dashPen, 445, 385, 620, 640)
    $g.DrawLine($dashPen, 620, 655, 590, 655)

    # Coop Future Link
    $g.DrawLine($dashPen, 1160, 420, 1100, 450)

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $outputPath"
}

function Render-ClassDataModelDiagram {
    param([string]$outputPath)
    $bmp = New-Object System.Drawing.Bitmap 1500, 1100
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::White)

    $titleFont = [System.Drawing.Font]::new("Arial", [float]16, [System.Drawing.FontStyle]::Bold)
    $subtitleFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Regular)
    $entityTitleFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Bold)
    $fieldFont = [System.Drawing.Font]::new("Consolas", [float]8.5, [System.Drawing.FontStyle]::Regular)
    $noteFont = [System.Drawing.Font]::new("Arial", [float]8.5, [System.Drawing.FontStyle]::Italic)

    $blackBrush = [System.Drawing.Brushes]::Black
    $blueBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(41, 128, 185))
    $grayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(100, 100, 100))
    $cardBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(250, 252, 255))
    $headerBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(44, 62, 80))
    $noteBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(254, 249, 231))

    $borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(52, 73, 94), [float]1.5)
    $linePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(127, 140, 141), [float]1.5)
    $dashPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 180, 180), [float]1)
    $dashPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash

    # Title
    $g.DrawString("AgroVision - Domain & Firestore Data Model Diagram", $titleFont, $blackBrush, 50, 20)
    $g.DrawString("Comprehensive Entity-Relationship Structure across Firestore Collections & Repositories", $subtitleFont, $grayBrush, 50, 50)

    function Draw-EntityCard($x, $y, $w, $h, $name, $fields) {
        # Card Body
        $g.FillRectangle($cardBg, $x, $y, $w, $h)
        $g.DrawRectangle($borderPen, $x, $y, $w, $h)
        # Header
        $g.FillRectangle($headerBg, $x, $y, $w, 28)
        $g.DrawRectangle($borderPen, $x, $y, $w, 28)
        
        $sf = [System.Drawing.StringFormat]::new()
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = [System.Drawing.RectangleF]::new([float]$x, [float]$y, [float]$w, [float]28)
        $whiteBrush = [System.Drawing.Brushes]::White
        $g.DrawString($name, $entityTitleFont, $whiteBrush, $rect, $sf)

        $fy = $y + 34
        foreach ($f in $fields) {
            $g.DrawString($f, $fieldFont, $blackBrush, [float]($x + 10), [float]$fy)
            $fy += 16
        }
    }

    # 1. users
    Draw-EntityCard 60 100 280 200 "users (User Profile)" @(
        "* uid : String [PK, Auth UID]",
        "* email : String",
        "* fullName : String",
        "* location : GeoPoint",
        "* region : String",
        "* soilType : String",
        "* landSize : double",
        "  fcmToken : String",
        "* createdAt : DateTime"
    )

    # 2. cropProfiles
    Draw-EntityCard 400 100 280 180 "cropProfiles" @(
        "* cropId : String [PK]",
        "* userId : String [FK -> users]",
        "* name : String",
        "* cropType : String (Nightshade)",
        "* plantedDate : DateTime",
        "* soilType : String",
        "* growthStage : String",
        "* areaSize : double"
    )

    # 3. diagnoses
    Draw-EntityCard 740 100 310 200 "diagnoses" @(
        "* diagnosisId : String [PK]",
        "* userId : String [FK -> users]",
        "  cropId : String [FK, nullable]",
        "* imageUrl : String (Storage)",
        "* predictedClass : String",
        "* confidenceScore : double",
        "* location : GeoPoint",
        "* geohash : String",
        "* diagnosedAt : DateTime"
    )

    # 4. outbreakAlerts
    Draw-EntityCard 1110 100 320 180 "outbreakAlerts (Privacy-Preserving)" @(
        "* alertId : String [PK]",
        "* diseaseType : String",
        "* centerPoint : GeoPoint (rounded)",
        "* radiusKm : double",
        "* reportCount : int",
        "* preventiveSteps : List<String>",
        "* createdAt : DateTime"
    )

    # 5. notifications
    Draw-EntityCard 1110 380 320 170 "notifications" @(
        "* notificationId : String [PK]",
        "* userId : String [FK -> users]",
        "* alertId : String [FK -> outbreakAlerts]",
        "* title : String",
        "* body : String",
        "* sentAt : DateTime",
        "* deliveryStatus : String"
    )

    # 6. plantingRecommendations
    Draw-EntityCard 60 400 300 170 "plantingRecommendations" @(
        "* recId : String [PK]",
        "* userId : String [FK -> users]",
        "* soilType : String",
        "* season : String (Maha/Yala)",
        "* location : GeoPoint",
        "* recommendedCrops : List<String>",
        "* generatedAt : DateTime"
    )

    # 7. irrigationSchedules
    Draw-EntityCard 410 400 300 170 "irrigationSchedules" @(
        "* scheduleId : String [PK]",
        "* cropId : String [FK -> cropProfiles]",
        "* userId : String [FK -> users]",
        "* weeklyPlan : List<Map>",
        "* weatherSnapshot : Map",
        "* generatedAt : DateTime"
    )

    # 8. weatherCache
    Draw-EntityCard 760 400 280 150 "weatherCache" @(
        "* cacheId : String [PK, regionKey]",
        "* regionKey : String",
        "* forecastJson : Map",
        "* fetchedAt : DateTime",
        "* expiresAt : DateTime"
    )

    # 9. decisionLogs (Spec Addition)
    Draw-EntityCard 60 670 340 170 "decisionLogs (Spec Addition)" @(
        "* id : String [PK]",
        "* userId : String [FK -> users]",
        "* date : DateTime",
        "* title : String",
        "* detail : String",
        "* resultLabel : String"
    )

    # Notes Card
    $g.FillRectangle($noteBg, 460, 670, 970, 170)
    $g.DrawRectangle($borderPen, 460, 670, 970, 170)
    $g.DrawString("Architecture & Privacy Design Notes:", $entityTitleFont, $blackBrush, 480, 685)
    $g.DrawString("1. Privacy Rule: outbreakAlerts NEVER store individual farmer identity, name, or exact GPS coordinates.", $noteFont, $blackBrush, 480, 715)
    $g.DrawString("   The centroid is obfuscated/rounded to prevent reverse-engineering of infected farms.", $noteFont, $blackBrush, 480, 735)
    $g.DrawString("2. Specification Addition: decisionLogs was introduced specifically for the History screen Decisions tab", $noteFont, $blackBrush, 480, 760)
    $g.DrawString("   to capture actionable farmer interventions and advice outcomes.", $noteFont, $blackBrush, 480, 780)
    $g.DrawString("3. Offline Synchronization: All local writes leverage Firestore offline persistence, synchronizing once connectivity resumes.", $noteFont, $blackBrush, 480, 805)

    # Relationship Lines
    $g.DrawLine($linePen, 340, 150, 400, 150) # users -> cropProfiles
    $g.DrawLine($linePen, 680, 150, 740, 150) # cropProfiles -> diagnoses
    $g.DrawLine($dashPen, 1050, 150, 1110, 150) # diagnoses -> outbreakAlerts (cluster)
    $g.DrawLine($linePen, 1270, 280, 1270, 380) # outbreakAlerts -> notifications
    $g.DrawLine($linePen, 200, 300, 200, 400) # users -> plantingRecommendations
    $g.DrawLine($linePen, 550, 280, 550, 400) # cropProfiles -> irrigationSchedules
    $g.DrawLine($linePen, 200, 570, 200, 670) # users -> decisionLogs

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $outputPath"
}

function Render-DeploymentArchitectureDiagram {
    param([string]$outputPath)
    $bmp = New-Object System.Drawing.Bitmap 1500, 1050
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::White)

    $titleFont = [System.Drawing.Font]::new("Arial", [float]16, [System.Drawing.FontStyle]::Bold)
    $subtitleFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Regular)
    $boxFont = [System.Drawing.Font]::new("Arial", [float]11, [System.Drawing.FontStyle]::Bold)
    $itemFont = [System.Drawing.Font]::new("Arial", [float]9, [System.Drawing.FontStyle]::Regular)
    $labelFont = [System.Drawing.Font]::new("Arial", [float]8.5, [System.Drawing.FontStyle]::Bold)

    $blackBrush = [System.Drawing.Brushes]::Black
    $grayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(100, 100, 100))
    $deviceBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(240, 248, 255))
    $cloudBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(254, 249, 231))
    $extBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 238, 248))
    $compBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)

    $devicePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(41, 128, 185), [float]2)
    $cloudPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(243, 156, 18), [float]2)
    $extPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(142, 68, 173), [float]2)
    $compPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(52, 73, 94), [float]1.5)
    $linePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(44, 62, 80), [float]1.5)

    # Title
    $g.DrawString("AgroVision - Deployment & Physical Architecture Diagram", $titleFont, $blackBrush, 50, 20)
    $g.DrawString("Flutter Mobile Client (Offline-First Edge ML), Firebase Backend (agrovision-dev/prod), and External APIs", $subtitleFont, $grayBrush, 50, 50)

    # 1. Edge Mobile Node
    $g.FillRectangle($deviceBg, 50, 90, 480, 890)
    $g.DrawRectangle($devicePen, 50, 90, 480, 890)
    $g.DrawString("📱 Farmer Mobile Device (Android / iOS)", $boxFont, $blackBrush, 70, 105)

    function Draw-Box($x, $y, $w, $h, $title, $items) {
        $g.FillRectangle($compBg, $x, $y, $w, $h)
        $g.DrawRectangle($compPen, $x, $y, $w, $h)
        $g.DrawString($title, $boxFont, $blackBrush, [float]($x + 10), [float]($y + 10))
        $iy = $y + 35
        foreach ($it in $items) {
            $g.DrawString($it, $itemFont, $blackBrush, [float]($x + 15), [float]$iy)
            $iy += 18
        }
    }

    # Flutter App Subsystems
    Draw-Box 80 145 420 120 "Presentation Layer" @(
        "- UI Screens (Camera, History, Advisor, Planner)",
        "- Theme & Design System (ThemeData, no hardcoded colors)",
        "- Connectivity Aware States (Online / Offline indicators)"
    )

    Draw-Box 80 280 420 110 "State Management & DI (Riverpod)" @(
        "- Feature Providers (auth, diagnosis, planner, weather)",
        "- USE_FAKES Environment Toggle Switch",
        "- AsyncNotifier & StateNotifier Architecture"
    )

    Draw-Box 80 405 420 140 "Data & Persistence Layer" @(
        "- Repository Implementations (Real vs Fake)",
        "- Cloud Firestore Offline Persistence (LRU Cache)",
        "- Local Cache (Weather Cache, Pending Upload Sync)",
        "- Storage Service (Image Compression & Transfer)"
    )

    Draw-Box 80 560 420 170 "On-Device Edge ML Subsystem" @(
        "- TensorFlow Lite Runtime Interpreter",
        "- Quantized Edge Classifier (model.tflite)",
        "- Disease Class Labels (labels.txt)",
        "- Preprocessing & Normalization Pipeline",
        "- Zero Network Requirement for Inference"
    )

    Draw-Box 80 745 420 100 "Push Notification Receiver" @(
        "- FCM Mobile Client SDK",
        "- Local Notification Presenter (Background/Foreground)"
    )

    # 2. Firebase Cloud Ecosystem
    $g.FillRectangle($cloudBg, 580, 90, 540, 890)
    $g.DrawRectangle($cloudPen, 580, 90, 540, 890)
    $g.DrawString("☁️ Firebase Cloud Backend (agrovision-dev / agrovision-prod)", $boxFont, $blackBrush, 600, 105)

    Draw-Box 610 145 480 95 "Firebase Authentication" @(
        "- Email & Password Provider",
        "- JWT Token Verification & User UID Management"
    )

    Draw-Box 610 255 480 160 "Cloud Firestore (NoSQL Document Store)" @(
        "- users, cropProfiles, diagnoses",
        "- plantingRecommendations, irrigationSchedules",
        "- weatherCache (Region-keyed documents)",
        "- outbreakAlerts (Privacy-safe centroid & radius)",
        "- notifications, decisionLogs (Spec addition)"
    )

    Draw-Box 610 430 480 95 "Cloud Storage for Firebase" @(
        "- High-resolution Leaf Photo Store",
        "- Secure Storage Bucket Rules & URLs"
    )

    Draw-Box 610 540 480 200 "Cloud Functions (TypeScript / Node 20)" @(
        "1. getWeatherForecast : HTTPS Callable (Cache check + API)",
        "2. refreshWeatherCache : Hourly Scheduled Pub/Sub Cron",
        "3. onDiagnosisCreated : Firestore Trigger",
        "   - Density-based spatial clustering (geohash, radius)",
        "   - Creates outbreakAlerts document on threshold",
        "4. onOutbreakAlertCreated : Firestore Trigger",
        "   - Queries affected users within radius",
        "   - Dispatches multicast FCM push notifications"
    )

    Draw-Box 610 755 480 95 "Firebase Cloud Messaging (FCM)" @(
        "- High-priority Outbreak Surveillance Alerts",
        "- Device Token Registration & Management"
    )

    # 3. External Cloud APIs
    $g.FillRectangle($extBg, 1170, 90, 280, 890)
    $g.DrawRectangle($extPen, 1170, 90, 280, 890)
    $g.DrawString("🌐 External Third-Party APIs", $boxFont, $blackBrush, 1190, 105)

    Draw-Box 1190 300 240 180 "OpenWeatherMap API" @(
        "- 5-day / 3-hour Forecasts",
        "- Rain, Humidity, Temp",
        "- Protected by Server-Side",
        "  OPENWEATHER_API_KEY",
        "  in Cloud Functions .env"
    )

    # Connecting Lines
    $g.DrawLine($linePen, 500, 200, 610, 200) # Auth
    $g.DrawLine($linePen, 500, 470, 610, 330) # Firestore
    $g.DrawLine($linePen, 500, 480, 610, 475) # Storage
    $g.DrawLine($linePen, 500, 490, 610, 590) # Callable Fn
    $g.DrawLine($linePen, 610, 790, 500, 790) # FCM
    $g.DrawLine($linePen, 1090, 600, 1190, 390) # Functions to Weather API

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $outputPath"
}

function Render-SequenceDiagram {
    param([string]$outputPath)
    $bmp = New-Object System.Drawing.Bitmap 1500, 1100
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::White)

    $titleFont = [System.Drawing.Font]::new("Arial", [float]16, [System.Drawing.FontStyle]::Bold)
    $subtitleFont = [System.Drawing.Font]::new("Arial", [float]10, [System.Drawing.FontStyle]::Regular)
    $lifelineFont = [System.Drawing.Font]::new("Arial", [float]9.5, [System.Drawing.FontStyle]::Bold)
    $stepFont = [System.Drawing.Font]::new("Arial", [float]8.5, [System.Drawing.FontStyle]::Regular)
    $phaseFont = [System.Drawing.Font]::new("Arial", [float]11, [System.Drawing.FontStyle]::Bold)

    $blackBrush = [System.Drawing.Brushes]::Black
    $blueBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(41, 128, 185))
    $grayBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(100, 100, 100))
    $lifelineBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 245, 255))
    $phaseBg = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(254, 249, 231))

    $borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(52, 73, 94), [float]1.5)
    $dashPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 180, 180), [float]1)
    $dashPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    $arrowPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(44, 62, 80), [float]1.5)

    # Title
    $g.DrawString("AgroVision - End-to-End Sequence Diagram", $titleFont, $blackBrush, 50, 20)
    $g.DrawString("Scan, On-Device Diagnose, Save/Sync, and Outbreak Detection & Alert Distribution Flow", $subtitleFont, $grayBrush, 50, 50)

    # Lifeline participants
    $participants = @(
        @{ Name = "Farmer"; Desc = "Actor"; X = 100 },
        @{ Name = "AgroVision UI"; Desc = "Flutter View"; X = 270 },
        @{ Name = "DiagnosisNotifier"; Desc = "Riverpod Provider"; X = 470 },
        @{ Name = "TFLite Classifier"; Desc = "Edge ML Engine"; X = 670 },
        @{ Name = "DiagnosisRepo"; Desc = "Data Layer"; X = 870 },
        @{ Name = "Cloud Firestore"; Desc = "NoSQL DB"; X = 1070 },
        @{ Name = "Cloud Functions"; Desc = "Outbreak Triggers"; X = 1270 },
        @{ Name = "FCM / Neighbors"; Desc = "Push & Community"; X = 1420 }
    )

    foreach ($p in $participants) {
        $x = $p.X - 65
        $g.FillRectangle($lifelineBg, $x, 90, 130, 45)
        $g.DrawRectangle($borderPen, $x, 90, 130, 45)
        
        $sf = [System.Drawing.StringFormat]::new()
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = [System.Drawing.RectangleF]::new([float]$x, [float]90, [float]130, [float]45)
        $text = "$($p.Name)`n($($p.Desc))"
        $g.DrawString($text, $lifelineFont, $blackBrush, $rect, $sf)

        $g.DrawLine($dashPen, $p.X, 135, $p.X, 1040)
    }

    function Draw-Msg($x1, $x2, $y, $text, $isReturn = $false) {
        $p = if ($isReturn) {
            $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(41, 128, 185), [float]1.5)
            $pen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
            $pen
        } else {
            $arrowPen
        }
        $g.DrawLine($p, $x1, $y, $x2, $y)
        # Arrowhead
        $dir = if ($x2 -gt $x1) { -1 } else { 1 }
        $g.DrawLine($arrowPen, $x2, $y, $x2 + (8 * $dir), $y - 4)
        $g.DrawLine($arrowPen, $x2, $y, $x2 + (8 * $dir), $y + 4)

        $tx = [Math]::Min($x1, $x2) + 10
        $g.DrawString($text, $stepFont, $blackBrush, [float]$tx, [float]($y - 15))
    }

    function Draw-PhaseBanner($y, $title) {
        $g.FillRectangle($phaseBg, 60, $y, 1380, 28)
        $g.DrawRectangle($borderPen, 60, $y, 1380, 28)
        $g.DrawString($title, $phaseFont, $blackBrush, [float]75, [float]($y + 5))
    }

    # Phase 1: On-Device Diagnosis
    Draw-PhaseBanner 155 "PHASE 1: ON-DEVICE EDGE DIAGNOSIS (100% Offline Capable)"
    Draw-Msg 100 270 205 "1. Capture leaf photo (Tomato / Chilli / Brinjal / Potato)"
    Draw-Msg 270 470 235 "2. Request diagnosis(imagePath)"
    Draw-Msg 470 670 265 "3. classifyImage(imageBytes)"
    $g.DrawString("[Edge Inference]: TFLite quantized tensor execution (<100ms)", $stepFont, $grayBrush, [float]680, [float]285)
    Draw-Msg 670 470 315 "4. Return result: class='Early Blight', conf=0.94" $true
    Draw-Msg 470 270 345 "5. Render diagnosis result, treatment & preventive actions" $true

    # Phase 2: Save & Sync
    Draw-PhaseBanner 375 "PHASE 2: PERSISTENCE & CLOUD SYNCHRONIZATION"
    Draw-Msg 100 270 425 "6. Tap 'Save Diagnosis to History'"
    Draw-Msg 270 470 455 "7. saveDiagnosis(record)"
    Draw-Msg 470 870 485 "8. createDiagnosis(entity, imageFile)"
    $g.DrawString("[Offline Cache]: Instantly committed to local Firestore SQLite persistence", $stepFont, $grayBrush, [float]880, [float]505)
    Draw-Msg 870 1070 535 "9. Sync to /diagnoses collection (userId, location, geohash, imageUrl)"
    Draw-Msg 1070 870 565 "10. Write acknowledged" $true
    Draw-Msg 870 270 595 "11. Diagnosis persisted and viewable in History timeline" $true

    # Phase 3: Outbreak Detection
    Draw-PhaseBanner 625 "PHASE 3: OUTBREAK DETECTION TRIGGER (Serverless Spatial Clustering)"
    Draw-Msg 1070 1270 675 "12. Firestore Event: onCreate(/diagnoses/{diagnosisId})"
    $g.DrawString("[Trigger: onDiagnosisCreated]: Loads OUTBREAK_RADIUS_KM (10km), OUTBREAK_MIN_REPORTS (5)", $stepFont, $grayBrush, [float]1080, [float]695)
    Draw-Msg 1270 1070 725 "13. Query recent cases of same disease within geohash cluster"
    Draw-Msg 1070 1270 755 "14. Return matching diagnosis records" $true
    $g.DrawString("[Cluster Evaluation]: Threshold met (6 reports in 48h) -> Calculate obfuscated centroid", $stepFont, $grayBrush, [float]1080, [float]775)
    Draw-Msg 1270 1070 805 "15. Create /outbreakAlerts document (diseaseType, centerPoint, radiusKm)"
    Draw-Msg 1070 1270 835 "16. Alert document created" $true

    # Phase 4: Push Alert Distribution
    Draw-PhaseBanner 865 "PHASE 4: PRIVACY-PRESERVING PUSH NOTIFICATION DISPATCH"
    Draw-Msg 1070 1270 915 "17. Firestore Event: onCreate(/outbreakAlerts/{alertId})"
    $g.DrawString("[Trigger: onOutbreakAlertCreated]: Queries users within alert radius; preserves farmer privacy", $stepFont, $grayBrush, [float]1080, [float]935)
    Draw-Msg 1270 1070 965 "18. Batch create /notifications records for affected farmers"
    Draw-Msg 1270 1420 995 "19. FCM Multicast Push: 'Early Blight Outbreak Alert within 10 km'"
    Draw-Msg 1420 1420 1025 "20. Deliver background & foreground alert notifications to community"

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $outputPath"
}

# Run generation
$diagramDir = "c:\Users\ASUS\Downloads\AgroVision_All_Prompt_Files\backend\AgroVision\docs\report\diagrams"
Render-UseCaseDiagram (Join-Path $diagramDir "use_case_diagram.png")
Render-ClassDataModelDiagram (Join-Path $diagramDir "class_data_model_diagram.png")
Render-DeploymentArchitectureDiagram (Join-Path $diagramDir "deployment_architecture_diagram.png")
Render-SequenceDiagram (Join-Path $diagramDir "sequence_diagram_diagnosis_outbreak.png")
