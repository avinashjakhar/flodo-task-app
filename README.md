# Flodo Task Management App

A full-stack task management application built with **Flutter** (frontend) and **FastAPI + SQLite/PostgreSQL** (backend).

---

## Track & Stretch Goal

- **Track A** — Full-Stack Builder (Flutter + Python FastAPI + SQLite/PostgreSQL)
- **Stretch Goal** — Debounced Autocomplete Search with highlighted match text

---

## Architecture Overview

```
flodo_task_app/
├── backend/                   # Python FastAPI
│   ├── main.py                # App entrypoint + CORS
│   ├── database.py            # SQLAlchemy engine + session
│   ├── models.py              # ORM model (Task, TaskStatus enum)
│   ├── schemas.py             # Pydantic request/response schemas
│   ├── routers/
│   │   └── tasks.py           # All CRUD endpoints + autocomplete
│   ├── requirements.txt
│   └── Dockerfile
│
├── flutter_app/
│   ├── pubspec.yaml
│   └── lib/
│       ├── main.dart
│       ├── models/
│       │   ├── task.dart          # Freezed data models (Task, TaskDraft, enums)
│       │   ├── task.freezed.dart  # Generated
│       │   └── task.g.dart        # Generated JSON serialization
│       ├── services/
│       │   ├── task_api_service.dart   # Dio HTTP client
│       │   └── draft_service.dart      # SharedPreferences draft persistence
│       ├── providers/
│       │   └── task_providers.dart     # Riverpod providers + notifiers
│       ├── screens/
│       │   ├── task_list_screen.dart   # Main list + search + filters
│       │   └── task_form_screen.dart   # Create / Edit form
│       ├── widgets/
│       │   ├── task_card.dart          # Task card with blocked-state UI
│       │   ├── status_badge.dart       # Coloured status chip
│       │   └── highlighted_text.dart   # Search highlight renderer
│       └── theme/
│           └── app_theme.dart          # Dark editorial theme
│
└── docker-compose.yml
```

---

## Setup Instructions

### Prerequisites

| Tool | Version |
|------|---------|
| Python | 3.11+ |
| Flutter SDK | 3.19+ |
| Dart SDK | 3.3+ |
| Android Studio / Xcode | For emulator |

---

### 1. Backend Setup

#### Option A — Docker (recommended)

```bash
cd flodo_task_app
docker-compose up --build
```

The API will be available at `http://localhost:8000`.  
Interactive docs: `http://localhost:8000/docs`

#### Option B — Manual

```bash
cd flodo_task_app/backend

# Create virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
uvicorn main:app --reload --port 8000
```

#### PostgreSQL (optional)

Set the environment variable before starting:

```bash
export DATABASE_URL=postgresql://user:password@localhost/flodo_tasks
uvicorn main:app --reload --port 8000
```

---

### 2. Flutter App Setup

```bash
cd flodo_task_app/flutter_app

# Install dependencies
flutter pub get
```

#### Configure API Base URL

In `lib/services/task_api_service.dart`, the default base URL is:

```dart
// Android Emulator → 10.0.2.2 maps to your machine's localhost
TaskApiService({String baseUrl = 'http://10.0.2.2:8000/api/v1'})
```

| Platform | URL to use |
|----------|-----------|
| Android Emulator | `http://10.0.2.2:8000/api/v1` |
| iOS Simulator | `http://localhost:8000/api/v1` |
| Physical device | `http://<your-machine-IP>:8000/api/v1` |

#### Run the app

```bash
flutter run
```

---

## Key Technical Decisions

### 1. Async `asyncio.sleep(2)` for the simulated delay

The 2-second save delay uses `await asyncio.sleep(2)` in the FastAPI route handler. Because FastAPI runs on an async event loop (uvicorn + asyncio), this yields control back to the event loop during the wait — so **other requests are served concurrently**. A blocking `time.sleep(2)` would freeze the entire worker thread.

### 2. Riverpod `AsyncNotifier` + `AsyncValue.guard`

