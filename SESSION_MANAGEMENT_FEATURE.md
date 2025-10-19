# Session Management with Notes Feature

## Overview
Comprehensive session management system that allows practitioners to take notes during both physical and remote appointments, with a floating UI indicator that doesn't conflict with the video call indicator.

## Features Implemented

### 1. Session State Management
**File:** `lib/providers/session/active_session.dart`

**Description:** Global state management for active sessions (physical or remote)

**Implementation:**
- `ActiveSession` class stores:
  - `appointmentId`: Links session to specific appointment
  - `appointmentType`: 'Physical' or 'Remote'
  - `startTime`: For tracking session duration
  - `notes`: Real-time note updates

- `ActiveSessionNotifier` provides methods:
  - `startSession()`: Initiates a session
  - `updateNotes()`: Updates notes in real-time
  - `endSession()`: Clears session state
  - `isSessionActive()`: Checks if session is active

### 2. Session Notes Floating Indicator
**File:** `lib/widgets/session_notes_floating_indicator.dart`

**Description:** Draggable floating button for session note-taking

**Features:**
- **Position:** Bottom-left (opposite of video call indicator)
- **Visual Differentiation:**
  - Blue gradient for Physical sessions
  - Orange gradient for Remote sessions
- **Pulsing Icon:**
  - Empty pencil icon when no notes
  - Filled pencil icon when notes exist
- **Draggable:** Can be moved anywhere on screen

**User Flow:**
1. Tap floating icon to open notes dialog
2. Dialog shows:
   - Session type icon and title
   - Session duration (hours and minutes)
   - Multi-line text field for notes
   - "Close" button to continue session
   - "End Session" button to complete
3. Notes update in real-time as practitioner types
4. When ending session, shows confirmation dialog:
   - "End Without Saving" - Ends session, discards notes
   - "Save & Complete" - Saves notes and marks appointment as completed

### 3. Backend Integration

#### API Endpoints
**File:** `lib/core/utils/api.dart`

Added:
```dart
String updateAppointmentNotes(String id) => '$appointmentsPath/$id/notes';
```

#### Service Layer
**Files:**
- `lib/services/appointment/appointment_service.dart`
- `lib/services/appointment/appointment_service_impl.dart`

Added:
```dart
Future<Appointment> completeAppointmentWithNotes(
  String appointmentId,
  String notes,
);
```

**Implementation:**
1. Updates notes via PATCH `/appointments/:id/notes`
2. Completes appointment via PATCH `/appointments/:id/complete`
3. Returns updated appointment

#### Provider Layer
**File:** `lib/providers/appointment/appointment_details.dart`

Added:
```dart
Future<void> completeWithNotes(String notes) async
```

- Updates appointment state
- Invalidates relevant providers
- Shows error messages on failure

### 4. Session Start Integration

#### Appointment Details Screen
**File:** `lib/screens/appointment_details/widgets/appointment_action_button.dart`

**Physical Appointments:**
- "Start Session" button starts session immediately
- Shows notification: "Physical session started. Tap the floating icon to add notes."
- Session state stored locally until completion

**Remote Appointments:**
- "Join Call" button now also starts session
- Session automatically starts when joining video call
- Notes indicator appears alongside video call indicator

### 5. Global UI Integration
**File:** `lib/widgets/app_layout_wrapper.dart`

Added `SessionNotesFloatingIndicator` to global Stack:
```dart
Stack(
  children: [
    child, // Screen content
    const VideoCallFloatingIndicator(), // Bottom-right
    const SessionNotesFloatingIndicator(), // Bottom-left
  ],
)
```

**Positioning Strategy:**
- Video Call Indicator: Bottom-right (green)
- Session Notes Indicator: Bottom-left (blue/orange)
- No overlap or conflict between indicators
- Both draggable independently

## Technical Implementation Details

### State Management
- Uses Riverpod `StateNotifierProvider` for session state
- Global state accessible throughout the app
- Automatically shows/hides indicator based on active session

### Note Persistence
- Notes stored in memory during session
- Only persisted to backend when "Save & Complete" is clicked
- Allows practitioners to discard notes if needed

### Session Duration
- Calculated in real-time from `startTime`
- Displayed in notes dialog
- Format: "Xh Ym"

