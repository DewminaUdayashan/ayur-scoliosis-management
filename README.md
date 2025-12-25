# SpineAlign — Ayurvedic Scoliosis Management (Frontend)

Updated and expanded README tailored for research use: an overview of the frontend, the tech stack, architecture, main integrations (WebRTC, Socket.IO), state management, and how key parts are used.

## Abstract

SpineAlign is a Flutter-based mobile frontend developed as part of a research project on Ayurvedic scoliosis management. It provides clinicians and patients with appointment management, telemedicine (peer-to-peer video consultations), session tracking with note-taking, X-ray measurement tools, and real-time notifications. This README summarizes the frontend architecture, the tools and libraries used, where they appear in the codebase, and short descriptions of how they are used — useful for inclusion in a research paper.

## Quick facts

- Platform: Flutter (cross-platform mobile)
- Primary languages: Dart
- Key integrations: WebRTC (media) + Socket.IO (signaling), REST API (Dio)
- State management: Riverpod (hooks + generator)
- Repository branch: main

---

## High-level architecture

The frontend follows a layered architecture combining MVVM-like separation with a Repository/Service layer. Main layers:

- UI layer (screens + widgets): presentation and interaction
- State layer (Riverpod providers / notifiers): single source of truth
- Service layer (API clients, WebRTC service, signaling): business logic and platform interactions
- Data layer (Dio HTTP, Socket.IO, local secure storage)

Data flow (simplified): UI → Riverpod providers (StateNotifier / AsyncNotifier) → Services → Backend / Signaling / WebRTC → Providers → UI

---

## Main features (what the frontend implements)

- Authentication (login, OTP, token management)
- Appointment management (scheduling, calendar, join/complete actions)
- Telemedicine: peer-to-peer video calls per appointment
- Session management: global active session state, draggable notes indicator, save/complete workflows
- X-ray measurement tools (Cobb angle measurement, annotations)
- Real-time events & notifications via Socket.IO
- Secure local storage for tokens and sensitive data

---

## Technologies and how they're used (concise)

- Flutter (UI): The entire UI is implemented with Flutter widgets and uses hooks for lifecycle state (flutter_hooks + hooks_riverpod). Screens live under `lib/screens`.

- Riverpod (state management): Centralized state via `StateNotifierProvider`, `AsyncNotifierProvider`, and `Provider` for DI. The session management, appointment details, profile, and video call state are all Riverpod-based and live under `lib/providers`.

- WebRTC (flutter_webrtc): Handles local/remote media, peer connection, rendering streams. Implemented in `lib/services/video_call/webrtc_service.dart` and consumed by a `video_call` provider; the call UI is in `lib/screens/video_call/video_call_screen.dart`.

- Socket.IO (signaling): Used for negotiation and event broadcasting (offer/answer/ICE candidates, room events). Implemented in a signaling service and used by the WebRTC service to exchange SDPs and candidates.

- Dio (HTTP client): REST API communication with the backend. Uses interceptors for authentication and logging. Appointment completion (with notes) and other resources are handled via service classes under `lib/services/appointment/`.

- JSON Serializable / Annotations: Model generation and JSON serialization for safe payload handling.

- Flutter Secure Storage: Encrypted local token storage (keychain/keystore).

- GoRouter: Declarative navigation and route definitions (type-safe routing and deep links).

- UI libs: Google Fonts (Poppins), CupertinoIcons, CachedNetworkImage, Shimmer for UX polish and caching.

---

## Key components and where to look in the repo

- Entry point: `lib/main.dart` — sets up providers and the `AppLayoutWrapper` (global floating indicators).
- Routing: `lib/core/app_router.dart` — route definitions and wrapper attachments.
- Session state: `lib/providers/session/active_session.dart` — manages global active session (start, update notes, end).
- Session notes UI: `lib/widgets/session_notes_floating_indicator.dart` — draggable indicator, notes dialog, complete-with-notes workflow.
- Video call: `lib/screens/video_call/video_call_screen.dart` — WebRTC renderers, call controls, integrates with `active_session` to complete session on call end.
- Video signaling & services: `lib/services/video_call/` — signaling and WebRTC handling.
- Appointments: `lib/providers/appointment/appointment_details.dart` and `lib/screens/appointment_details/` — appointment actions (start/complete/join).
- X-ray measurement: `lib/screens/measurement/xray_measure_screen.dart` and `lib/services/xray/` — measurement tools and vector math.