All API calls go through `AsyncValue.guard(...)` inside `AsyncNotifier`. This means errors are automatically captured into the `AsyncValue.error` state without crashing the widget tree — the UI can pattern-match on `.when(data, loading, error)` cleanly.

### 3. Draft persistence with debounced `SharedPreferences` write

Every keystroke triggers a `Timer` reset (500 ms debounce) before writing the draft to `SharedPreferences`. This avoids thrashing persistent storage on every character typed, while still preserving the draft reliably if the user swipes away.

### 4. Debounced autocomplete with 300 ms Timer

`AutocompleteNotifier` holds a `Timer` that is cancelled and restarted on each `search(query)` call. The HTTP request only fires after 300 ms of silence — matching the assignment spec exactly. The result is fed into a separate `autocompleteProvider` so it doesn't interfere with the main task list state.

### 5. `HighlightedText` widget for search results

Rather than a package, a custom `RichText` + `TextSpan` builder walks the string, splitting it around case-insensitive matches and rendering each match with `backgroundColor: accentSoft` and `color: accent`. Zero dependencies, fully composable.

### 6. Blocked task visual state

`TaskCard` reads `task.blockedBy?.status`. If the blocker is not `done`, the card is wrapped in `Opacity(0.45)` and a top banner is rendered showing which task is blocking it. No extra API calls — the blocker's status is embedded in the task response payload via the `blocked_by` relation.

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/tasks` | List tasks (supports `?search=` and `?status=`) |
| GET | `/api/v1/tasks/{id}` | Get single task |
| POST | `/api/v1/tasks` | Create task (2s async delay) |
| PUT | `/api/v1/tasks/{id}` | Update task (2s async delay) |
| DELETE | `/api/v1/tasks/{id}` | Delete task |
| GET | `/api/v1/tasks/search/autocomplete?q=` | Autocomplete titles (top 10) |
| GET | `/health` | Health check |

---

## AI Usage Report

### Tools used
Claude (claude.ai) was used throughout this project.

### Prompts that gave the most helpful code

1. **"Generate a FastAPI router for CRUD on a Task model with SQLAlchemy. The create and update routes must use `await asyncio.sleep(2)` to simulate processing delay without blocking the event loop. Include proper error handling with 404s and a cascade-clear when deleting a parent task."**  
   → Produced nearly final-form `routers/tasks.py` in one shot, including the cascade logic.

2. **"Write a Flutter Riverpod AsyncNotifier that wraps an API service, supports search and status filter state in a separate StateNotifier, and exposes create/update/delete methods that each refetch from the server on success."**  
   → Gave the skeleton of `task_providers.dart`. Manual fix needed: the `autoDispose` variant of `AsyncNotifier` has different syntax (`AutoDisposeAsyncNotifier`) — the AI used the wrong base class for the autocomplete notifier.

3. **"Write a Flutter RichText widget that takes a `text` string and a `highlight` substring and renders all matches with a coloured background, case-insensitively."**  
   → Produced `highlighted_text.dart` essentially verbatim.

### Where AI hallucinated / gave bad code

**Issue:** In the Riverpod provider, the AI initially generated:

```dart
// WRONG — AutoDisposeAsyncNotifier requires different syntax in Riverpod 2.x
final autocompleteProvider = AsyncNotifierProvider.autoDispose<...>(...)
```

…but used `AsyncNotifier` as the base class instead of `AutoDisposeAsyncNotifier`. This caused a compile-time type mismatch.

**Fix:** Changed the base class to `AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>` and updated the `build()` return type accordingly. The Riverpod docs (not AI) confirmed the correct pattern.

**Issue 2:** The AI placed the `autocomplete` route at `/tasks/search/autocomplete` but FastAPI matched `/tasks/{task_id}` first because `{task_id}` is a path parameter that also matches the string `"search"`. Requests to `/tasks/search/autocomplete` returned a 422 validation error trying to parse `"search"` as an integer.

**Fix:** Moved the `/tasks/search/autocomplete` route **above** the `/tasks/{task_id}` route in the router file. FastAPI routes are matched in declaration order, so static paths must come before parameterised ones.
