# Nomadly Flutter Client - Fixes & Integration Plan

Cross-referenced against the backend API (see `backend/API_DOCUMENTATION.md`).

---

## Critical Findings Summary

| Category | Items | Priority |
|----------|-------|----------|
| Backend integration broken | 6 issues | P0 |
| Missing features (no client code exists) | 3 modules | P0 |
| Data model gaps | 4 models need updates | P1 |
| UI missing functionality | 7 screens need changes | P1 |
| Inconsistencies / bugs | 5 issues | P2 |

---

## P0 — Backend Integration Broken

### 1. Registration requires `invite_code` — client doesn't send it

**Files to change:**
- `lib/features/auth/presentation/screens/sign_up_screen.dart` — add invite code text field
- `lib/features/auth/providers/auth_provider.dart` — add `inviteCode` param to `register()`
- `lib/features/auth/data/repositories/auth_repository.dart` — send `invite_code` in POST body

**What happens now:** Every registration call will fail with 400 validation error because the backend requires `invite_code` in the body.

---

### 2. Discovery swipe actions use wrong values

**File:** `lib/features/discovery/data/repositories/discovery_repository.dart` (line 50)

**Client sends:** `action: 'left'`, `'right'`, `'star'`
**Backend expects:** `action: 'like'`, `'pass'`, `'super_like'`

The discovery repository also sends `matched_user_id` instead of `targetUserId`.

**Fix:** Map the swipe actions:
- `left` → `pass`
- `right` → `like`
- `star` → `super_like`

And send `targetUserId` instead of `matched_user_id` (backend accepts both for backward compat, but `targetUserId` is preferred).

**Note:** The matching repository (`matching_repository.dart`) already uses the correct values (`like`, `pass`, `super_like`). Only the discovery repository is wrong.

---

### 3. Recommendations response shape changed — client won't parse scores

**File:** `lib/features/matching/data/repositories/matching_repository.dart` (line 41)

The backend now returns recommendations with this shape:
```json
{
  "_id": "...",
  "username": "...",
  "profile": { ... },
  "rig": { ... },
  "travel_route": { "destination": ..., "start_date": ..., "duration_days": ... },
  "distance_km": 45,
  "compatibility": { "route_overlap": 85, "temporal_overlap": 70, ... , "total": 73 }
}
```

The client parses this as `User.fromJson()` which will **ignore** the `compatibility` and `distance_km` fields because `User` model doesn't have them.

**Fix:** Either:
- (A) Parse recommendations as `DiscoveryUser` (which already has `score` and `distance` fields), or
- (B) Add `compatibility` and `distance_km` to the `User` model as optional fields

---

### 4. `mode` query param not sent on recommendations

**File:** `lib/features/matching/data/repositories/matching_repository.dart` (line 18)

Backend supports `?mode=friends|dating|both` to switch scoring weights. Client doesn't send it.

**Fix:** Add `mode` parameter to `getRecommendations()` and pass it as query param.

---

### 5. AppConfig missing 3 new endpoint paths

**File:** `lib/core/config/app_config.dart`

**Missing:**
```dart
static String get safetyEndpoint => '$baseUrl/api/v1/safety';
static String get inviteEndpoint => '$baseUrl/api/v1/invite';
static String get verificationEndpoint => '$baseUrl/api/v1/verification';
```

---

### 6. User model missing `verification` and `invited_by` fields

**File:** `lib/shared/models/user.dart`

Backend now returns these on every user object:
```json
{
  "verification": {
    "email": { "status": "verified" },
    "phone": { "status": "none" },
    "photo": { "status": "none" },
    "id_document": { "status": "none" },
    "community": { "status": "none", "vouch_count": 0 },
    "level": 1,
    "badge": "basic"
  },
  "invited_by": "userId",
  "invite_count": 3
}
```

Currently the model has no `verification` field. The `fromJson` will silently drop this data.

---

## P0 — Missing Features (No Client Code Exists)

### 7. Safety Module — Block & Report (COMPLETELY MISSING)

No client files exist for blocking or reporting users. Need to create:

**New files needed:**
- `lib/features/safety/data/repositories/safety_repository.dart`
- `lib/features/safety/providers/safety_provider.dart`

**UI integration points:**
- **Chat screen** — Add menu button with "Block User" and "Report User" options
- **User profile screen** — Add three-dot menu with Block/Report
- **Matching card** — Add report option (long press or menu)

**API calls needed:**
| Action | Method | Path |
|--------|--------|------|
| Block user | POST | `/api/v1/safety/block/:userId` |
| Unblock user | DELETE | `/api/v1/safety/block/:userId` |
| Get blocked list | GET | `/api/v1/safety/blocked` |
| Report user | POST | `/api/v1/safety/report/:userId` |

