# Nomadly — App Flow (Tinder + Instagram Hybrid)

Design inspired by **Instagram** (feed, stories, social) and **Tinder** (matching, swiping, chat after match).

---

## Core Principle

> Instagram for the community. Tinder for meeting people. Everything tied to the nomad lifestyle.

---

## 1. Onboarding & Auth

```
App Launch
  → Splash (auto-check token)
  → If no token → Onboarding (3 slides) → Sign In / Sign Up
  → If token valid → Home
```

### Sign Up Flow (invite-only)
```
Sign Up Screen
  ├── Invite Code (required, validated in real-time)
  ├── Name, Username, Email, Password
  └── Submit → OTP Screen (6-digit email code) → Profile Setup
```

### Profile Setup (multi-step, linear — NOT skippable)
```
Step 1: Photo Upload (required — at least 1 photo)
Step 2: Basics (age, gender, bio)
Step 3: Hobbies (multi-select chips)
Step 4: Rig Info (type, crew, pet-friendly)
Step 5: Travel Route (origin, destination, dates, duration)
Step 6: Distance Preference (slider: 25–500 km)
Step 7: Intent (Friends / Dating / Both)
  → Done → Home
```

**Key change:** Travel route + distance preference are part of onboarding, not buried in settings. Without them the matching algorithm has nothing to score.

---

## 2. Home — Bottom Navigation (5 tabs)

```
┌─────────────────────────────────────────┐
│  [Feed]  [Discover]  [+]  [Chat]  [Me] │
└─────────────────────────────────────────┘
```

| Tab | Icon | Screen | Inspired by |
|-----|------|--------|-------------|
| Feed | home | Social feed (stories + posts) | Instagram Home |
| Discover | explore/cards | Swipe matching cards | Tinder |
| + (Create) | add_circle | Create post / trip / activity (action sheet) | Instagram + button |
| Chat | chat_bubble | Conversations (matches + messages) | Tinder Messages |
| Me | person | Own profile | Instagram Profile |

### The "+" Button (Center FAB — Create Action Sheet)
Tapping "+" opens a bottom sheet with 3 options:
- **New Post** — Photo + caption (Instagram-style)
- **New Trip** — "I'm heading from A → B" (travel announcement others can join — uses `travel_route` update on backend)
- **New Activity** — "Meetup at location X on date Y" (existing activity feature)

This consolidates creation into one place instead of scattering FABs across screens.

---

## 3. Feed Tab (Instagram-style)

```
┌──────────────────────────────────────┐
│ Nomadly                    🔔  🛒   │ ← Notifications + Marketplace
├──────────────────────────────────────┤
│ [+] [story] [story] [story] →       │ ← Story bar (horizontal scroll)
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ @username              •••      │ │ ← Post card
│ │ [       Photo/Image          ]  │ │
│ │ ❤️ 💬 📤         🔖            │ │ ← Like, Comment, Share, Bookmark
│ │ 42 likes                        │ │
│ │ @username caption here...       │ │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ 🚐 Trip Announcement            │ │ ← Trip post (special card type)
│ │ @username is heading to          │ │
│ │ Denver, CO → Moab, UT           │ │
│ │ May 15 – May 22 (7 days)        │ │
│ │ [Join This Trip]                 │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ 🏕 Activity                      │ │ ← Activity post (special card)
│ │ Sunset Hike at Red Rocks         │ │
│ │ May 16, 6:00 PM · 3/8 joined    │ │
│ │ [Join Activity]                  │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Key design:**
- Stories at top (existing — works well)
- Feed is a mix of regular posts, trip announcements, and activities — all in one timeline
- Trip announcements are a special post type backed by `travel_route` update on the user model
- AppBar has Notifications (bell) and Marketplace (shopping bag) icons

---

## 4. Discover Tab (Tinder-style)

```
┌──────────────────────────────────────┐
│ Discover    [Friends|Dating|Both] ⚙️ │ ← Mode toggle + filter gear
├──────────────────────────────────────┤
│                                      │
│    ┌────────────────────────────┐    │
│    │                            │    │
│    │      [User Photo]          │    │
│    │                            │    │
│    │              85% Match  ↗  │    │ ← Compatibility badge
│    │              12 km         │    │ ← Distance
│    │                            │    │
│    │  Sarah, 28                 │    │
│    │  "Living the van life..."  │    │
│    │  🏕 Same destination       │    │ ← Score highlights
│    │  🎯 3 shared hobbies       │    │
│    │  [Hiking] [Photography]    │    │
│    └────────────────────────────┘    │
│                                      │
│    [  ✕  ]    [ ⭐ ]    [  ♥  ]     │ ← Pass / Super Like / Like
│                                      │
└──────────────────────────────────────┘
```

**Flow:**
1. Cards show one user at a time (Tinder stack)
2. Swipe right = like, left = pass, up = super like
3. On mutual like → "It's a Match!" dialog → "Send Message" or "Keep Swiping"
4. Mode toggle at top switches between Friends / Dating / Both
5. Gear icon opens distance filter bottom sheet
6. Tapping the card expands to full profile view (read-only)

**Match dialog → navigates to Chat tab** (conversation auto-created by backend).

---

## 5. Chat Tab (Tinder Messages)

```
┌──────────────────────────────────────┐
│ Messages                        🔍   │
├──────────────────────────────────────┤
│ New Matches (horizontal scroll)      │
│ [avatar] [avatar] [avatar] →         │ ← Tinder-style new match row
├──────────────────────────────────────┤
│ Conversations                        │
│ ┌──────────────────────────────────┐ │
│ │ [photo] Sarah         2m ago    │ │
│ │         Hey! Heading to Moab?   │ │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ [photo] Mike          1h ago    │ │
│ │         Cool rig setup!         │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Structure:**
- Top: Horizontal scroll of new/unread matches (avatar circles — Tinder style)
- Below: Conversation list sorted by last message time
- Tap match avatar → opens chat
- Tap conversation → opens chat
- Chat screen has: messages, typing indicator, ••• menu (Block / Report)

