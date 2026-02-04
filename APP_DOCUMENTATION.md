# Nomadly App Documentation

A comprehensive guide to the Nomadly mobile application - a social networking platform designed for digital nomads, vanlifers, and travelers.

---

## Table of Contents

1. [App Overview](#app-overview)
2. [Technology Stack](#technology-stack)
3. [Frontend Architecture](#frontend-architecture)
4. [Backend Architecture](#backend-architecture)
5. [Feature Modules](#feature-modules)
6. [Data Models](#data-models)
7. [API Endpoints](#api-endpoints)
8. [App Flow](#app-flow)
9. [Monetization](#monetization)

---

## App Overview

**Nomadly** is a mobile-first social platform connecting digital nomads and travelers worldwide. Key value propositions:

- **Smart Matching**: Algorithm-based traveler discovery using location, interests, and travel routes
- **Social Feed**: Share travel experiences through posts, stories, and trip updates
- **Real-time Chat**: Direct messaging with matched travelers
- **Activities**: Create and join local meetups/events
- **Marketplace**: Job board and talent discovery for remote workers
- **Verification System**: Multi-tier trust system for user safety

---

## Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.x with Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Real-time**: Socket.IO Client
- **Local Storage**: flutter_secure_storage
- **Maps**: Mapbox GL
- **Payments**: RevenueCat SDK

### Backend (Node.js)
- **Framework**: Express.js with TypeScript
- **Database**: MongoDB with Mongoose
- **Cache**: Redis
- **Real-time**: Socket.IO
- **Authentication**: JWT with bcrypt
- **File Upload**: Multer with cloud storage
- **API Docs**: Swagger/OpenAPI

---

## Frontend Architecture

### Directory Structure

```
client/lib/
├── core/                 # Core utilities and configuration
│   ├── config/          # App configuration (router, theme)
│   └── utils/           # Helper utilities
├── features/            # Feature modules (domain-driven)
│   ├── auth/            # Authentication & onboarding
│   ├── discovery/       # Home screen & user search
│   ├── chat/            # Messaging & conversations
│   ├── social/          # Feed, posts, stories
│   ├── profile/         # User profile management
│   ├── matching/        # Swipe-based matching
│   ├── marketplace/     # Jobs & builders
│   ├── activities/      # Events & meetups
│   ├── safety/          # Blocking & reporting
│   ├── verification/    # Identity verification
│   ├── invite/          # Invite codes
│   └── map/             # Location picker
└── shared/              # Shared resources
    ├── models/          # Data models (Freezed)
    ├── services/        # API services
    ├── providers/       # Riverpod providers
    └── widgets/         # Reusable UI components
```

### Feature Module Structure

Each feature module follows this pattern:

```
feature/
├── data/
│   └── repositories/    # Data layer, API calls
├── presentation/
│   ├── screens/         # UI screens
│   └── widgets/         # Feature-specific widgets
└── providers/           # State management
```

---

## Backend Architecture

### Directory Structure

```
backend/src/
├── config/              # Database, Redis, environment
├── middleware/          # Auth, error handling, validation
├── modules/             # Feature modules
│   ├── auth/
│   ├── users/
│   ├── chat/
│   ├── feed/
│   ├── matching/
│   ├── marketplace/
│   ├── activities/
│   ├── safety/
│   ├── stories/
│   ├── notifications/
│   ├── payments/
│   ├── upload/
│   ├── verification/
│   ├── invite/
│   └── vouching/
├── types/               # TypeScript type definitions
└── utils/               # Error handling, logging
```

### Module Structure

Each backend module follows:

```
module/
├── controllers/         # Request handlers
├── services/           # Business logic
├── models/             # Mongoose schemas
└── routes/             # Express routes
```

---

## Feature Modules

### 1. Authentication (`auth`)

**Purpose**: User registration, login, and session management.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| SplashScreen | `/` | Initial loading, auth check |
| OnboardingScreen | `/onboarding` | App introduction carousel |
| SignUpScreen | `/sign-up` | Email/password registration |
| SignInScreen | `/sign-in` | Login with credentials |
| OTPScreen | `/otp` | Email verification code entry |
| ProfileSetupScreen | `/profile-setup` | Initial profile completion |
| ForgotPasswordScreen | `/forgot-password` | Password reset request |
| ResetPasswordScreen | `/reset-password` | New password entry |

#### Backend Service Methods
- `register(email, password, username)` - Create new user
- `login(email, password)` - Authenticate user
- `verifyEmail(email, code)` - Verify OTP code
- `requestPasswordReset(email)` - Send reset email
- `resetPassword(email, newPassword)` - Update password

---

### 2. Discovery (`discovery`)

**Purpose**: Main home screen with navigation to all app features.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| HomeScreen | `/home` | Bottom nav: Feed, Travelers, Matching, Inbox, Profile |
| SearchUsersScreen | `/search` | Search users by name/username |
| UserProfileScreen | `/user/:id` | View any user's profile |

---

### 3. Chat (`chat`)

**Purpose**: Real-time messaging between users.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| InboxScreen | (Tab) | List of conversations |
| ChatScreen | `/chat/:id` | Individual conversation |

#### Backend Service Methods
- `getConversations(userId)` - Get user's conversation list
- `getMessages(conversationId, pagination)` - Paginated messages
- `createMessage(conversationId, senderId, message)` - Send message
- `getOrCreateConversation(userId1, userId2)` - Start new DM
- `markAsRead(conversationId, userId)` - Mark messages read

#### Real-time Events (Socket.IO)
- `join:conversation` - Join chat room
- `message:new` - New message received
- `message:read` - Message read status update

---

### 4. Social Feed (`social`)

**Purpose**: Content sharing - posts, stories, and trips.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| PostsFeedScreen | (Tab) | Home timeline with posts |
| CreatePostScreen | `/create-post` | New photo post |
| PostDetailScreen | `/post/:id` | View post with comments |
| CreateStoryScreen | `/create-story` | 24-hour ephemeral story |
| CreateTripScreen | `/create-trip` | Share travel itinerary |
| NotificationsScreen | `/notifications` | App notifications |

#### Backend Service Methods (FeedService)
- `createPost(userId, photos, caption, tags)` - Create new post
- `getTimeline(userId, page, limit)` - Home feed (followed users)
- `getPost(postId)` - Single post details
- `deletePost(postId, userId)` - Remove own post
- `toggleLike(postId, userId)` - Like/unlike post
- `addComment(postId, userId, text)` - Comment on post
- `getComments(postId, page, limit)` - Get post comments
- `getUserPosts(targetUserId, requesterId)` - User's posts

---

### 5. Profile (`profile`)

**Purpose**: User profile management and social connections.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| ProfileScreen | (Tab) | Current user's profile |
| UserProfileScreen | `/profile/:id` | View other user's profile |
| EditProfileScreen | `/edit-profile` | Update profile info |
| SettingsScreen | `/settings` | App settings, logout |
| FollowersListScreen | `/profile/:id/connections` | Followers/following lists |
| MatchingPreferencesScreen | `/matching-preferences` | Discovery preferences |

#### Backend Service Methods (UserService)
- `getUserById(userId, currentUserId)` - Get profile with relationship
- `updateProfile(userId, updates)` - Update profile fields
- `completeProfile(userId, profileData)` - Initial setup
- `updateTravelRoute(userId, origin, destination, dates)` - Set travel plans
- `searchUsers(filters, pagination)` - Search by criteria
- `followUser(followerId, followingId)` - Follow a user
- `unfollowUser(followerId, followingId)` - Unfollow
- `getFollowers(userId, page, limit)` - List followers
- `getFollowing(userId, page, limit)` - List following
- `searchTravelers(lat, lng, radius, pagination)` - Nearby travelers

---

### 6. Matching (`matching`)

**Purpose**: Swipe-based traveler discovery with smart recommendations.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| MatchingScreen | (Tab) | Swipe cards for discovery |

#### Backend Service Methods (MatchingService)
- `getRecommendations(userId, page, limit, mode)` - Smart recommendations
- `swipe(actorId, targetId, action)` - Like/pass/super_like
- `getMatches(userId)` - List of mutual matches
- `updatePreferences(userId, data)` - Update match criteria

#### Matching Algorithm
The recommendation engine scores candidates on 6 dimensions:
1. **Route Overlap** - Travel route intersection
2. **Temporal Overlap** - Matching travel dates
3. **Hobby Match** - Shared interests
4. **Proximity** - Geographic closeness
5. **Trust Score** - Verification level
6. **Rig Match** - Vehicle compatibility

---

### 7. Marketplace (`marketplace`)

**Purpose**: Job board and talent discovery for digital nomads.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| MarketplaceScreen | `/marketplace` | Tabs: Find Talent, Job Board |
| BuilderDetailScreen | `/builder/:id` | Service provider profile |
| CreateJobScreen | `/marketplace/create-job` | Post a new job |
| JobDetailScreen | `/job/:id` | View job details |

#### Backend Service Methods

**MarketplaceService (Builders/Talent):**
- `searchBuilders(filters, pagination)` - Find service providers
- `requestConsultation(requesterId, builderId, specialty)` - Book consultation
- `acceptConsultation(consultationId, builderId)` - Accept booking
- `createReview(consultationId, reviewerId, rating, comment)` - Leave review

**JobService (Jobs):**
- `createJob(authorId, data)` - Post new job (3/week free limit)
- `searchJobs(lat, lng, radius, filters, pagination)` - Search jobs
- `getJobById(jobId)` - Get job details
- `deleteJob(jobId, userId)` - Remove own job

---

### 8. Activities (`activities`)

**Purpose**: Local meetups and group events.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| ActivitiesListScreen | `/activities` | Nearby activities list |
| ActivityDetailScreen | `/activity/:id` | View activity details |
| CreateActivityScreen | `/create-activity` | Host new activity |

#### Backend Service Methods (ActivityService)
- `createActivity(hostId, activityData)` - Create event
- `getNearbyActivities(location, maxDistance)` - Find nearby
- `requestJoin(activityId, userId)` - Request to join
- `approveParticipant(activityId, hostId, participantId)` - Accept request
- `rejectParticipant(activityId, hostId, participantId)` - Decline request
- `expireActivities()` - Mark past events expired

---

### 9. Safety (`safety`)

**Purpose**: User blocking, reporting, and moderation.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| BlockedUsersScreen | `/blocked-users` | Manage blocked users |

#### Backend Service Methods (SafetyService)
- `blockUser(blockerId, blockedId)` - Block user (removes matches/follows)
- `unblockUser(blockerId, blockedId)` - Unblock user
- `getBlockedUsers(userId)` - List blocked users
- `getBlockedUserIds(userId)` - Get all hidden user IDs
- `isBlocked(userId1, userId2)` - Check block status
- `reportUser(reporterId, reportedId, reason, description)` - File report
- `getReports(status, page, limit)` - Admin: list reports
- `resolveReport(reportId, adminId, action, notes)` - Admin: resolve
- `suspendUser(adminId, targetUserId)` - Admin: suspend user

---

### 10. Verification (`verification`)

**Purpose**: Multi-tier identity verification for trust and safety.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| VerificationScreen | `/verification` | Submit verification docs |

#### Verification Levels
| Level | Badge | Requirements |
|-------|-------|--------------|
| 0 | None | No verification |
| 1 | Basic | Email verified |
| 2 | Trusted | Email + Phone submitted |
| 3 | Verified | Email + Phone + Photo verified |
| 4 | Super Verified | Above + 3 community vouches |
| 5 | Nomad Elite | Above + ID document verified |

#### Backend Service Methods (VerificationService)
- `getVerificationStatus(userId)` - Current verification state
- `submitPhone(userId, phoneNumber)` - Submit phone for verification
- `submitPhotoVerification(userId, selfieUrl)` - Submit selfie
- `submitIdDocument(userId, documentUrl, documentType)` - Submit ID
- `refreshCommunityStatus(userId)` - Check vouch count
- `adminReviewPhone/Photo/IdDocument(adminId, userId, action)` - Admin review

---

### 11. Invite (`invite`)

**Purpose**: Referral system with invite codes.

#### Frontend Screens
| Screen | Path | Description |
|--------|------|-------------|
| InviteScreen | `/invites` | View/share invite codes |

---

## Data Models

### Core Models

#### User
```dart
@freezed
class User {
  String id;
  String username;
  String email;
  Profile? profile;
  NomadId? nomadId;        // Verification info
  MatchingProfile? matchingProfile;
  TravelRoute? travelRoute;
  Rig? rig;               // Vehicle info
  Subscription subscription;
  DateTime? lastActive;
  bool isActive;
  bool isBuilder;
}
```

#### Post
```dart
@freezed
class Post {
  String id;
  User author;
  List<String> photos;
  String? caption;
  List<String> tags;
  PostType type;          // post, trip, story
  int likeCount;
  int commentCount;
  bool isLiked;
  DateTime createdAt;
}
```

#### Job
```dart
@freezed
class Job {
  String id;
  User author;
  String title;
  String description;
  String category;
  double budget;
  String budgetType;      // fixed, hourly
  GeoPoint location;
  bool isRemote;
  String status;          // open, filled, closed
  DateTime createdAt;
}
```

#### Activity
```dart
@freezed
class Activity {
  String id;
  User host;
  String title;
  String description;
  String activityType;
  GeoPoint location;
  DateTime eventTime;
  int maxParticipants;
  List<User> currentParticipants;
  List<User> pendingRequests;
  String status;          // open, full, expired
  bool verifiedOnly;
}
```

#### Conversation
```dart
@freezed
class Conversation {
  String id;
  List<User> participants;
  String? lastMessage;
  DateTime? lastMessageTime;
  String type;            // direct, group
}
```

#### Message
```dart
@freezed
class Message {
  String id;
  String conversationId;
  User sender;
  String message;
  String messageType;     // text, image, location
  List<String> readBy;
  DateTime timestamp;
}
```

---

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/verify-email` | Verify OTP |
| POST | `/api/auth/forgot-password` | Request reset |
| POST | `/api/auth/reset-password` | Reset password |

### Users
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/me` | Current user profile |
| GET | `/api/users/:id` | Get user by ID |
| PUT | `/api/users/me` | Update profile |
| GET | `/api/users/search` | Search users |
| GET | `/api/users/travelers` | Nearby travelers |
| POST | `/api/users/:id/follow` | Follow user |
| DELETE | `/api/users/:id/follow` | Unfollow user |
| GET | `/api/users/:id/followers` | Get followers |
| GET | `/api/users/:id/following` | Get following |

### Feed
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/feed` | Home timeline |
| POST | `/api/feed/posts` | Create post |
| GET | `/api/feed/posts/:id` | Get post |
| DELETE | `/api/feed/posts/:id` | Delete post |
| POST | `/api/feed/posts/:id/like` | Like/unlike post |
| GET | `/api/feed/posts/:id/comments` | Get comments |
| POST | `/api/feed/posts/:id/comments` | Add comment |

### Chat
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/chat/conversations` | List conversations |
| GET | `/api/chat/conversations/:id` | Get conversation |
| POST | `/api/chat/conversations` | Start conversation |
| GET | `/api/chat/conversations/:id/messages` | Get messages |
| POST | `/api/chat/conversations/:id/messages` | Send message |

### Matching
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/matching/recommendations` | Get recommendations |
| POST | `/api/matching/swipe` | Record swipe |
| GET | `/api/matching/matches` | List matches |
| PUT | `/api/matching/preferences` | Update preferences |

### Marketplace
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/marketplace/builders` | Search builders |
| POST | `/api/marketplace/consultations` | Request consultation |
| PUT | `/api/marketplace/consultations/:id` | Accept consultation |
| POST | `/api/marketplace/reviews` | Create review |
| GET | `/api/marketplace/jobs` | Search jobs |
| POST | `/api/marketplace/jobs` | Create job |
| GET | `/api/marketplace/jobs/:id` | Get job |
| DELETE | `/api/marketplace/jobs/:id` | Delete job |

### Activities
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/activities` | Nearby activities |
| POST | `/api/activities` | Create activity |
| GET | `/api/activities/:id` | Get activity |
| POST | `/api/activities/:id/join` | Request join |
| PUT | `/api/activities/:id/approve/:userId` | Approve participant |
| PUT | `/api/activities/:id/reject/:userId` | Reject participant |

### Safety
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/safety/block/:userId` | Block user |
| DELETE | `/api/safety/block/:userId` | Unblock user |
| GET | `/api/safety/blocked` | List blocked users |
| POST | `/api/safety/report/:userId` | Report user |

### Verification
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/verification/status` | Get verification status |
| POST | `/api/verification/phone` | Submit phone |
| POST | `/api/verification/photo` | Submit photo |
| POST | `/api/verification/id` | Submit ID document |

---

## App Flow

### 1. Onboarding Flow
```
SplashScreen → OnboardingScreen → SignUpScreen → OTPScreen → ProfileSetupScreen → HomeScreen
```

### 2. Login Flow
```
SplashScreen → SignInScreen → HomeScreen
(or → OTPScreen if email not verified)
```

### 3. Discovery Flow
```
HomeScreen (Travelers Tab) → UserProfileScreen → StartChat / Follow
```

### 4. Matching Flow
```
HomeScreen (Matching Tab) → Swipe Cards → Match Popup → ChatScreen
```

### 5. Post Creation Flow
```
HomeScreen (Feed Tab) → FAB → CreatePostScreen → PostsFeedScreen
```

### 6. Activity Flow
```
HomeScreen → ActivitiesListScreen → ActivityDetailScreen → Request Join
```

### 7. Marketplace Flow
```
HomeScreen → MarketplaceScreen → CreateJobScreen / JobDetailScreen
```

---

## Monetization

### Subscription Tiers

| Feature | Free | Pro |
|---------|------|-----|
| Daily swipes | 10 | Unlimited |
| Job postings | 3/week | Unlimited |
| Super likes | 1/day | 5/day |
| See who liked you | ❌ | ✅ |
| Advanced filters | ❌ | ✅ |
| Priority support | ❌ | ✅ |

### Integration
- **RevenueCat SDK** for subscription management
- Platform: iOS App Store + Google Play
- Entitlement ID: `pro_access`

---

## Environment Variables

### Client (.env)
```
BASE_URL=http://your-api-url
MAPBOX_ACCESS_TOKEN=your_mapbox_token
REVENUE_CAT_GOOGLE_KEY=your_google_key
REVENUE_CAT_APPLE_KEY=your_apple_key
```

### Backend (.env)
```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/nomadly
JWT_SECRET=your_jwt_secret
REDIS_URL=redis://localhost:6379
CLOUDINARY_URL=your_cloudinary_url
```

---

## Running the App

### Backend
```bash
cd backend
npm install
npm run dev
```

### Frontend
```bash
cd client
flutter pub get
flutter run
```

### Clean Build (Flutter)
```bash
./run_clean.sh
```

---

*Last updated: February 2026*