### Error Handling
- Try-catch blocks around all API calls
- Loading indicators during async operations
- User-friendly error messages via SnackBar
- Session state preserved on error

## User Flows

### Physical Appointment Flow
1. Practitioner opens appointment details
2. Clicks "Start Session" button
3. Session starts, notification shown
4. Blue floating indicator appears (bottom-left)
5. Practitioner navigates app freely
6. Taps indicator when ready to add notes
7. Types notes in dialog
8. Clicks "End Session"
9. Chooses "Save & Complete" or "End Without Saving"
10. If saved, appointment marked as completed with notes

### Remote Appointment Flow
1. Practitioner opens appointment details
2. Clicks "Join Call" button
3. Video call starts AND session starts
4. Both indicators visible:
   - Green video call indicator (bottom-right)
   - Orange session notes indicator (bottom-left)
5. During call, can tap notes indicator anytime
6. After call, can complete with notes via notes indicator

## Files Created/Modified

**Created:**
1. `lib/providers/session/active_session.dart` - Session state management
2. `lib/widgets/session_notes_floating_indicator.dart` - Floating notes UI

**Modified:**
1. `lib/widgets/app_layout_wrapper.dart` - Added notes indicator to global UI
2. `lib/core/utils/api.dart` - Added update notes endpoint
3. `lib/services/appointment/appointment_service.dart` - Added complete with notes interface
4. `lib/services/appointment/appointment_service_impl.dart` - Implemented complete with notes
5. `lib/providers/appointment/appointment_details.dart` - Added completeWithNotes method
6. `lib/screens/appointment_details/widgets/appointment_action_button.dart` - Added session start logic

## Backend Requirements

### Endpoints Needed

1. **Update Appointment Notes**
   ```
   PATCH /appointments/:id/notes
   Body: { "notes": "string" }
   ```
   - Updates the notes field
   - Practitioner only
   - Returns updated appointment

2. **Complete Appointment** (already exists)
   ```
   PATCH /appointments/:id/complete
   ```
   - Marks appointment as completed
   - Sends notification to patient

### Database Schema
Appointment model should have:
- `notes`: Text field for session notes
- Accessible by practitioner
- Displayed in appointment history

## Testing Recommendations

### Test Cases

**Session State:**
- [ ] Physical session starts correctly
- [ ] Remote session starts with video call
- [ ] Only one session active at a time
- [ ] Session state persists across navigation
- [ ] Session ends correctly

**UI Indicators:**
- [ ] Notes indicator appears when session active
- [ ] Notes indicator hides when no session
- [ ] Draggable without conflicting with video indicator
- [ ] Correct colors for physical (blue) vs remote (orange)
- [ ] Icon changes when notes exist

**Note Taking:**
- [ ] Dialog opens on tap
- [ ] Notes update in real-time
- [ ] Session duration displays correctly
- [ ] Can close dialog without ending session
- [ ] End session shows confirmation

**Completion:**
- [ ] End without saving discards notes
- [ ] Save & complete sends notes to backend
- [ ] Appointment marked as completed
- [ ] Loading indicator shows during save
- [ ] Error handling works correctly

**Integration:**
- [ ] Both indicators visible for remote sessions
- [ ] Physical sessions show only notes indicator
- [ ] Navigation works with active sessions
- [ ] Session cleared after completion

## Future Enhancements

1. **Auto-save Notes:** Periodically save notes to prevent loss
2. **Template Notes:** Pre-defined note templates for common scenarios
3. **Voice-to-Text:** Voice input for hands-free note-taking
4. **Rich Text:** Bold, bullets, formatting in notes
5. **Session Summary:** Export session summary with notes
6. **History View:** View notes from previous sessions
7. **Collaborative Notes:** Multiple practitioners can contribute
8. **Time-stamped Entries:** Notes with timestamps during session

## Known Limitations

1. Notes only stored in memory during session
2. No auto-save (must complete to persist)
3. Single session at a time per practitioner
4. No offline support
5. Notes field is plain text only

## Migration Notes

No database migrations needed if backend already has notes field. If not, add:
```sql
ALTER TABLE appointments ADD COLUMN notes TEXT;
```