---

## Session management — short explanation for research

Purpose: Provide a unified, global session concept so practitioners cannot start multiple sessions concurrently and can take time-stamped notes during both physical and remote visits.

How it works (high level):

- An `ActiveSession` model (appointmentId, appointmentType, startTime, notes).
- A `StateNotifier` (`activeSessionProvider`) holds the active session and exposes start/update/end methods.
- UI: a global `SessionNotesFloatingIndicator` (rendered via `AppLayoutWrapper`) is visible when an active session exists. The indicator is draggable and opens a notes dialog.
- Completion flow: notes are sent to backend via `PATCH /appointments/:id/notes` and appointment completion via `PATCH /appointments/:id/complete`. The provider coordinates the API call and local state cleanup.

Why this approach: Keeps session logic separate from individual screens, ensures a single authoritative source of truth, and makes it easy to surface a single UI element (notes) across multiple screens including the video call.

---

## Video call integration — short explanation for research

- Signaling: Socket.IO server coordinates room joins and SDP/ICE exchange. The app connects to the signaling server when the practitioner/patient joins a room.
- Media: `flutter_webrtc` handles getUserMedia, RTCPeerConnection setup, adding local tracks and rendering remote streams.
- UI: A draggable local preview and fullscreen remote render are provided; typical controls include mute, camera toggle, switch camera, and end call.
- Lifecycle integration: When a practitioner joins the call, the frontend starts a remote `ActiveSession`. When the call ends (manually or due to disconnect), the app prompts to save notes (if available) and completes the session. This ensures notes are persisted and appointment state is updated.

---

## Backend API interactions (important endpoints)

- Authentication: `/auth/login`, `/auth/register`, `/auth/verify-otp` — tokens retrieved and stored securely.
- Appointments: `/appointments`, `/appointments/:id` — query and mutate appointment data.
- Complete & notes: `PATCH /appointments/:id/notes` (save notes) and `PATCH /appointments/:id/complete` (mark complete, optionally with notes payload).
- Video call rooms: `/video-calls/appointment/:appointmentId` — create or fetch room associated with an appointment.

All HTTP requests go through `Dio` with authentication interceptors.

---

## Security considerations (summary)

- Tokens stored via Flutter Secure Storage (iOS Keychain / Android Keystore).
- All API calls assumed over HTTPS and protected with token authentication.
- WebRTC traffic is end-to-end SRTP; STUN/TURN servers used for connectivity.
- Access control: room join and appointment actions validated on the backend (practitioner vs patient roles).

---

## Development & setup (concise)

Prerequisites: Flutter SDK (3.8.1+), Android/iOS tooling, `flutter pub`.

Steps:

1. Clone repository and install deps:

```bash
git clone <repo-url>
cd ayur_scoliosis_management
flutter pub get
```

2. Generate code (Riverpod & JSON models):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Configure backend base URL in `lib/core/utils/api.dart` and any signaling settings.

4. Run app:

```bash
flutter run
```

Notes: For video calls, ensure signaling server URL and any TURN credentials are configured in environment or `lib/core/utils/api.dart`.

---

## How to cite / use in research

If you include this frontend in a research paper, mention key integrative points:

- The frontend demonstrates a practical integration of WebRTC for peer-to-peer telemedicine combined with Socket.IO signaling.
- Session management is used as an example of global state coordination for clinical workflows (single active session enforcement, saved notes).
- The codebase shows a modern Riverpod-based architecture suitable for research reproducibility and extension.

Suggested citation snippet (adapt as necessary):

"SpineAlign — a Flutter-based frontend for Ayurvedic scoliosis management integrating peer-to-peer WebRTC video consultations with Socket.IO signaling and Riverpod state management."

---

## Contact

- Developer: Dewmina Udayashan — see repository: https://github.com/DewminaUdayashan/ayur-scoliosis-management

---

This README is crafted to be concise yet detailed enough for inclusion in a research paper. If you want, I can expand any one section (e.g., session management internals, provider API signatures, or WebRTC signaling flow diagrams) into a separate appendix for the paper.