**UX flow:**
1. User taps three-dot menu on profile/chat → "Report" or "Block"
2. Report shows reason picker (harassment, fake_profile, spam, etc.) + optional description
3. Block immediately hides user from feed/chat/matching
4. Blocked users list accessible from Settings

---

### 8. Invite System (COMPLETELY MISSING)

No client files exist. Need to create:

**New files needed:**
- `lib/features/invite/data/repositories/invite_repository.dart`
- `lib/features/invite/providers/invite_provider.dart`
- `lib/features/invite/presentation/screens/invite_screen.dart`
- `lib/features/invite/presentation/widgets/invite_code_card.dart`

**UI integration points:**
- **Settings screen** — "My Invite Codes" section
- **Profile screen** — "Invite Friends" button
- **Sign Up screen** — Invite code input field (covered in P0 #1)

**API calls needed:**
| Action | Method | Path |
|--------|--------|------|
| Generate code | POST | `/api/v1/invite/generate` |
| List my codes | GET | `/api/v1/invite/my-codes` |
| Revoke code | DELETE | `/api/v1/invite/:codeId` |
| Validate code | GET | `/api/v1/invite/validate/:code` |
| View invite tree | GET | `/api/v1/invite/tree` |

**UX flow:**
1. User navigates to "Invite Codes" from profile/settings
2. Sees list of their codes with usage status
3. Can generate new code (shows NOMAD-XXXXX)
4. Can share code via native share sheet
5. Can revoke unused codes
6. Can view "My Network" — who they invited, who invited them

---

### 9. Verification System (COMPLETELY MISSING)

No client files exist. Need to create:

**New files needed:**
- `lib/features/verification/data/repositories/verification_repository.dart`
- `lib/features/verification/providers/verification_provider.dart`
- `lib/features/verification/presentation/screens/verification_screen.dart`
- `lib/features/verification/presentation/widgets/verification_level_card.dart`
- `lib/shared/models/verification.dart` — Freezed model for verification status

**UI integration points:**
- **Profile screen** — Show verification badge (level-based, not just boolean)
- **Settings screen** — "Verification" section with level progress
- **Matching card** — Show verification badge on cards

**API calls needed:**
| Action | Method | Path |
|--------|--------|------|
| Get status | GET | `/api/v1/verification/status` |
| Submit phone | POST | `/api/v1/verification/phone` |
| Submit selfie | POST | `/api/v1/verification/photo` |
| Submit ID doc | POST | `/api/v1/verification/id-document` |
| Refresh community | POST | `/api/v1/verification/community/refresh` |

**UX flow:**
1. Profile/Settings shows verification level progress (0-5 with badges)
2. Each level has a card: "Email ✓" → "Add Phone" → "Verify Photo" → "Get Vouched" → "Verify ID"
3. Phone: enter number → submitted for review
4. Photo: take selfie via camera → upload via existing upload service → submit URL
5. ID: pick image from gallery → upload → submit URL + type (license/passport/national_id)
6. Community: shows vouch progress (X/3 needed) with button to refresh

---

## P1 — Data Model Gaps

### 10. User model needs new fields

**File:** `lib/shared/models/user.dart`

Add to Freezed class:
```dart
Verification? verification,
String? invitedBy,
@Default(0) int inviteCount,
```

Create new model `lib/shared/models/verification.dart`:
```dart
@freezed class Verification { ... }
@freezed class VerificationItem { status, verified_at, ... }
```

---

### 11. DiscoveryUser / recommendation model needs compatibility breakdown

**File:** `lib/shared/models/match.dart`

The `DiscoveryUser` model has `int? score` but the backend returns a full breakdown object:
```json
{
  "compatibility": {
    "route_overlap": 85,
    "temporal_overlap": 70,
    "hobby_match": 60,
    "proximity": 90,
    "trust": 50,
    "rig_compatibility": 70,
    "total": 73
  }
}
```

Need a new `CompatibilityScore` Freezed model and update recommendation parsing.

---

### 12. Match model field alignment

**File:** `lib/shared/models/match.dart`

Client `Match` model has `swipeAction` field with values `left/right/star`.
Backend `Match` model doesn't have a swipe action — it has `users[]`, `initiated_by`, `conversation_id`, `created_at`.

The backend match response looks like:
```json
{
  "_id": "...",
  "userId": "...",
  "matchedUserId": "...",
  "matchedUser": { ... },
  "conversation_id": { ... },
  "createdAt": "..."
}
```

Verify the `fromJson` handles both `_id` and `id`, and `createdAt` vs `created_at`.

---

### 13. Conversation model — check `participants` parsing

Backend returns participants as populated user objects. Check that the client `Conversation.fromJson()` can handle both ID strings and populated objects.

---

## P1 — UI Missing Functionality

### 14. Profile screen — verification badge needs upgrade

**File:** `lib/features/profile/presentation/screens/profile_screen.dart` (line 117)

Currently shows a single "Verified Nomad" badge from `nomadId.verified`. Needs to show the 5-level badge system:
- Level 0: No badge
- Level 1: "Email Verified" (gray)
- Level 2: "Trusted" (blue)
- Level 3: "Verified" (blue checkmark)
- Level 4: "Super Verified" (gold)
- Level 5: "Nomad Elite" (gold star)

---

### 15. Matching card — show compatibility score

**File:** `lib/features/matching/presentation/widgets/matching_card.dart`

Currently shows: photo, name, age, bio, hobbies.
Should also show:
- Compatibility percentage (total score)
- Key score highlights (e.g., "Same destination!", "3 shared hobbies")
- Verification badge
- Distance

---

### 16. Chat screen — add block/report menu

**File:** `lib/features/chat/presentation/screens/chat_screen.dart`

Add an AppBar action button (three dots or shield icon) that opens a bottom sheet with:
- "Block User" → calls safety API → navigates back to inbox
- "Report User" → shows reason picker → calls safety API

---

### 17. Settings screen — add new sections

**File:** `lib/features/profile/presentation/screens/settings_screen.dart`

Add sections for:
- "Verification" → navigate to verification screen
- "Invite Codes" → navigate to invite screen
- "Blocked Users" → navigate to blocked users list
- "Matching Mode" → toggle between friends/dating/both (updates preferences)

---

### 18. Inbox/Matches screen — filter out blocked users

Ensure conversations with blocked users are hidden or marked. The backend already prevents message sending, but the client should hide the conversation from the list.

---

### 19. Matching screen — add mode toggle

Add a tab bar or toggle at the top: "Friends" | "Dating" | "Both"
Passes `mode` query param to recommendations API. Different modes show different scoring weights.

---

### 20. Sign Up screen — invite code validation UX

When user types an invite code, call `GET /api/v1/invite/validate/:code` to show real-time validity (green check / red X).

---

## P2 — Inconsistencies & Minor Bugs

### 21. Duplicate swipe systems

Two completely separate swipe systems exist:
- `lib/features/discovery/` — uses legacy `/discovery` endpoints with `left/right/star`
- `lib/features/matching/` — uses `/v1/matching` endpoints with `like/pass/super_like`

**Recommendation:** Deprecate the discovery swipe system. Consolidate to the matching system only. The matching system uses the correct v1 API with proper action enums.

---

### 22. Feed endpoint path inconsistency

**File:** `lib/features/discovery/data/repositories/discovery_repository.dart` (line 21)

Uses `/discovery` which maps to legacy `matchingRoutes`. The social feed is at `/feed`.
These are two different things — the discovery feed is matching recommendations, not posts.
Make sure the naming doesn't confuse developers.

---

### 23. Notifications endpoint may not match

**Client:** `GET /notifications`, `POST /notifications/:id/read`, `POST /notifications/read-all`
**Backend:** Only `POST /test` exists on notifications. The read/mark endpoints may not exist yet.

Verify the backend notification routes match what the client expects.

---

### 24. Profile setup doesn't handle the new verification auto-setup

After OTP verification, the backend now sets `verification.email.status = "verified"` and `verification.level = 1`. The profile setup screen should reflect this — show "Email Verified ✓" as the first completed step.

---

### 25. Marketplace consultation request path mismatch

**Client:** `POST /marketplace/:builderId/consultation`
**Backend:** `POST /marketplace/consult` with `builder_id` in body

These don't match. Either update the client to POST to `/consult` with body, or verify the backend has both routes.

---

## Implementation Order

### Phase A — Fix Breaking Changes (must do first)
1. Fix registration to include invite_code (#1)
2. Fix discovery swipe action values (#2)
3. Add missing AppConfig endpoints (#5)

### Phase B — Data Model Updates
4. Update User model with verification fields (#10)
5. Create Verification Freezed model (#10)
6. Create CompatibilityScore model (#11)
7. Update recommendation parsing (#3)

### Phase C — Safety Module (block/report)
8. Create safety repository + provider (#7)
9. Add block/report to chat screen (#16)
10. Add block/report to profile screen
11. Add blocked users list to settings (#17)

### Phase D — Invite System
12. Create invite repository + provider (#8)
13. Add invite code to sign up screen (#1)
14. Create invite codes management screen (#8)
15. Add invite section to settings (#17)

### Phase E — Verification System
16. Create verification repository + provider (#9)
17. Create verification progress screen (#9)
18. Upgrade profile badge display (#14)
19. Show badges on matching cards (#15)

### Phase F — Matching Enhancements
20. Add mode toggle to matching screen (#19)
21. Show compatibility scores on cards (#15)
22. Send mode param on recommendations (#4)
23. Consolidate discovery/matching systems (#21)

### Phase G — Polish
24. Fix marketplace endpoint mismatch (#25)
25. Verify notification endpoints (#23)
26. Add invite code validation UX (#20)
27. Filter blocked users from inbox (#18)
