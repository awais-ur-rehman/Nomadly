import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/discovery_provider.dart';

// Create a simple provider for search
final searchUsersProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  if (query.isEmpty) return [];
  // We need to access UserRepository or similar.
  // Assuming DiscoveryRepository has search or we add it. 
  // The APP_DEVELOPER_GUIDE says `GET /api/v1/users/search`.
  // I will check DiscoveryRepository again or use ApiClient directly here for brevity/speed or update Repo.
  // Ideally update Repo.
  return [];
});

class SearchUsersScreen extends ConsumerStatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  ConsumerState<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends ConsumerState<SearchUsersScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    
    // Quick Hack: Access API via AuthRepository's client or a new Service. 
    // Best practice: Add `searchUsers` to `DiscoveryRepository` or `UserRepository`.
    // I will presume I'll update DiscoveryRepository or specialized UserRepository.
    // For now, let's use a temporary method or mock until I update the repo in next step.
    
    try {
      final usersJson = await ref.read(discoveryRepositoryProvider).searchUsers(query);
      // Map JSON to User objects if needed, but the UI expects user['username'] etc.
      setState(() => _results = usersJson);
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          style: const TextStyle(color: Colors.black),
          onSubmitted: _performSearch,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('Search for nomads by name or username'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final user = _results[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['profile']['photo_url'] ?? ''),
                      ),
                      title: Text(user['username']),
                      subtitle: Text(user['profile']['name'] ?? ''),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Follow Logic
                        },
                        child: const Text('Follow'),
                      ),
                      onTap: () => context.push('/profile/${user['_id']}', extra: user),
                    );
                  },
                ),
    );
  }
}
