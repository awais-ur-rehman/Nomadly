# Nomadly Flutter Client — Phased Fix Plan

See `APP_FLOW.md` for the full user flow this plan implements.

---

## Phase 1 — Fix Breaking Backend Integration ✅ DONE

- 1.1 Registration: invite code field + validation
- 1.2 Discovery swipe action mapping (left→pass, right→like, star→super_like)
- 1.3 AppConfig: safety, invite, verification endpoints
- 1.4 Recommendation response: `RecommendedUser` model with `CompatibilityScore`
- 1.5 Mode query param on recommendations

---

## Phase 2 — Data Models & Profile Setup

### 2.1 Verification model
Create `lib/shared/models/verification.dart` — Freezed model matching backend shape (email, phone, photo, id_document, community sub-objects + level + badge).

### 2.2 Update User model
Add to `lib/shared/models/user.dart`:
- `Verification? verification`
- `String? invitedBy`
- `@Default(0) int inviteCount`

### 2.3 Profile Setup overhaul
Current profile setup is missing travel route and distance preference. Redesign as linear multi-step flow:

| Step | Fields | Current status |
|------|--------|---------------|
| 1. Photo | At least 1 photo upload | Exists but optional — make required |
| 2. Basics | Age, gender, bio | Exists |
| 3. Hobbies | Multi-select chips | Exists |
| 4. Rig | Type, crew, pet-friendly | Exists |
| 5. Travel Route | Origin, destination, dates, duration | **MISSING — create** |
| 6. Distance | Max distance slider (25–500 km) | **MISSING — create** |
| 7. Intent | Friends / Dating / Both | Exists |

**Files:** `profile_setup_screen.dart` — add steps 5 and 6. Wire travel_route + preferences to backend via profile completion API.

### 2.4 Edit Profile: add travel route + distance
`edit_profile_screen.dart` — add sections to edit origin, destination, dates, duration, max distance. Currently missing.

### 2.5 Match model field alignment
Verify `Match.fromJson` handles `_id`/`id`, `createdAt`/`created_at`, backend shape.

---

## Phase 3 — Navigation & Layout Restructure

### 3.1 Redesign bottom nav tabs
Current: Feed | Meet | Map | Matches | Profile
New: **Feed | Discover | + (Create) | Chat | Me**

| Change | Detail |
|--------|--------|
| Rename "Meet" → "Discover" | Label + icon |
| Remove Map tab | Map becomes a utility (location picker), not a main tab |
| Center tab = "+" FAB | Opens bottom sheet: New Post / New Trip / New Activity |
| Rename "Matches" → "Chat" | Merge matches row + conversations into one screen |
| Rename "Profile" → "Me" | |

**File:** `home_screen.dart` — restructure `IndexedStack` and bottom nav items.

### 3.2 Create action sheet (the "+" tab)
When center tab tapped, show `showModalBottomSheet` with 3 options:
- New Post → `/create-post`
- New Trip → `/create-trip` (new screen)
- New Activity → `/create-activity`

### 3.3 Create Trip screen (NEW)
`lib/features/social/presentation/screens/create_trip_screen.dart`
- Origin location picker
- Destination location picker
- Start date + duration
- Optional description
- Submit → updates user's `travel_route` on backend + creates a trip post in feed

### 3.4 Feed AppBar cleanup
Move Marketplace and Notifications to Feed AppBar actions (shopping bag + bell icons). Remove marketplace from random navigation points.

### 3.5 Update router
Update `router.dart` with new routes: `/create-trip`, remove map as a bottom tab destination.

---

## Phase 4 — Chat Tab Redesign (Tinder Messages style)

### 4.1 Merge matches + conversations
Current: separate MatchesScreen and InboxScreen.
New: single ChatScreen with:
- Top: horizontal scrollable row of new/unread match avatars
- Below: conversation list sorted by last message

**Files:**
- Modify existing `matches_screen.dart` or create new unified screen
- Remove standalone matches tab — fold into chat

### 4.2 Chat screen: add block/report menu
`chat_screen.dart` — AppBar ••• button → bottom sheet with "Block User" / "Report User".

### 4.3 Hide blocked users
Filter blocked users from match row + conversation list client-side.

---

## Phase 5 — Profile Screen Redesign (Instagram-style)

### 5.1 Clean profile layout
Redesign `profile_screen.dart`:
- Profile photo + name + verification badge (level-based)
- Stats row: Posts | Vouches | Trips + Followers | Following
- Bio line
- Rig summary one-liner: "🚐 Sprinter Van · Solo + Pet"
- Trip summary one-liner: "📍 Denver → Moab · May 15-22"
- Hobby chips
- Post grid at bottom (Instagram 3-column grid)

