# AI Development Prompt for Nomadly Flutter App

## 🎯 Your Mission

You are tasked with building a cross-platform Flutter mobile app called **Nomadly** - a location-based social platform for digital nomads. You will follow best practices, write clean code, and build the app in phases.

---

## 📚 Required Reading - MANDATORY

Before writing ANY code, you MUST thoroughly read:

1. **`NOMADLY_TECH_SPEC.md`** - Complete technical specification with app flow, screens, and architecture
2. **`API_DOCUMENTATION.md`** - Backend API documentation with all endpoints, request/response formats
3. **`.agent/skills/flutter-expert/SKILL.md`** - Flutter best practices and coding standards
4. **All reference files** in `.agent/skills/flutter-expert/references/`:
   - `riverpod-state.md` - State management patterns
   - `gorouter-navigation.md` - Navigation setup
   - `widget-patterns.md` - Widget best practices
   - `project-structure.md` - Architecture guidelines
   - `performance.md` - Optimization techniques

---

## 🎨 Design Reference

You have been provided with Figma design screenshots showing:
- UI components and layouts
- Color scheme and typography
- Screen flows and interactions
- Visual design language

Use these as your visual reference while following the technical specifications.

---

## ⚠️ CRITICAL RULES

### 1. Ask Questions First
**IF YOU ARE CONFUSED OR UNCERTAIN ABOUT ANYTHING:**
- **STOP immediately**
- **DO NOT make assumptions**
- **ASK clarifying questions**

Examples of when to ask:
- "The API documentation shows X, but the spec mentions Y. Which should I follow?"
- "I'm unsure how to handle this edge case. Should I...?"
- "The design shows this component, but I need clarification on the behavior"

### 2. Follow Flutter Best Practices
- ✅ Use `const` constructors everywhere possible
- ✅ Implement proper widget keys for lists
- ✅ Use Riverpod for state management (NOT StatefulWidget for app state)
- ✅ Follow Clean Architecture (data/domain/presentation layers)
- ✅ Write testable, modular code
- ❌ Never mutate state directly
- ❌ Never build widgets inside build() methods
- ❌ Never block UI thread with heavy operations

### 3. API Integration Requirements
- All endpoints from `1769277612800_API_DOCUMENTATION.md` must be used correctly
- JWT tokens stored in flutter_secure_storage
- Auto-refresh tokens on 401 errors
- Proper error handling with user-friendly messages
- Socket.IO for real-time chat features

### 4. Asset Management
- Copy assets from `online-world/` directory to `assets/` first
- When you encounter a missing asset, add a TODO comment:
  ```dart
  // TODO: Add assets/icons/nav/home.svg
  Icon(Icons.home) // Placeholder until asset is provided
  ```
- List all missing assets at the end of your response

---

## 🏗️ Development Approach

### Phase-Based Development

Build the app in phases as defined in `NOMADLY_TECH_SPEC.md`:

**PHASE 1 - MVP (Priority)**:
1. Authentication flow (Sign up → OTP → Login → Token management)
2. Profile setup and management
3. Discovery/matching system with swipe cards
4. Real-time chat with Socket.IO

**PHASE 2 - Extended**:
5. Activities/beacons with maps
6. Social posts and stories
7. Notifications

**PHASE 3 - Advanced**:
8. Builder marketplace
9. Advanced features

### Development Workflow

For each feature/screen:

1. **Plan** - Create a brief implementation plan
2. **Structure** - Set up necessary files (models, repositories, providers, screens, widgets)
3. **Implement** - Write code following best practices
4. **Review** - Check against guidelines
5. **Document** - Note any missing assets or clarifications needed

---

## 📋 Step-by-Step Instructions

### Step 1: Project Setup
1. Create Flutter project structure as defined in tech spec
2. Add dependencies to pubspec.yaml
3. Copy assets from `online-world/` to `assets/`
4. Configure app theme (colors, typography from design)
5. Set up API client (Dio) with interceptors
6. Set up secure storage for tokens
7. Configure GoRouter for navigation

