# 🚀 Complete Setup, GitHub & Deployment Guide

---

## PART 1 — Run Locally (Do This First)

### Step 1 — Clone / extract the project

```
flodo_task_app/
├── backend/
├── flutter_app/
├── docker-compose.yml
└── README.md
```

---

### Step 2 — Start the Backend

**Option A — Docker (easiest, no Python needed locally)**

Install Docker Desktop from https://www.docker.com/products/docker-desktop

```bash
cd flodo_task_app
docker-compose up --build
```

API runs at: http://localhost:8000
Swagger docs: http://localhost:8000/docs

---

**Option B — Manual Python**

```bash
cd flodo_task_app/backend

# Create virtual environment
python3 -m venv venv

# Activate it:
#   macOS/Linux:
source venv/bin/activate
#   Windows:
venv\Scripts\activate

# Install packages
pip install -r requirements.txt

# Copy env file
cp .env.example .env

# Start server
uvicorn main:app --reload --port 8000
```

Verify: open http://localhost:8000/health → should return {"status":"ok"}

---

### Step 3 — Set Up Flutter

**Install Flutter SDK** (if not installed):
https://docs.flutter.dev/get-started/install

```bash
cd flodo_task_app/flutter_app

# Get dependencies
flutter pub get

# IMPORTANT: Regenerate Freezed + JSON files
dart run build_runner build --delete-conflicting-outputs
```

---

### Step 4 — Configure the API URL

Open: `flutter_app/lib/services/task_api_service.dart`

Find this line:
```dart
TaskApiService({String baseUrl = 'http://10.0.2.2:8000/api/v1'})
```

Change the URL based on your target:

| Where you're running | URL to use |
|---|---|
| Android Emulator (default) | `http://10.0.2.2:8000/api/v1` |
| iOS Simulator | `http://localhost:8000/api/v1` |
| Physical Android/iOS device | `http://YOUR_MACHINE_IP:8000/api/v1` |
| After deploying to Render/Railway | `https://your-app-name.onrender.com/api/v1` |

To find YOUR_MACHINE_IP:
- macOS: `ipconfig getifaddr en0`
- Linux: `hostname -I`
- Windows: `ipconfig` → look for IPv4 Address

---

### Step 5 — Run the App

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d emulator-5554       # Android emulator
flutter run -d "iPhone 15"         # iOS simulator

# Build release APK
flutter build apk --release
# APK is at: build/app/outputs/flutter-apk/app-release.apk
```

---

## PART 2 — Push to GitHub

### Step 1 — Create a GitHub repository

1. Go to https://github.com/new
2. Repository name: `flodo-task-app`
3. Set to **Public**
4. Do NOT initialize with README (you already have one)
5. Click **Create repository**

---

### Step 2 — Initialize Git and push

```bash
cd flodo_task_app

# Initialize git
git init

# Stage everything
git add .

# First commit
git commit -m "feat: initial full-stack task management app

- FastAPI backend with SQLite/PostgreSQL support
- Flutter frontend with Riverpod state management
- CRUD operations with 2s async save delay
- Debounced autocomplete search with text highlighting
- Draft persistence via SharedPreferences
- Blocked-by task dependency with visual greyed-out state
- Dark editorial theme with Space Grotesk / DM Sans typography"

# Add your GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/flodo-task-app.git

# Push
git branch -M main
git push -u origin main
```

---

### Step 3 — Recommended commit structure going forward

Use atomic, descriptive commits:

```bash
git commit -m "feat: add task creation form with date picker"
git commit -m "fix: autocomplete route ordering conflict with {task_id}"
git commit -m "style: apply dark editorial theme to task cards"
git commit -m "chore: add Android internet permission to manifest"
git commit -m "docs: update README with iOS simulator URL instructions"
```

Prefix guide:
- `feat:` — new feature
- `fix:` — bug fix
- `style:` — UI/visual only
- `refactor:` — code restructure
- `chore:` — config, deps
- `docs:` — documentation only
- `test:` — tests

---

## PART 3 — Deploy the Backend Live (Free)

### Option A — Render.com (recommended, free tier)

1. Go to https://render.com and sign up with GitHub

2. Click **New → Web Service**

3. Connect your `flodo-task-app` GitHub repository

4. Fill in:
   - **Name:** `flodo-task-api`
   - **Root Directory:** `backend`
   - **Environment:** `Python 3`
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`