### 5.2 Verification badge upgrade
Replace boolean "Verified Nomad" with level-based badge:
- Level 0: none
- Level 1: gray "Basic"
- Level 2: blue "Trusted"
- Level 3: blue check "Verified"
- Level 4: gold "Super Verified"
- Level 5: gold star "Nomad Elite"

### 5.3 Other user profile (read-only)
`user_profile_screen.dart` — same layout but:
- [Follow/Unfollow] button
- [Message] button (visible if matched)
- ••• menu → Block / Report

### 5.4 Settings screen overhaul
Restructure `settings_screen.dart` into sections:
- **Account:** Edit Profile, Verification, Invite Codes, Private toggle
- **Matching:** Mode, Distance, Age Range, Gender Interest
- **Safety:** Blocked Users
- **About:** Terms, Privacy, Version
- Logout

---

## Phase 6 — Safety Module (Block & Report)

### 6.1 Safety repository + provider
Create:
- `lib/features/safety/data/repositories/safety_repository.dart`
- `lib/features/safety/providers/safety_provider.dart`

API calls: block, unblock, get blocked, report.

### 6.2 Block/report UI integration
- Chat screen ••• menu (Phase 4.2)
- User profile screen ••• menu (Phase 5.3)
- Discover card long-press or ••• menu

### 6.3 Blocked users list screen
`lib/features/safety/presentation/screens/blocked_users_screen.dart`
- List blocked users with unblock button
- Accessible from Settings → Safety → Blocked Users

---

## Phase 7 — Invite System

### 7.1 Invite repository + provider
Create:
- `lib/features/invite/data/repositories/invite_repository.dart`
- `lib/features/invite/providers/invite_provider.dart`

### 7.2 Invite screen
`lib/features/invite/presentation/screens/invite_screen.dart`
- Remaining codes count
- Generate new code button
- Code list with status + share/revoke
- Invite tree section

### 7.3 Sign up: real-time invite code validation
Call `GET /invite/validate/:code` on input, show green check / red X.

---

## Phase 8 — Verification System

### 8.1 Verification repository + provider
Create:
- `lib/features/verification/data/repositories/verification_repository.dart`
- `lib/features/verification/providers/verification_provider.dart`

### 8.2 Verification progress screen
`lib/features/verification/presentation/screens/verification_screen.dart`
- Level progress bar (0–5)
- Per-step cards: Email ✅, Phone (enter number), Photo (selfie), Community (vouch progress), ID (upload)

### 8.3 Show badges on matching cards
Already done in Phase 1 matching card update — just needs the verification field on User model (Phase 2.2).

---

## Phase 9 — Discover Tab Enhancements

### 9.1 Mode toggle
Add segmented control at top of matching screen: Friends | Dating | Both.
Already wired in Phase 1 (provider has `setMode`). Just add the UI toggle.

### 9.2 Card tap → full profile
Tapping a card opens expanded profile view (read-only, reuse user_profile_screen).

### 9.3 Consolidate discovery/matching
Deprecate `lib/features/discovery/` swipe system. All swiping through `lib/features/matching/`.

---

## Phase 10 — Polish & Remaining Fixes

### 10.1 Marketplace consultation path
Client: `POST /marketplace/:builderId/consultation` → fix to `POST /marketplace/consult` with `builder_id` in body.

### 10.2 Activity location picker
Fix location picker on create activity screen — ensure map picker works and returns coordinates.

### 10.3 Notification endpoints
Verify client notification routes match backend.

### 10.4 Conversation participants parsing
Handle both string IDs and populated user objects in `Conversation.fromJson()`.

### 10.5 Feed: trip + activity cards
Add special card types in feed for trip announcements and activities (not just regular posts).

---

## Phase Summary

| Phase | Focus | Status |
|-------|-------|--------|
| 1 | Fix breaking backend integration | ✅ Done |
| 2 | Data models + profile setup | Pending |
| 3 | Navigation restructure (5-tab redesign) | Pending |
| 4 | Chat tab (Tinder messages style) | Pending |
| 5 | Profile redesign (Instagram style) | Pending |
| 6 | Safety module (block/report) | Pending |
| 7 | Invite system | Pending |
| 8 | Verification system | Pending |
| 9 | Discover tab enhancements | Pending |
| 10 | Polish & remaining fixes | Pending |
