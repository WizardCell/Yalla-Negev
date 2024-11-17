import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yalla_negev/utils/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/users/user_data.dart';

enum UsersManagerProviderState { notLoaded, loading, loaded, error }

class UsersManagerProvider extends ChangeNotifier {
  UsersManagerProvider() {
    listenToUsers();
  }

  List<UserData> _users = [];
  List<UserData> _filteredUsers = [];
  UsersManagerProviderState _state = UsersManagerProviderState.notLoaded;

  Set<UserRole> _selectedRoles = {};
  String _searchQuery = '';

  List<UserData> get users => _filteredUsers;
  UsersManagerProviderState get state => _state;

  StreamSubscription<QuerySnapshot>? _usersStreamSubscription;

  void listenToUsers() {
    _state = UsersManagerProviderState.loading;
    notifyListeners();

    _usersStreamSubscription = usersCollection.snapshots().listen(
          (QuerySnapshot snapshot) {
        _users = snapshot.docs
            .map(
              (doc) => UserData.fromFirebaseObject(
              doc.data() as Map<String, dynamic>, doc.id),
        )
            .toList();
        _filteredUsers = List.from(_users);
        _state = UsersManagerProviderState.loaded;
        print("Users fetched: ${_users.length}");
        notifyListeners();
      },
      onError: (e) {
        _state = UsersManagerProviderState.error;
        print('Error fetching users: $e');
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _usersStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> getAllUsers() async {
    try {
      _state = UsersManagerProviderState.loading;
      notifyListeners();

      QuerySnapshot snapshot = await usersCollection.get();
      _users = snapshot.docs
          .map(
            (doc) => UserData.fromFirebaseObject(
            doc.data() as Map<String, dynamic>, doc.id),
      )
          .toList();
      _filteredUsers = List.from(_users);
      _state = UsersManagerProviderState.loaded;
      print("Users fetched: ${_users.length}");
      notifyListeners();
    } catch (e) {
      _state = UsersManagerProviderState.error;
      print('Error fetching users: $e');
      notifyListeners();
    }
  }

  void searchUsers(String query) {
    filterUsers(query: query);
  }

  void filterUsers({String? query, Set<UserRole>? roles}) {
    if (query != null) {
      _searchQuery = query;
    }
    if (roles != null) {
      _selectedRoles = roles;
    }

    _filteredUsers = _users.where((user) {
      final matchesRole = _selectedRoles.isEmpty || _selectedRoles.contains(user.role);
      final matchesQuery = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesRole && matchesQuery;
    }).toList();

    notifyListeners();
  }

  void toggleRoleSelection(UserRole role) {
    if (_selectedRoles.contains(role)) {
      _selectedRoles.remove(role);
    } else {
      _selectedRoles.add(role);
    }
    notifyListeners();
  }

  bool isRoleSelected(UserRole role) {
    return _selectedRoles.contains(role);
  }

  void applyRoleFilter() {
    filterUsers(roles: _selectedRoles);
  }

  void clearFilters() {
    _selectedRoles.clear();
    _searchQuery = '';
    _filteredUsers = List.from(_users);
    notifyListeners();
  }

  Future<void> changeRole(String uid, UserRole role) async {
    try {
      await usersCollection.doc(uid).update({'role': role.index});
      await getAllUsers();
      notifyListeners();
    } catch (e) {
      print('Error changing role: $e');
    }
  }
}
