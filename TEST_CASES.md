# SpineAlign - Ayurvedic Scoliosis Management System
## Comprehensive Test Case Document

**Project:** SpineAlign - Ayurvedic Scoliosis Management (Frontend)  
**Version:** 1.0.0  
**Platform:** Flutter (iOS & Android)  
**Date:** November 14, 2025  
**Document Type:** Test Case Specification

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Testing Scope](#2-testing-scope)
3. [Test Environment](#3-test-environment)
4. [Authentication & Registration](#4-authentication--registration)
5. [Appointment Management](#5-appointment-management)
6. [Session Management](#6-session-management)
7. [Video Call (WebRTC)](#7-video-call-webrtc)
8. [Patient Management](#8-patient-management)
9. [X-Ray Management & Cobb Angle Measurement](#9-x-ray-management--cobb-angle-measurement)
10. [Real-Time Notifications](#10-real-time-notifications)
11. [UI/UX Components](#11-uiux-components)
12. [Security & Data Privacy](#12-security--data-privacy)
13. [Integration Testing](#13-integration-testing)
14. [Performance Testing](#14-performance-testing)
15. [Cross-Platform Testing](#15-cross-platform-testing)

---

## 1. Introduction

### 1.1 Purpose
This document outlines comprehensive test cases for the SpineAlign mobile application, covering all major features including authentication, appointment scheduling, telemedicine (WebRTC video calls), session management, X-ray analysis, and patient management.

### 1.2 Objectives
- Ensure all features work as intended across iOS and Android platforms
- Validate security measures and data privacy compliance
- Verify integration with backend REST API and Socket.IO services
- Test WebRTC peer-to-peer video communication
- Validate state management and UI/UX consistency

### 1.3 Testing Approach
- **Manual Testing:** User interface, user experience, and workflow validation
- **Functional Testing:** Feature-level validation
- **Integration Testing:** Backend API and third-party service integration
- **Security Testing:** Authentication, authorization, and data protection
- **Performance Testing:** Load times, video call quality, and responsiveness

---

## 2. Testing Scope

### 2.1 In Scope
✅ Practitioner registration and authentication  
✅ Patient invitation and management  
✅ Appointment scheduling and management  
✅ Calendar integration  
✅ Video call functionality (WebRTC)  
✅ Session notes and completion workflow  
✅ X-ray upload and Cobb angle measurement  
✅ AI classification results display  
✅ Real-time notifications (Socket.IO)  
✅ Profile management  
✅ Secure token storage  

### 2.2 Out of Scope
❌ Backend API implementation testing (separate test suite)  
❌ Third-party service testing (STUN/TURN servers)  
❌ App store deployment process  
❌ Server infrastructure testing  

---

## 3. Test Environment

### 3.1 Hardware Requirements
- **iOS:** iPhone 11 or newer (iOS 14.0+)
- **Android:** Android device with API level 21+ (Android 5.0+)
- **Network:** Stable Wi-Fi or 4G/5G connection for video calls

### 3.2 Software Requirements
- Flutter SDK 3.8.1+
- Dart 3.0+
- Xcode 14+ (for iOS testing)
- Android Studio (for Android testing)

### 3.3 Test Data
- Practitioner test accounts (active and pending)
- Patient test accounts
- Sample X-ray images (various formats and sizes)
- Test appointment schedules

---

## 4. Authentication & Registration

### 4.1 Practitioner Registration

#### TC-AUTH-001: Complete Practitioner Registration
**Priority:** High  
**Precondition:** None  
**Test Steps:**
1. Launch the app
2. Navigate to Registration screen
3. Fill in Step 1 - Personal Details:
   - First Name: "John"
   - Last Name: "Doe"
   - Email: "john.doe@test.com"
   - Phone: "+94771234567"
   - Specialty: "Ayurvedic Medicine"
   - Medical License: "AY12345"
   - Password: "Test@123"
   - Confirm Password: "Test@123"
4. Click "Next"
5. Fill in Step 2 - Clinic Information:
   - Clinic Name: "Ayurcare Clinic"
   - Address Line 1: "123 Main Street"
   - Address Line 2: "Suite 4B" (optional)
   - City: "Colombo"
   - Clinic Email: "clinic@ayurcare.com"
   - Clinic Phone: "+94112345678"
6. Click "Submit Registration"

**Expected Result:**
- ✅ Form validation passes for all fields
- ✅ Success message: "Registration successful! Your account is pending activation."
- ✅ User redirected to login screen
- ✅ Account status set to "Pending" in database

**Actual Result:** _____________  
**Status:** ⬜ Pass ⬜ Fail  
**Tested By:** _____________  
**Date:** _____________

---

#### TC-AUTH-002: Registration with Invalid Email
**Priority:** Medium  
**Test Steps:**
1. Navigate to Registration screen
2. Enter invalid email: "invalid-email"
3. Fill other fields with valid data
4. Click "Next"

**Expected Result:**
- ✅ Email field shows error: "Enter a valid email"
- ✅ Form does not proceed to step 2

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-003: Registration with Weak Password
**Priority:** Medium  
**Test Steps:**
1. Navigate to Registration screen
2. Enter password: "weak"
3. Confirm password: "weak"
4. Fill other fields with valid data
5. Click "Next"

**Expected Result:**
- ✅ Password field shows error: "Password must be at least 8 characters long"
- ✅ Or: "Password must contain at least one uppercase letter, one lowercase letter, and one number"

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-004: Registration with Mismatched Passwords
**Priority:** High  
**Test Steps:**
1. Navigate to Registration screen
2. Enter password: "Test@123"
3. Enter confirm password: "Test@456"
4. Fill other fields with valid data
5. Click "Next"

**Expected Result:**
- ✅ Confirm password field shows error: "Passwords do not match"
- ✅ Form does not proceed

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-005: Registration with Existing Email
**Priority:** High  
**Test Steps:**
1. Register with email: "existing@test.com"
2. Complete registration flow
3. Attempt to register again with same email

**Expected Result:**
- ✅ Error message: "Registration failed: Email already registered"
- ✅ HTTP 409 Conflict response

**Status:** ⬜ Pass ⬜ Fail

---

### 4.2 Login

#### TC-AUTH-006: Successful Login
**Priority:** Critical  
**Precondition:** Account is activated  
**Test Steps:**
1. Launch app
2. Enter valid email: "practitioner@test.com"
3. Enter valid password: "Test@123"
4. Click "Login"

**Expected Result:**
- ✅ Loading indicator appears
- ✅ User authenticated successfully
- ✅ Token stored securely (Flutter Secure Storage)
- ✅ Redirected to Home screen
- ✅ Auth status set to "authenticated"

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-007: Login with Invalid Credentials
**Priority:** High  
**Test Steps:**
1. Launch app
2. Enter email: "wrong@test.com"
3. Enter password: "WrongPass@123"
4. Click "Login"

**Expected Result:**
- ✅ Error message displayed: "Login failed: [error details]"
- ✅ User remains on login screen
- ✅ No token stored

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-008: Login with Pending Account
**Priority:** High  
**Test Steps:**
1. Register new practitioner account
2. Attempt to login before admin activation
3. Enter credentials and click "Login"

**Expected Result:**
- ✅ Error message indicating account is pending activation
- ✅ User cannot proceed to home screen

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-009: Login Requiring Password Change
**Priority:** High  
**Test Steps:**
1. Login with account flagged for password change
2. Click "Login"

**Expected Result:**
- ✅ Temp token stored
- ✅ User redirected to "New Password" screen
- ✅ Cannot access app until password is changed

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-010: Password Visibility Toggle
**Priority:** Low  
**Test Steps:**
1. Navigate to Login screen
2. Enter password
3. Click visibility toggle icon

**Expected Result:**
- ✅ Password switches between obscured and visible states
- ✅ Icon changes between eye and eye-off

**Status:** ⬜ Pass ⬜ Fail

---

### 4.3 Password Management

#### TC-AUTH-011: Set New Password Successfully
**Priority:** High  
**Precondition:** User is on New Password screen with temp token  
**Test Steps:**
1. Enter new password: "NewTest@456"
2. Confirm password: "NewTest@456"
3. Click "Set New Password"

**Expected Result:**
- ✅ Password updated successfully
- ✅ Success message displayed
- ✅ User redirected to login screen
- ✅ Can login with new password

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-AUTH-012: Logout
**Priority:** Medium  
**Test Steps:**
1. Login successfully
2. Navigate to Profile/Settings
3. Click "Logout"

**Expected Result:**
- ✅ Token removed from secure storage
- ✅ User session cleared
- ✅ Redirected to login screen
- ✅ Cannot navigate back to authenticated screens

**Status:** ⬜ Pass ⬜ Fail

---

## 5. Appointment Management

### 5.1 Appointment Scheduling (Practitioner)

#### TC-APPT-001: Schedule Physical Appointment
**Priority:** Critical  
**Precondition:** Logged in as practitioner with active patients  
**Test Steps:**
1. Navigate to Schedule tab
2. Click "+" (Add Appointment button)
3. Select patient from dropdown
4. Enter appointment name: "Initial Consultation"
5. Select date: Tomorrow
6. Select time: 10:00 AM
7. Enter duration: 30 minutes
8. Select type: "Physical"
9. Add notes: "First visit - initial assessment"
10. Click "Submit"

**Expected Result:**
- ✅ Appointment created successfully
- ✅ Status set to "PendingPatientConfirmation"
- ✅ Appears in practitioner's calendar
- ✅ Patient receives notification
- ✅ Success message displayed

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-002: Schedule Remote Appointment
**Priority:** Critical  
**Test Steps:**
1. Follow steps from TC-APPT-001
2. Select type: "Remote"

**Expected Result:**
- ✅ Remote appointment created
- ✅ Video call option available when scheduled
- ✅ Patient can join video call

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-003: Schedule Appointment with Missing Fields
**Priority:** Medium  
**Test Steps:**
1. Navigate to Add Appointment sheet
2. Leave patient field empty
3. Click "Submit"

**Expected Result:**
- ✅ Validation error shown
- ✅ Form does not submit
- ✅ Required fields highlighted

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-004: View Appointment Calendar
**Priority:** High  
**Test Steps:**
1. Navigate to Schedule tab
2. View calendar widget
3. Select different dates
4. View appointments for each date

**Expected Result:**
- ✅ Calendar displays current month
- ✅ Days with appointments marked
- ✅ Selecting date shows appointments for that day
- ✅ Appointments sorted by time

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-005: Filter Appointments by Status
**Priority:** Medium  
**Test Steps:**
1. Navigate to appointments list
2. Apply status filter: "Scheduled"
3. View results
4. Change filter to "Completed"

**Expected Result:**
- ✅ Only appointments matching filter shown
- ✅ Filter updates in real-time
- ✅ Count updates correctly

**Status:** ⬜ Pass ⬜ Fail

---

### 5.2 Appointment Response (Patient)

#### TC-APPT-006: Accept Appointment Request
**Priority:** Critical  
**Precondition:** Patient has pending appointment  
**Test Steps:**
1. Login as patient
2. Navigate to Schedule tab
3. Find appointment with "Pending Confirmation" status
4. Click "Accept" button
5. Confirm acceptance

**Expected Result:**
- ✅ Status changes to "Scheduled"
- ✅ Success message displayed
- ✅ Practitioner receives notification
- ✅ Appointment appears in both calendars

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-007: Request Change for Appointment
**Priority:** High  
**Test Steps:**
1. Login as patient
2. Find pending appointment
3. Click "Request Change" button
4. Enter reason: "I have a conflict at this time"
5. Submit request

**Expected Result:**
- ✅ Request sent to practitioner
- ✅ Practitioner receives notification with reason
- ✅ Appointment status reflects change request
- ✅ Patient sees confirmation message

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-008: View Appointment Details
**Priority:** Medium  
**Test Steps:**
1. Click on any appointment card
2. View appointment details screen

**Expected Result:**
- ✅ All appointment information displayed:
  - Appointment name
  - Date and time
  - Duration
  - Type (Physical/Remote)
  - Status
  - Practitioner/Patient name
  - Notes (if any)
- ✅ Appropriate action buttons shown based on role and status

**Status:** ⬜ Pass ⬜ Fail

---

### 5.3 Appointment Completion

#### TC-APPT-009: Complete Physical Appointment
**Priority:** Critical  
**Precondition:** Logged in as practitioner with scheduled physical appointment  
**Test Steps:**
1. Navigate to appointment details
2. Click "Start Session" button
3. Confirm in dialog
4. Click "Complete" (or complete via session notes)

**Expected Result:**
- ✅ Confirmation dialog appears
- ✅ On confirmation, appointment status changes to "Completed"
- ✅ Patient receives email notification
- ✅ Success message displayed
- ✅ Appointment removed from upcoming list

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-010: Complete Remote Appointment After Video Call
**Priority:** Critical  
**Test Steps:**
1. Join remote appointment video call
2. End video call
3. Click "Complete" button on appointment details
4. Confirm completion

**Expected Result:**
- ✅ Appointment marked as completed
- ✅ Session notes can be saved
- ✅ Patient notified
- ✅ Call room closed

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-011: Complete Appointment with Notes
**Priority:** High  
**Test Steps:**
1. Start physical session
2. Add notes via floating indicator
3. Click "Save & Complete"
4. Confirm

**Expected Result:**
- ✅ Notes saved to appointment
- ✅ Appointment completed
- ✅ Notes visible in appointment history
- ✅ API call to `/appointments/:id/notes` succeeds

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-APPT-012: Join Video Call Button Availability
**Priority:** High  
**Test Steps:**
1. View remote appointment details 30 minutes before
2. Wait until 15 minutes before
3. Observe button state changes

**Expected Result:**
- ✅ Before 15 min: Button disabled, text: "Video Call (Not Yet Available)"
- ✅ Within 15 min: Button enabled, text: "Join Call"
- ✅ During active call: "Return to Call"

**Status:** ⬜ Pass ⬜ Fail

---

## 6. Session Management

### 6.1 Session Lifecycle

#### TC-SESS-001: Start Physical Session
**Priority:** Critical  
**Precondition:** Scheduled physical appointment exists  
**Test Steps:**
1. Navigate to appointment details
2. Click "Start Session" button
3. Observe floating notes indicator

**Expected Result:**
- ✅ Session starts immediately
- ✅ Active session stored in provider
- ✅ Blue floating notes indicator appears (bottom-left)
- ✅ Success notification: "Physical session started. Tap the floating icon to add notes."
- ✅ Session data includes: appointmentId, type=Physical, startTime

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-002: Start Remote Session via Video Call
**Priority:** Critical  
**Test Steps:**
1. Navigate to remote appointment
2. Click "Join Call"
3. Video call starts

**Expected Result:**
- ✅ Remote session starts automatically
- ✅ Orange floating notes indicator appears (bottom-left)
- ✅ Green video call indicator visible (bottom-right)
- ✅ Both indicators draggable independently

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-003: Add Notes During Session
**Priority:** High  
**Test Steps:**
1. Start any session
2. Tap floating notes indicator
3. Enter notes in dialog
4. Click "Close" to continue session

**Expected Result:**
- ✅ Notes dialog opens
- ✅ Shows session type and duration
- ✅ Notes update in real-time as typed
- ✅ Session continues after closing dialog
- ✅ Notes preserved in state

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-004: Session Notes Indicator - Visual States
**Priority:** Medium  
**Test Steps:**
1. Start session (no notes)
2. Observe indicator icon
3. Add notes
4. Observe icon change

**Expected Result:**
- ✅ Empty notes: Outline pencil icon
- ✅ With notes: Filled pencil icon
- ✅ Pulsing animation visible
- ✅ Physical session: Blue gradient background
- ✅ Remote session: Orange gradient background

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-005: Session Duration Display
**Priority:** Low  
**Test Steps:**
1. Start session
2. Wait 5 minutes
3. Open notes dialog
4. Check duration display

**Expected Result:**
- ✅ Duration shown in "Xh Ym" format
- ✅ Updates in real-time
- ✅ Accurate time calculation

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-006: End Session Without Saving Notes
**Priority:** High  
**Test Steps:**
1. Start session with notes
2. Click "End Session"
3. Click "End Without Saving"

**Expected Result:**
- ✅ Confirmation dialog shows options
- ✅ Notes discarded
- ✅ Session ends
- ✅ Floating indicator disappears
- ✅ Appointment NOT marked as completed

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-007: End Session and Save Notes
**Priority:** Critical  
**Test Steps:**
1. Start session
2. Add notes: "Patient shows improvement in posture."
3. Click "End Session"
4. Click "Save & Complete"

**Expected Result:**
- ✅ Loading indicator shown
- ✅ API call to PATCH `/appointments/:id/notes` with notes
- ✅ API call to PATCH `/appointments/:id/complete`
- ✅ Appointment marked as completed
- ✅ Session cleared from state
- ✅ Floating indicator disappears
- ✅ Success message shown

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-008: Single Active Session Enforcement
**Priority:** High  
**Test Steps:**
1. Start session for Appointment A
2. Attempt to start session for Appointment B

**Expected Result:**
- ✅ Error/warning shown
- ✅ Cannot start second session while first is active
- ✅ Must complete or end first session

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-009: Session Persistence Across Navigation
**Priority:** High  
**Test Steps:**
1. Start session
2. Navigate to different screens (Patient Details, Schedule, etc.)
3. Return to Appointments
4. Verify session still active

**Expected Result:**
- ✅ Floating notes indicator remains visible on all screens
- ✅ Session state preserved
- ✅ Notes persist across navigation

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SESS-010: Draggable Notes Indicator
**Priority:** Medium  
**Test Steps:**
1. Start session
2. Drag floating notes indicator to different positions
3. Verify it stays within screen bounds

**Expected Result:**
- ✅ Indicator can be dragged anywhere
- ✅ Smooth dragging animation
- ✅ Stays within screen boundaries
- ✅ Position saved during session

**Status:** ⬜ Pass ⬜ Fail

---

## 7. Video Call (WebRTC)

### 7.1 Call Setup

#### TC-VIDEO-001: Join Video Call Successfully
**Priority:** Critical  
**Precondition:** Remote appointment scheduled and within join window  
**Test Steps:**
1. Navigate to appointment details
2. Click "Join Call"
3. Grant camera and microphone permissions
4. Wait for call to connect

**Expected Result:**
- ✅ Permission request appears
- ✅ Local video preview shown (bottom corner)
- ✅ WebRTC peer connection established
- ✅ Signaling via Socket.IO successful
- ✅ Remote video appears when other party joins
- ✅ Remote session started automatically
- ✅ Both video and notes indicators visible

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-002: Create Video Call Room
**Priority:** High  
**Test Steps:**
1. First user joins call
2. Verify room creation

**Expected Result:**
- ✅ API call to create/get video call room succeeds
- ✅ Room ID associated with appointment
- ✅ Signaling server connection established

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-003: Join Existing Video Call Room
**Priority:** Critical  
**Test Steps:**
1. Practitioner joins call first
2. Patient joins same appointment call

**Expected Result:**
- ✅ Patient joins existing room
- ✅ Both users see each other's video
- ✅ SDP offer/answer exchange successful
- ✅ ICE candidates exchanged

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-004: Deny Camera/Microphone Permissions
**Priority:** High  
**Test Steps:**
1. Click "Join Call"
2. Deny permissions when prompted

**Expected Result:**
- ✅ Error message displayed
- ✅ Cannot join call without permissions
- ✅ User guided to enable permissions

**Status:** ⬜ Pass ⬜ Fail

---

### 7.2 Call Controls

#### TC-VIDEO-005: Mute/Unmute Audio
**Priority:** Critical  
**Test Steps:**
1. Join video call
2. Click microphone button to mute
3. Click again to unmute

**Expected Result:**
- ✅ Audio track disabled on mute
- ✅ Icon changes to muted state
- ✅ Remote participant cannot hear audio
- ✅ Audio enabled on unmute

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-006: Enable/Disable Video
**Priority:** Critical  
**Test Steps:**
1. Join video call
2. Click camera button to disable
3. Click again to enable

**Expected Result:**
- ✅ Video track disabled
- ✅ Local preview shows camera off
- ✅ Remote participant sees black screen or placeholder
- ✅ Video enabled on toggle

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-007: Switch Camera (Front/Back)
**Priority:** Medium  
**Test Steps:**
1. Join call on mobile device
2. Click switch camera button
3. Observe video source change

**Expected Result:**
- ✅ Camera switches between front and back
- ✅ Video continues streaming
- ✅ No call interruption

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-008: End Video Call
**Priority:** Critical  
**Test Steps:**
1. Join video call
2. Click "End Call" button
3. Confirm end call

**Expected Result:**
- ✅ Confirmation dialog appears
- ✅ Call ended on confirmation
- ✅ Video renderers disposed
- ✅ Peer connection closed
- ✅ Signaling connection closed
- ✅ Redirected to appointment details or notes save dialog
- ✅ Remote session prompt to save notes

**Status:** ⬜ Pass ⬜ Fail

---

### 7.3 Video Call UI

#### TC-VIDEO-009: Local Video Preview Draggable
**Priority:** Medium  
**Test Steps:**
1. Join video call
2. Drag local video preview to different corners

**Expected Result:**
- ✅ Preview can be moved
- ✅ Stays within screen bounds
- ✅ Does not overlap critical UI elements

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-010: Remote Video Fullscreen
**Priority:** Medium  
**Test Steps:**
1. Join call with remote participant
2. Observe remote video rendering

**Expected Result:**
- ✅ Remote video fills screen
- ✅ Aspect ratio maintained
- ✅ No distortion

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-011: Call Controls Auto-Hide
**Priority:** Low  
**Test Steps:**
1. Join video call
2. Wait 5 seconds without interaction
3. Tap screen

**Expected Result:**
- ✅ Controls fade out after inactivity
- ✅ Tap screen to show controls
- ✅ Controls fade out again after timeout

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-012: Return to Active Call
**Priority:** High  
**Test Steps:**
1. Join video call
2. Navigate away (press home or switch apps)
3. Return to app
4. Click "Return to Call" button

**Expected Result:**
- ✅ Call remains active in background
- ✅ Button text changes to "Return to Call"
- ✅ Clicking button returns to call screen
- ✅ Video streams continue

**Status:** ⬜ Pass ⬜ Fail

---

### 7.4 Video Call Edge Cases

#### TC-VIDEO-013: Poor Network Connection
**Priority:** High  
**Test Steps:**
1. Join call with stable connection
2. Simulate poor network (throttle network speed)
3. Observe call quality

**Expected Result:**
- ✅ Call adapts to bandwidth
- ✅ Video quality degrades gracefully
- ✅ Audio prioritized over video
- ✅ No complete call drop if possible

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-014: Remote Participant Disconnects
**Priority:** High  
**Test Steps:**
1. Both users in call
2. Remote user ends call or loses connection

**Expected Result:**
- ✅ Notification shown: "Remote participant disconnected"
- ✅ Call can be ended or wait for reconnection
- ✅ UI handles gracefully

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-VIDEO-015: Call Timeout
**Priority:** Medium  
**Test Steps:**
1. Join call
2. Wait extended period (e.g., 2 hours)

**Expected Result:**
- ✅ Call remains stable
- ✅ Or timeout notification shown if configured
- ✅ Resources managed efficiently

**Status:** ⬜ Pass ⬜ Fail

---

## 8. Patient Management

### 8.1 Patient Invitation

#### TC-PATIENT-001: Invite New Patient
**Priority:** High  
**Precondition:** Logged in as practitioner  
**Test Steps:**
1. Navigate to Patients section
2. Click "Invite Patient"
3. Enter patient email: "patient@test.com"
4. Click "Send Invitation"

**Expected Result:**
- ✅ Invitation email sent to patient
- ✅ Patient receives registration link
- ✅ Success message displayed
- ✅ Patient appears in pending invitations list

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-PATIENT-002: View Patient List
**Priority:** Medium  
**Test Steps:**
1. Navigate to Patients section
2. View list of patients

**Expected Result:**
- ✅ All patients displayed
- ✅ Patient names, emails shown
- ✅ Search/filter functionality available
- ✅ Pagination if many patients

**Status:** ⬜ Pass ⬜ Fail

---

### 8.2 Patient Details

#### TC-PATIENT-003: View Patient Details
**Priority:** High  
**Test Steps:**
1. Click on a patient from list
2. View patient details screen

**Expected Result:**
- ✅ Personal information displayed:
  - Name
  - Email
  - Phone
  - Date of Birth
  - Gender
- ✅ Appointment history shown
- ✅ X-ray images listed
- ✅ AI classification results displayed
- ✅ Cobb angle measurements shown

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-PATIENT-004: View Patient Appointment History
**Priority:** Medium  
**Test Steps:**
1. Navigate to patient details
2. View "Appointments" section
3. Filter by status (Completed, Scheduled, etc.)

**Expected Result:**
- ✅ All appointments listed chronologically
- ✅ Status indicators shown
- ✅ Can click to view appointment details
- ✅ Notes visible for completed appointments

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-PATIENT-005: View Patient X-Ray History
**Priority:** High  
**Test Steps:**
1. Navigate to patient details
2. View "X-Rays" section
3. Click on X-ray to view details

**Expected Result:**
- ✅ All X-rays displayed with thumbnails
- ✅ Upload date shown
- ✅ AI classification results displayed
- ✅ Cobb angle measurements shown
- ✅ Can view full-size image
- ✅ Can perform new measurements

**Status:** ⬜ Pass ⬜ Fail

---

## 9. X-Ray Management & Cobb Angle Measurement

### 9.1 X-Ray Upload

#### TC-XRAY-001: Upload X-Ray Image
**Priority:** Critical  
**Precondition:** Logged in as practitioner, patient selected  
**Test Steps:**
1. Navigate to patient details
2. Click "Upload X-Ray"
3. Select image from gallery/camera
4. Add notes (optional)
5. Click "Upload"

**Expected Result:**
- ✅ File picker opens
- ✅ Image preview shown
- ✅ Upload progress indicator
- ✅ Image uploaded successfully
- ✅ AI classification triggered automatically
- ✅ X-ray appears in patient's X-ray list

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-002: Upload Invalid File Type
**Priority:** Medium  
**Test Steps:**
1. Attempt to upload non-image file (e.g., PDF)

**Expected Result:**
- ✅ Error message: "Invalid file type"
- ✅ Upload rejected

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-003: Upload Large File
**Priority:** Medium  
**Test Steps:**
1. Upload X-ray image larger than allowed size (e.g., >10MB)

**Expected Result:**
- ✅ Error message or compression applied
- ✅ User notified about size limit

**Status:** ⬜ Pass ⬜ Fail

---

### 9.2 AI Classification

#### TC-XRAY-004: View AI Classification Results
**Priority:** High  
**Precondition:** X-ray uploaded and processed  
**Test Steps:**
1. Navigate to patient X-rays
2. View X-ray with AI classification
3. Check classification result

**Expected Result:**
- ✅ Classification type displayed:
  - No Scoliosis Detected
  - Scoliosis C Curve
  - Scoliosis S Curve
  - Not A Spinal X-ray
  - No X-ray Detected
  - Analysis Failed
- ✅ Classification confidence score shown (if available)
- ✅ Visual indicator for classification type

**Status:** ⬜ Pass ⬜ Fail

---

### 9.3 Cobb Angle Measurement

#### TC-XRAY-005: Perform Cobb Angle Measurement
**Priority:** Critical  
**Test Steps:**
1. Open X-ray image
2. Click "Measure Cobb Angle"
3. Draw first line along superior vertebra
4. Draw second line along inferior vertebra
5. Observe angle calculation
6. Save measurement

**Expected Result:**
- ✅ Measurement tool opens
- ✅ Can draw lines on X-ray image
- ✅ Angle calculated automatically
- ✅ Angle value displayed in degrees
- ✅ Measurement saved to database
- ✅ Visible in patient history

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-006: Multiple Cobb Angle Measurements
**Priority:** High  
**Test Steps:**
1. Open X-ray with measurement tool
2. Create first measurement
3. Create second measurement
4. Save both

**Expected Result:**
- ✅ Can create multiple measurements on same X-ray
- ✅ Each measurement saved independently
- ✅ All measurements visible in list
- ✅ Can delete individual measurements

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-007: Edit Existing Measurement
**Priority:** Medium  
**Test Steps:**
1. Open X-ray with saved measurements
2. Click "Edit" on a measurement
3. Adjust lines
4. Save changes

**Expected Result:**
- ✅ Can re-enter measurement mode
- ✅ Previous lines loaded
- ✅ Can adjust line positions
- ✅ Updated angle calculated
- ✅ Changes saved

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-008: Delete Measurement
**Priority:** Low  
**Test Steps:**
1. View saved measurement
2. Click "Delete"
3. Confirm deletion

**Expected Result:**
- ✅ Confirmation dialog shown
- ✅ Measurement deleted from database
- ✅ Removed from list

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-009: Zoom and Pan on X-Ray
**Priority:** Medium  
**Test Steps:**
1. Open X-ray measurement tool
2. Pinch to zoom in/out
3. Pan across image
4. Draw measurement lines

**Expected Result:**
- ✅ Image zooms smoothly
- ✅ Can pan when zoomed
- ✅ Measurements accurate regardless of zoom level
- ✅ Lines drawn precisely

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-XRAY-010: Read-Only Measurement View
**Priority:** Low  
**Test Steps:**
1. Open X-ray in read-only mode
2. View existing measurements

**Expected Result:**
- ✅ Measurements displayed
- ✅ Cannot edit or delete
- ✅ Clear indication of read-only mode

**Status:** ⬜ Pass ⬜ Fail

---

## 10. Real-Time Notifications

### 10.1 Socket.IO Connection

#### TC-NOTIF-001: Socket Connection on Login
**Priority:** High  
**Test Steps:**
1. Login successfully
2. Check Socket.IO connection status

**Expected Result:**
- ✅ Socket connection established
- ✅ User joined appropriate rooms
- ✅ Ready to receive events

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-NOTIF-002: Receive Appointment Completed Notification
**Priority:** High  
**Test Steps:**
1. Practitioner completes appointment
2. Patient's app should receive notification

**Expected Result:**
- ✅ Event received via Socket.IO
- ✅ Notification displayed in app
- ✅ Appointment list refreshed
- ✅ Badge count updated (if applicable)

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-NOTIF-003: Receive X-Ray Upload Notification
**Priority:** Medium  
**Test Steps:**
1. Practitioner uploads X-ray for patient
2. Patient receives notification

**Expected Result:**
- ✅ Real-time notification received
- ✅ Patient can navigate to X-ray details

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-NOTIF-004: Receive AI Classification Notification
**Priority:** Medium  
**Test Steps:**
1. X-ray AI classification completes
2. User receives notification

**Expected Result:**
- ✅ Notification shows classification result
- ✅ Can click to view details

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-NOTIF-005: Socket Reconnection on Network Loss
**Priority:** High  
**Test Steps:**
1. Establish socket connection
2. Disable network
3. Re-enable network
4. Check connection status

**Expected Result:**
- ✅ Socket reconnects automatically
- ✅ User re-joins rooms
- ✅ No manual intervention required

**Status:** ⬜ Pass ⬜ Fail

---

## 11. UI/UX Components

### 11.1 Navigation

#### TC-UI-001: Bottom Navigation Bar
**Priority:** Medium  
**Test Steps:**
1. Login and view home screen
2. Click each tab in bottom navigation
3. Verify navigation

**Expected Result:**
- ✅ Dashboard tab shows overview
- ✅ Schedule tab shows calendar/appointments
- ✅ Patients tab shows patient list (practitioner)
- ✅ Profile tab shows user profile
- ✅ Smooth transitions between tabs

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-UI-002: AppBar Back Navigation
**Priority:** Medium  
**Test Steps:**
1. Navigate to nested screen
2. Click back button in AppBar
3. Verify navigation

**Expected Result:**
- ✅ Returns to previous screen
- ✅ State preserved
- ✅ Animation smooth

**Status:** ⬜ Pass ⬜ Fail

---

### 11.2 Loading States

#### TC-UI-003: Skeleton Loading Screens
**Priority:** Low  
**Test Steps:**
1. Navigate to screen with API data
2. Observe loading state
3. Wait for data load

**Expected Result:**
- ✅ Skeleton shimmer shown while loading
- ✅ Matches expected layout
- ✅ Transitions smoothly to actual content

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-UI-004: Loading Indicators on Buttons
**Priority:** Low  
**Test Steps:**
1. Click button with async action (e.g., Submit)
2. Observe button state during loading

**Expected Result:**
- ✅ Button shows loading spinner
- ✅ Button disabled during loading
- ✅ Returns to normal state after completion

**Status:** ⬜ Pass ⬜ Fail

---

### 11.3 Error Handling

#### TC-UI-005: Display API Error Messages
**Priority:** High  
**Test Steps:**
1. Trigger API error (disconnect network)
2. Perform action requiring API
3. Observe error display

**Expected Result:**
- ✅ Error message shown via SnackBar
- ✅ User-friendly error message
- ✅ Can dismiss error
- ✅ Can retry action

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-UI-006: Form Validation Errors
**Priority:** Medium  
**Test Steps:**
1. Submit form with invalid data
2. Observe validation errors

**Expected Result:**
- ✅ Errors shown inline below fields
- ✅ Error text is clear and helpful
- ✅ Form does not submit
- ✅ First error field focused

**Status:** ⬜ Pass ⬜ Fail

---

### 11.4 Responsive Design

#### TC-UI-007: Portrait and Landscape Orientations
**Priority:** Medium  
**Test Steps:**
1. Rotate device to landscape
2. Test all major screens
3. Rotate back to portrait

**Expected Result:**
- ✅ UI adapts to orientation
- ✅ No content cut off
- ✅ Layouts reflow appropriately
- ✅ Video call UI adjusts for landscape

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-UI-008: Different Screen Sizes
**Priority:** Medium  
**Test Steps:**
1. Test on small screen device (iPhone SE)
2. Test on large screen device (iPad)
3. Verify layouts

**Expected Result:**
- ✅ UI scales appropriately
- ✅ Text readable on all sizes
- ✅ Buttons accessible
- ✅ Images scaled correctly

**Status:** ⬜ Pass ⬜ Fail

---

## 12. Security & Data Privacy

### 12.1 Authentication Security

#### TC-SEC-001: Token Storage Security
**Priority:** Critical  
**Test Steps:**
1. Login successfully
2. Check token storage method
3. Attempt to access token from device

**Expected Result:**
- ✅ Token stored in Flutter Secure Storage
- ✅ Encrypted in iOS Keychain
- ✅ Encrypted in Android Keystore
- ✅ Not accessible to other apps

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SEC-002: Token Expiration Handling
**Priority:** High  
**Test Steps:**
1. Login and use app
2. Wait for token expiration
3. Attempt to make API call

**Expected Result:**
- ✅ 401 Unauthorized response handled
- ✅ User logged out automatically
- ✅ Redirected to login screen
- ✅ Token cleared from storage

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SEC-003: Secure API Communication
**Priority:** Critical  
**Test Steps:**
1. Monitor network traffic
2. Verify API calls use HTTPS

**Expected Result:**
- ✅ All API calls use HTTPS
- ✅ No sensitive data in URL parameters
- ✅ Authorization header present

**Status:** ⬜ Pass ⬜ Fail

---

### 12.2 Data Privacy

#### TC-SEC-004: Sensitive Data Not Logged
**Priority:** High  
**Test Steps:**
1. Perform various operations
2. Check app logs and console output

**Expected Result:**
- ✅ Passwords not logged
- ✅ Tokens not logged
- ✅ Personal health information not logged
- ✅ API responses sanitized in logs

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SEC-005: Session Timeout
**Priority:** Medium  
**Test Steps:**
1. Login and use app
2. Leave app idle for extended period
3. Return to app

**Expected Result:**
- ✅ Session timeout after configured duration
- ✅ User must re-authenticate
- ✅ Or session extended with activity

**Status:** ⬜ Pass ⬜ Fail

---

### 12.3 Authorization

#### TC-SEC-006: Role-Based Access Control
**Priority:** Critical  
**Test Steps:**
1. Login as patient
2. Attempt to access practitioner-only features

**Expected Result:**
- ✅ Patient cannot schedule appointments for others
- ✅ Patient cannot view other patients' data
- ✅ Patient cannot upload X-rays for others
- ✅ Backend enforces authorization

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-SEC-007: Patient Data Access Control
**Priority:** Critical  
**Test Steps:**
1. Login as practitioner
2. Attempt to view patients not assigned to practitioner

**Expected Result:**
- ✅ Only assigned patients visible
- ✅ Cannot access other practitioners' patients
- ✅ Backend enforces data access rules

**Status:** ⬜ Pass ⬜ Fail

---

## 13. Integration Testing

### 13.1 API Integration

#### TC-INT-001: Appointment Workflow End-to-End
**Priority:** Critical  
**Test Steps:**
1. Practitioner schedules appointment
2. Patient receives notification
3. Patient accepts appointment
4. Both join video call (if remote)
5. Practitioner completes appointment with notes
6. Patient views completed appointment

**Expected Result:**
- ✅ All API calls successful
- ✅ Data synchronized across users
- ✅ Notifications delivered in real-time
- ✅ Final state reflects completion

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-INT-002: X-Ray Upload and Measurement Workflow
**Priority:** High  
**Test Steps:**
1. Practitioner uploads X-ray
2. AI classification triggered
3. Practitioner performs Cobb angle measurement
4. Patient views X-ray and results

**Expected Result:**
- ✅ Upload successful
- ✅ AI classification completes
- ✅ Measurement saved
- ✅ All data visible to patient

**Status:** ⬜ Pass ⬜ Fail

---

### 13.2 WebRTC Signaling

#### TC-INT-003: WebRTC Signaling Flow
**Priority:** Critical  
**Test Steps:**
1. User A joins call
2. Socket.IO room joined
3. User B joins same call
4. SDP offer/answer exchanged
5. ICE candidates exchanged
6. Connection established

**Expected Result:**
- ✅ All signaling events transmitted
- ✅ No message loss
- ✅ Connection established successfully
- ✅ Audio and video streams active

**Status:** ⬜ Pass ⬜ Fail

---

## 14. Performance Testing

### 14.1 App Launch and Load Times

#### TC-PERF-001: Cold Start Time
**Priority:** Medium  
**Test Steps:**
1. Force close app
2. Clear app from memory
3. Launch app
4. Measure time to home screen

**Expected Result:**
- ✅ App launches within 3 seconds
- ✅ Splash screen shown during load
- ✅ Smooth transition to home

**Status:** ⬜ Pass ⬜ Fail  
**Time:** _______ seconds

---

#### TC-PERF-002: Appointment List Load Time
**Priority:** Medium  
**Test Steps:**
1. Navigate to Schedule tab
2. Measure time to display appointments

**Expected Result:**
- ✅ Appointments visible within 1 second
- ✅ Skeleton shown during load
- ✅ Smooth rendering

**Status:** ⬜ Pass ⬜ Fail  
**Time:** _______ seconds

---

### 14.2 Video Call Performance

#### TC-PERF-003: Video Call Connection Time
**Priority:** High  
**Test Steps:**
1. Click "Join Call"
2. Measure time until video streams active

**Expected Result:**
- ✅ Local preview within 1 second
- ✅ Remote video within 5 seconds
- ✅ Low latency (<500ms)

**Status:** ⬜ Pass ⬜ Fail  
**Time:** _______ seconds

---

#### TC-PERF-004: Video Call Quality
**Priority:** High  
**Test Steps:**
1. Join video call
2. Assess video quality over 5 minutes
3. Check frame rate and resolution

**Expected Result:**
- ✅ Stable frame rate (24+ fps)
- ✅ Clear video quality
- ✅ No significant lag or freezing
- ✅ Audio-video sync maintained

**Status:** ⬜ Pass ⬜ Fail

---

### 14.3 Memory and Battery

#### TC-PERF-005: Memory Usage
**Priority:** Medium  
**Test Steps:**
1. Use app for 30 minutes
2. Monitor memory usage
3. Check for memory leaks

**Expected Result:**
- ✅ Memory usage remains stable
- ✅ No significant memory leaks
- ✅ App does not crash due to memory

**Status:** ⬜ Pass ⬜ Fail  
**Memory Used:** _______ MB

---

#### TC-PERF-006: Battery Consumption During Video Call
**Priority:** Medium  
**Test Steps:**
1. Fully charge device
2. Join 30-minute video call
3. Measure battery drain

**Expected Result:**
- ✅ Battery drain acceptable (<20% for 30 min)
- ✅ Device does not overheat
- ✅ Call remains stable throughout

**Status:** ⬜ Pass ⬜ Fail  
**Battery Used:** _______ %

---

## 15. Cross-Platform Testing

### 15.1 iOS Testing

#### TC-PLAT-001: iOS UI Consistency
**Priority:** Medium  
**Test Steps:**
1. Test all screens on iOS device
2. Verify Cupertino icons display correctly
3. Check navigation gestures

**Expected Result:**
- ✅ UI renders correctly
- ✅ Icons display properly
- ✅ iOS-specific gestures work (swipe back, etc.)
- ✅ No layout issues

**Status:** ⬜ Pass ⬜ Fail  
**Device:** _____________  
**iOS Version:** _____________

---

#### TC-PLAT-002: iOS Permissions
**Priority:** High  
**Test Steps:**
1. First launch on iOS
2. Trigger camera/microphone permission requests
3. Test with permissions granted/denied

**Expected Result:**
- ✅ Permission dialogs appear correctly
- ✅ Info.plist descriptions shown
- ✅ App handles permissions gracefully

**Status:** ⬜ Pass ⬜ Fail

---

### 15.2 Android Testing

#### TC-PLAT-003: Android UI Consistency
**Priority:** Medium  
**Test Steps:**
1. Test all screens on Android device
2. Verify Material Design compliance
3. Check back button behavior

**Expected Result:**
- ✅ UI renders correctly
- ✅ Material icons display properly
- ✅ Hardware back button works
- ✅ No layout issues

**Status:** ⬜ Pass ⬜ Fail  
**Device:** _____________  
**Android Version:** _____________

---

#### TC-PLAT-004: Android Permissions
**Priority:** High  
**Test Steps:**
1. First launch on Android
2. Trigger camera/microphone permission requests
3. Test with permissions granted/denied

**Expected Result:**
- ✅ Permission dialogs appear correctly
- ✅ AndroidManifest permissions declared
- ✅ Runtime permissions requested
- ✅ App handles permissions gracefully

**Status:** ⬜ Pass ⬜ Fail

---

#### TC-PLAT-005: Android Background Behavior
**Priority:** Medium  
**Test Steps:**
1. Join video call
2. Press home button (app goes to background)
3. Return to app

**Expected Result:**
- ✅ Call continues in background (if configured)
- ✅ Or call pauses appropriately
- ✅ Smooth resume on return
- ✅ State preserved

**Status:** ⬜ Pass ⬜ Fail

---

## Test Summary Report Template

### Test Execution Summary

**Date:** _____________  
**Tester:** _____________  
**Build Version:** _____________  
**Platform:** ⬜ iOS ⬜ Android  

| Module | Total Tests | Passed | Failed | Blocked | Pass Rate |
|--------|-------------|---------|---------|---------|-----------|
| Authentication | 12 | | | | |
| Appointments | 12 | | | | |
| Sessions | 10 | | | | |
| Video Calls | 15 | | | | |
| Patient Management | 5 | | | | |
| X-Ray & Measurement | 10 | | | | |
| Notifications | 5 | | | | |
| UI/UX | 8 | | | | |
| Security | 7 | | | | |
| Integration | 3 | | | | |
| Performance | 6 | | | | |
| Cross-Platform | 5 | | | | |
| **TOTAL** | **98** | | | | |

### Critical Issues Found

| Issue ID | Module | Description | Severity | Status |
|----------|--------|-------------|----------|--------|
| | | | | |

### Recommendations

- 
- 
- 

### Sign-Off

**QA Lead:** _______________  
**Date:** _______________  

**Project Manager:** _______________  
**Date:** _______________  

---

## Appendix A: Test Data

### Test Accounts

**Practitioner:**
- Email: practitioner@test.com
- Password: Test@123
- Status: Active

**Patient:**
- Email: patient@test.com
- Password: Test@123
- Status: Active

### Sample Appointment Data

```json
{
  "name": "Follow-up Consultation",
  "patientId": "patient-123",
  "appointmentDateTime": "2025-11-15T10:00:00Z",
  "durationInMinutes": 30,
  "type": "Remote",
  "notes": "Patient showing improvement"
}
```

### Sample X-Ray Test Files

- `test_xray_normal.jpg` - Normal spine X-ray
- `test_xray_c_curve.jpg` - Scoliosis C-curve
- `test_xray_s_curve.jpg` - Scoliosis S-curve
- `test_xray_invalid.pdf` - Invalid file type

---

## Appendix B: API Endpoints Reference

**Base URL:** `https://api.spinealign.com/api`

### Authentication
- POST `/auth/register` - Practitioner registration
- POST `/auth/login` - User login
- POST `/auth/verify-otp` - OTP verification
- POST `/auth/set-new-password` - Set new password

### Appointments
- GET `/appointments` - List appointments
- GET `/appointments/:id` - Appointment details
- POST `/appointments/schedule` - Schedule appointment
- PATCH `/appointments/:id/respond` - Respond to appointment
- PATCH `/appointments/:id/complete` - Complete appointment
- PATCH `/appointments/:id/notes` - Update notes
- GET `/appointments/upcoming` - Upcoming appointments
- GET `/appointments/dates` - Appointment dates for calendar

### Patients
- GET `/patients` - List patients
- GET `/patients/:id` - Patient details
- POST `/patients/invite` - Invite patient

### X-Ray
- POST `/xray/upload` - Upload X-ray
- POST `/xray/measurements` - Save measurements
- GET `/xray/patient/:patientId` - Get patient X-rays

### Video Calls
- POST `/video-calls/appointment/:appointmentId` - Create/get room
- GET `/video-calls/room/:roomId` - Room details

### Profile
- GET `/profile` - Get user profile

---

## Appendix C: Glossary

**AI Classification:** Automated analysis of X-ray images to detect scoliosis type  
**Cobb Angle:** Measurement of spinal curvature in degrees  
**ICE Candidate:** Interactive Connectivity Establishment - network path for WebRTC  
**Riverpod:** State management library for Flutter  
**SDP:** Session Description Protocol - describes multimedia session for WebRTC  
**Socket.IO:** Real-time bidirectional event-based communication  
**STUN/TURN:** Servers for NAT traversal in WebRTC  
**WebRTC:** Web Real-Time Communication - peer-to-peer media streaming  

---

## Document Control

**Version History:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-14 | Test Team | Initial test case document |

**Review and Approval:**

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QA Lead | | | |
| Dev Lead | | | |
| Product Owner | | | |

---

**End of Document**
