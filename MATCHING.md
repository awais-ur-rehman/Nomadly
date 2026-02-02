# Matching Feature (Tinder-Style) - API Documentation

This document outlines the API endpoints and real-time events for the swipe-based matching system.

---

## 🏗 Overview

The matching system allows users to:
1.  **Set Preferences**: Define age range, distance, and intent (friends/dating).
2.  **Get Recommendations**: Fetch a deck of compatible users to swipe on.
3.  **Swipe**: Like or pass on users.
4.  **Match**: When two users like each other, a **Match** is created, opening a chat channel.

---

## ⚙️ 1. Update Matching Preferences

### **PATCH `/api/v1/matching/preferences`**
Update discovery settings.

**Body**:
```json
{
  "intent": "friends", // "friends", "dating", "both"
  "preferences": {
    "gender_interest": ["all"], // ["male", "female", "all"]
    "min_age": 21,
    "max_age": 35,
    "max_distance_km": 50
  },
  "is_discoverable": true
}
```

**Response**:
```json
{
  "status": "success",
  "data": {
    "intent": "friends",
    "preferences": { ... },
    "is_discoverable": true
  }
}
```

---

## 🃏 2. Get Recommendations (The Deck)

### **GET `/api/v1/matching/recommendations`**
Fetch users to display in the swipe deck.
*   **Logic**: Returns users matching preferences who you haven't swiped on yet.
*   **Legacy Alias**: `/api/v1/matching/discovery`

**Query Params**:
- `page`: default 1
- `limit`: default 10

**Response**:
```json
{
  "status": "success",
  "data": {
    "users": [
      {
        "_id": "user123",
        "username": "vanlife_sarah",
        "profile": {
          "name": "Sarah",
          "age": 28,
          "photo_url": "...",
          "bio": "..."
        },
        "nomad_id": { "verified": true },
        "distance_km": 12
      }
    ]
  }
}
```

---

## 👆 3. Swipe Action

### **POST `/api/v1/matching/swipe`**
Record a like or pass.

**Body**:
```json
{
  "targetUserId": "user123",
  "action": "like" // "like", "pass", "super_like"
}
```

**Response (No Match)**:
```json
{
  "status": "success",
  "data": {
    "isMatch": false
  }
}
```

**Response (It's a Match! 🎉)**:
```json
{
  "status": "success",
  "data": {
    "isMatch": true,
    "match": {
      "_id": "match_abc123",
      "conversation_id": "conv_xyz789", // Chat ID
      "user": {
        "username": "vanlife_sarah",
        "profile": { "name": "Sarah", "photo_url": "..." }
      }
    }
  }
}
```

---

## 💌 4. Get Matches List

### **GET `/api/v1/matching/matches`**
Get list of confirmed matches (for the "New Matches" shelf).
*   **Legacy Alias**: `/api/v1/matching/mutual`

**Response**:
```json
{
  "status": "success",
  "data": {
    "matches": [
      {
        "matchId": "match_abc123",
        "conversation_id": "conv_xyz789",
        "matchedAt": "2026-01-26T...",
        "user": {
          "_id": "user123",
          "username": "vanlife_sarah",
          "profile": { ... }
        }
      }
    ]
  }
}
```

---

## ⚡ Real-Time Events (Socket.IO)

### Event: `match_new`
Triggered when **someone else** swipes right on you, completing a match.

**Payload**:
```json
{
  "match_id": "match_abc123",
  "conversation_id": "conv_xyz789",
  "partner": {
    "_id": "user456",
    "username": "john_nomad",
    "profile": {
      "name": "John",
      "photo_url": "..."
    }
  }
}
```

**Client Action**: Show "It's a Match!" overlay or update the matches list.