**Blocked users are hidden** from both the match row and conversations.

---

## 6. Profile Tab ("Me") — Instagram-style

```
┌──────────────────────────────────────┐
│ @username                    ⚙️  ✏️  │ ← Settings + Edit Profile
├──────────────────────────────────────┤
│         [Profile Photo]              │
│         Sarah Johnson                │
│         🔵 Verified (Level 3)        │ ← Verification badge
│                                      │
│   [Posts]     [Vouches]   [Trips]    │ ← Stats row
│     12          8           3        │
│                                      │
│   [Followers]  [Following]           │
│      156          89                 │
├──────────────────────────────────────┤
│ Living the van life with my dog 🐕   │ ← Bio
│                                      │
│ 🚐 Sprinter Van · Solo + Pet        │ ← Rig summary line
│ 📍 Denver → Moab · May 15-22        │ ← Current trip line
│                                      │
│ [Hiking] [Photography] [Climbing]    │ ← Hobby chips
├──────────────────────────────────────┤
│ [🔲 Grid] [📋 List]                  │ ← Post grid / list toggle
│ ┌─────┐ ┌─────┐ ┌─────┐            │
│ │photo│ │photo│ │photo│             │ ← Instagram-style grid
│ └─────┘ └─────┘ └─────┘            │
└──────────────────────────────────────┘
```

**Key changes from current:**
- Clean single-screen layout (no separate sections for every field)
- Rig + trip summarized in one-liners, not separate expandable sections
- Verification badge is prominent (level-based color)
- Posts grid at bottom (Instagram-style)
- Edit profile is ONE screen with sections, not scattered

---

## 7. Settings Screen (accessed from Profile gear icon)

```
Account
  ├── Edit Profile
  ├── Verification → Verification progress screen
  ├── Invite Codes → Invite management screen
  └── Private Account toggle

Matching
  ├── Matching Mode (Friends / Dating / Both)
  ├── Distance Preference (slider)
  ├── Age Range
  └── Gender Interest

Safety
  ├── Blocked Users → Blocked list with unblock
  └── Report History

About
  ├── Terms of Service
  ├── Privacy Policy
  └── App Version

[Logout]
```

---

## 8. Secondary Flows

### Marketplace (accessed from Feed AppBar icon)
```
Marketplace Screen
  ├── Search bar + specialty filter chips
  ├── Builder cards (photo, name, rating, specialty)
  └── Tap → Builder Detail
        ├── Portfolio gallery
        ├── Reviews
        └── [Request Consultation] → bottom sheet form
```

### Activities (accessed from "+" Create menu)
```
Create Activity
  ├── Title, Description
  ├── Location picker (map-based)
  ├── Date & Time
  ├── Max participants
  └── Submit → appears in feed as activity card
```

### View Other User Profile (tap from feed/discover/chat)
```
User Profile (read-only)
  ├── Same layout as own profile but read-only
  ├── [Follow] / [Unfollow] button
  ├── ••• menu → Block / Report
  └── If matched → [Message] button visible
```

---

## 9. Verification Flow (accessed from Settings)

```
Verification Screen
  ├── Level progress bar (0–5)
  ├── Step 1: Email ✅ (auto-done after OTP)
  ├── Step 2: Phone → enter number → submit for review
  ├── Step 3: Photo → take selfie → upload → submit
  ├── Step 4: Community → X/3 vouches (refresh button)
  └── Step 5: ID Document → upload + type picker → submit
```

---

## 10. Invite Flow (accessed from Settings)

```
Invite Screen
  ├── "You have X codes remaining"
  ├── [Generate New Code] button
  ├── List of codes with status (active/used/expired)
  │   ├── Tap code → Share sheet (native OS share)
  │   └── Swipe to revoke
  └── "My Network" section → invite tree visualization
```

---

## Navigation Map (complete)

```
Splash → Auth (Sign In / Sign Up → OTP → Profile Setup) → Home

Home (Bottom Nav)
├── Feed
│   ├── Stories (view/create)
│   ├── Posts (view/create)
│   ├── Trip announcements (create via "+")
│   ├── Activity cards (create via "+")
│   ├── → Marketplace (AppBar)
│   └── → Notifications (AppBar)
│
├── Discover
│   ├── Swipe cards (like/pass/super_like)
│   ├── Mode toggle (friends/dating/both)
│   ├── Distance filter
│   ├── → Full profile view (tap card)
│   └── → Match dialog → Chat
│
├── + (Create)
│   ├── New Post
│   ├── New Trip
│   └── New Activity
│
├── Chat
│   ├── New matches row
│   ├── Conversation list
│   └── Chat screen (messages + block/report)
│
└── Me (Profile)
    ├── Edit Profile
    ├── Settings
    │   ├── Verification
    │   ├── Invite Codes
    │   ├── Blocked Users
    │   ├── Matching Preferences
    │   └── Logout
    ├── Followers/Following
    └── Posts grid
```