### Step 2: Core Infrastructure
1. Implement API client with:
   - Base URL configuration (http://localhost:3000 for dev)
   - Auth interceptor (inject JWT tokens)
   - Error interceptor (handle 401, refresh tokens)
2. Implement Socket.IO service for real-time features
3. Create shared widgets (buttons, text fields, loading indicators)
4. Set up app routes

### Step 3: Authentication (Phase 1)
Build in this order:
1. Splash screen → Check token → Navigate accordingly
2. Onboarding screens (PageView with 4 slides)
3. Sign in screen → API call → Store tokens → Navigate to home
4. Sign up screen → API call → Navigate to OTP
5. OTP verification → API call → Store tokens → Navigate to profile setup
6. Profile setup (multi-step form) → API calls → Navigate to home

**Key Points**:
- Use Riverpod for auth state
- Store tokens in flutter_secure_storage
- Implement token refresh logic
- Handle all error cases

### Step 4: Discovery Feed (Phase 1)
1. Home screen with user cards
2. Swipeable card stack (use package or custom)
3. Filter bottom sheet (intent, rig type, verified)
4. Swipe actions → API calls → Handle mutual matches
5. Mutual matches screen

### Step 5: Profile (Phase 1)
1. Profile screen (own) → Load from API
2. Edit profile screen → Update API
3. Other user profile screen
4. Image upload functionality
5. Settings screen

### Step 6: Chat (Phase 1)
1. Socket.IO service setup
2. Inbox screen → Load conversations
3. Chat screen → Load messages, send messages
4. Real-time message receiving
5. Typing indicators
6. Read receipts
7. Image sharing

### Step 7: Testing
1. Test on physical Android device
2. Verify all API calls work
3. Test Socket.IO real-time features
4. Test token refresh
5. Test image upload
6. Handle edge cases and errors

---

## 🎯 Code Quality Standards

### Every File Must Have:
- Clear, descriptive names
- Proper imports (organize by: dart, flutter, packages, project)
- Documentation comments for complex logic
- Error handling
- Loading states where applicable

### Example Code Structure:

```dart
// lib/features/auth/presentation/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/theme/colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await ref.read(authProvider.notifier).login(email, password);
      // Navigation handled by auth state listener
    } catch (e) {
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Sign in button
                CustomButton(
                  text: 'Sign In',
                  onPressed: authState.isLoading ? null : _handleSignIn,
                  isLoading: authState.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🔍 Testing Checklist

After implementing each feature, verify:

- [ ] Code compiles without errors
- [ ] All widgets use const where possible
- [ ] State management follows Riverpod patterns
- [ ] API calls work correctly
- [ ] Error handling is implemented
- [ ] Loading states are shown
- [ ] Navigation works as expected
- [ ] UI matches design reference
- [ ] Code is properly formatted
- [ ] No hardcoded values (use constants)

---

## 📝 Deliverables

For each development session, provide:

1. **Files Created/Modified**: List all files with brief description
2. **Implementation Summary**: What was built and how
3. **API Endpoints Used**: Which endpoints were integrated
4. **Missing Assets**: List any assets that need to be provided
5. **Next Steps**: What should be built next
6. **Questions/Clarifications**: Any uncertainties or decisions needed

---

## 🚨 Common Pitfalls to Avoid

1. **Don't** use StatefulWidget for app-wide state (use Riverpod)
2. **Don't** hardcode API URLs (use AppConfig)
3. **Don't** store tokens in SharedPreferences (use flutter_secure_storage)
4. **Don't** forget to dispose controllers and subscriptions
5. **Don't** block the UI thread (use compute() for heavy tasks)
6. **Don't** ignore null safety
7. **Don't** skip error handling
8. **Don't** forget to add keys to list items

---

## 💡 Pro Tips

1. **Use code generation**: Run `flutter pub run build_runner watch` during development
2. **Hot reload**: Use hot reload (r) for quick UI changes, hot restart (R) for state changes
3. **DevTools**: Use Flutter DevTools to debug performance and inspect state
4. **Logging**: Add meaningful logs for debugging (but remove for production)
5. **Comments**: Add TODO comments for incomplete features
6. **Git**: Commit frequently with clear messages

---

## 🎬 Getting Started

Your first response should be:

1. Confirm you've read all documentation
2. Ask any clarification questions
3. Provide a detailed plan for Phase 1 implementation
4. Start with project setup and core infrastructure

---

## 📞 Remember

**When in doubt, ASK!**

It's better to clarify than to implement incorrectly. Your goal is to build a high-quality, maintainable app that follows best practices and meets all requirements.

Good luck! 🚀