5. Under **Environment Variables**, add:
   - Key: `DATABASE_URL`
   - Value: `sqlite:///./tasks.db` (or add a Render PostgreSQL database and paste its URL)

6. Click **Create Web Service**

7. Wait ~3 minutes. Your API will be live at:
   `https://flodo-task-api.onrender.com`

8. Test it: `https://flodo-task-api.onrender.com/health`

---

### Option B — Railway.app (alternative)

1. Go to https://railway.app and sign up with GitHub

2. Click **New Project → Deploy from GitHub repo**

3. Select your repository

4. Railway auto-detects Python. Set:
   - **Root Directory:** `backend`
   - **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`

5. Add environment variable:
   - `DATABASE_URL` = `sqlite:///./tasks.db`

6. Click **Deploy**. Live in ~2 minutes at:
   `https://flodo-task-app-production.up.railway.app`

---

### Step — Update Flutter to use the live URL

After deploying, open:
`flutter_app/lib/services/task_api_service.dart`

Change:
```dart
// Before (local)
TaskApiService({String baseUrl = 'http://10.0.2.2:8000/api/v1'})

// After (live Render URL — replace with yours)
TaskApiService({String baseUrl = 'https://flodo-task-api.onrender.com/api/v1'})
```

Then rebuild:
```bash
flutter build apk --release
# or
flutter run
```

---

## PART 4 — Database: Upgrade to PostgreSQL (Optional)

### On Render

1. In your Render dashboard → **New → PostgreSQL**
2. Name it `flodo-db`, click **Create**
3. Copy the **Internal Database URL**
4. Go to your Web Service → Environment → update `DATABASE_URL` with the PostgreSQL URL
5. Redeploy

### On Railway

1. In your project → **New → Database → PostgreSQL**
2. Railway auto-injects `DATABASE_URL` into your service — nothing else to do

SQLite works fine for the assignment. PostgreSQL is only needed if you want data to persist across Render's free-tier restarts (free tier spins down and loses the SQLite file).

---

## PART 5 — Quick Troubleshooting

| Problem | Fix |
|---|---|
| `flutter pub get` fails | Run `flutter upgrade` then try again |
| `build_runner` errors | Delete `.dart_tool/` folder, run `flutter clean`, then `dart run build_runner build --delete-conflicting-outputs` |
| Android: network error | Check `android:usesCleartextTraffic="true"` is in AndroidManifest.xml |
| iOS: network error | Check `NSAllowsLocalNetworking: true` in Info.plist |
| Backend 422 on autocomplete | The `/search/autocomplete` route must be ABOVE `/{task_id}` in `routers/tasks.py` |
| Render: app sleeps after 15 min | Free tier behavior. Use UptimeRobot to ping `/health` every 10 min to keep it awake |
| `port 8000 already in use` | `lsof -ti:8000 \| xargs kill` (macOS/Linux) or `netstat -ano \| findstr 8000` (Windows) |

---

## PART 6 — Record the Demo Video

Requirements per the assignment:
- Max 60–90 seconds
- Show: create task, edit task, delete task, blocked-by state, search autocomplete
- Mention one technical decision (suggest: the async `asyncio.sleep` or the debounce Timer)
- Upload to Google Drive, share with `nilay@flodo.ai`

Recommended free tools:
- **macOS:** QuickTime Player → File → New Screen Recording
- **Windows:** Win+G (Game Bar) → Record
- **Any OS:** OBS Studio (free, https://obsproject.com)

Script suggestion (60 sec):
1. (0–10s) Show app loading with task list
2. (10–25s) Create a new task — show loading spinner during 2s delay
3. (25–35s) Search tasks — show autocomplete dropdown with highlighted text
4. (35–45s) Set one task as "Blocked By" another — show greyed-out card
5. (45–55s) Mark the blocker as "Done" — show blocked task become active
6. (55–60s) Brief verbal: "The 2-second delay uses asyncio.sleep which is non-blocking — other requests are served concurrently during the wait."
