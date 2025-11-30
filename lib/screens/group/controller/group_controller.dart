// group_controller.dart - Complete Group Management Controller
import 'dart:async';
import 'package:flutter/material.dart';
import '../../play/models/room_models.dart';
import '../models/group_metadata.dart';
import '../services/group_service.dart';

class GroupController extends ChangeNotifier {
  final GroupService _groupService = GroupService();
  final String userId;
  final String userName;

  // State
  List<Group> _myGroups = [];
  List<Group> _browseGroups = [];
  Group? _currentGroup;
  StreamSubscription? _groupSubscription;

  bool _isLoadingMyGroups = false;
  bool _isLoadingBrowse = false;
  String? _error;

  GroupController({
    required this.userId,
    required this.userName,
  }) {
    loadMyGroups();
  }

  // =========================================================================
  // GETTERS
  // =========================================================================

  List<Group> get myGroups => _myGroups;
  List<Group> get browseGroups => _browseGroups;
  Group? get currentGroup => _currentGroup;
  bool get isLoadingMyGroups => _isLoadingMyGroups;
  bool get isLoadingBrowse => _isLoadingBrowse;
  String? get error => _error;

  bool isCurrentUserAdmin() {
    if (_currentGroup == null) return false;
    return _currentGroup!.isAdmin(userId);
  }

  bool isCurrentUserMember() {
    if (_currentGroup == null) return false;
    return _currentGroup!.isMember(userId);
  }

  // =========================================================================
  // LOAD USER'S GROUPS
  // =========================================================================

  Future<void> loadMyGroups() async {
    _isLoadingMyGroups = true;
    _error = null;
    notifyListeners();

    try {
      _myGroups = await _groupService.getUserGroups(userId);
      _isLoadingMyGroups = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load groups: $e';
      _isLoadingMyGroups = false;
      notifyListeners();
    }
  }

  // =========================================================================
  // BROWSE PUBLIC GROUPS
  // =========================================================================

  Future<void> loadBrowseGroups({int limit = 20}) async {
    _isLoadingBrowse = true;
    _error = null;
    notifyListeners();

    try {
      _browseGroups = await _groupService.browseGroups(limit: limit);
      _isLoadingBrowse = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to browse groups: $e';
      _isLoadingBrowse = false;
      notifyListeners();
    }
  }

  // =========================================================================
  // SEARCH GROUPS
  // =========================================================================

  Future<void> searchGroups(String query) async {
    if (query.isEmpty) {
      await loadBrowseGroups();
      return;
    }

    _isLoadingBrowse = true;
    _error = null;
    notifyListeners();

    try {
      _browseGroups = await _groupService.searchGroups(query);
      _isLoadingBrowse = false;
      notifyListeners();
    } catch (e) {
      _error = 'Search failed: $e';
      _isLoadingBrowse = false;
      notifyListeners();
    }
  }

  // =========================================================================
  // CREATE NEW GROUP
  // =========================================================================

  Future<String?> createGroup({
    required String groupName,
    String? description,
    String? avatarUrl,
  }) async {
    try {
      final groupId = await _groupService.createGroup(
        creatorId: userId,
        creatorName: userName,
        groupName: groupName,
        description: description,
        avatarUrl: avatarUrl,
      );

      await loadMyGroups();
      return groupId;
    } catch (e) {
      _error = 'Failed to create group: $e';
      notifyListeners();
      return null;
    }
  }

  // =========================================================================
  // JOIN GROUP BY CODE
  // =========================================================================

  Future<bool> joinGroupByCode(String code) async {
    try {
      final success = await _groupService.joinGroupByCode(
        groupCode: code.toUpperCase(),
        userId: userId,
        userName: userName,
      );

      if (success) {
        await loadMyGroups();
      }

      return success;
    } catch (e) {
      _error = 'Failed to join group: $e';
      notifyListeners();
      return false;
    }
  }

  // =========================================================================
  // JOIN GROUP BY ID
  // =========================================================================

  Future<bool> joinGroup(String groupId) async {
    try {
      final success = await _groupService.joinGroup(
        groupId: groupId,
        userId: userId,
        userName: userName,
      );

      if (success) {
        await loadMyGroups();
      }

      return success;
    } catch (e) {
      _error = 'Failed to join group: $e';
      notifyListeners();
      return false;
    }
  }

  // =========================================================================
  // START LISTENING TO A SPECIFIC GROUP
  // =========================================================================

  void listenToGroup(String groupId) {
    _groupSubscription?.cancel();
    _groupSubscription = _groupService.listenToGroup(groupId).listen(
          (group) {
        _currentGroup = group;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Group listener error: $e';
        notifyListeners();
      },
    );
  }

  // =========================================================================
  // STOP LISTENING TO CURRENT GROUP
  // =========================================================================

  void stopListeningToGroup() {
    _groupSubscription?.cancel();
    _currentGroup = null;
    notifyListeners();
  }

  // =========================================================================
  // START GAME FROM GROUP
  // =========================================================================

  Future<String?> startGroupGame({
    required RoomSettings settings,
    required PuzzleData puzzle,
  }) async {
    if (_currentGroup == null) {
      _error = 'No group selected';
      notifyListeners();
      return null;
    }

    try {
      final roomCode = await _groupService.startGroupGame(
        groupId: _currentGroup!.metadata.id,
        hostId: userId,
        hostName: userName,
        settings: settings,
        puzzle: puzzle,
      );

      return roomCode;
    } catch (e) {
      _error = 'Failed to start game: $e';
      notifyListeners();
      return null;
    }
  }

  // =========================================================================
  // RECORD GAME RESULT (Call after game ends)
  // =========================================================================

  Future<void> recordGameResult({
    required String groupId,
    required String roomCode,
    required Room room,
  }) async {
    try {
      await _groupService.recordGameResults(
        groupId: groupId,
        roomCode: roomCode,
        room: room,
      );

      // Refresh current group if viewing it
      if (_currentGroup?.metadata.id == groupId) {
        // Group will auto-update via listener
      }
    } catch (e) {
      _error = 'Failed to record result: $e';
      notifyListeners();
    }
  }

  // =========================================================================
  // LEAVE GROUP
  // =========================================================================

  Future<void> leaveGroup(String groupId) async {
    try {
      await _groupService.leaveGroup(groupId, userId);
      await loadMyGroups();

      if (_currentGroup?.metadata.id == groupId) {
        stopListeningToGroup();
      }
    } catch (e) {
      _error = 'Failed to leave group: $e';
      notifyListeners();
    }
  }

  // =========================================================================
  // UPDATE GROUP METADATA (Admin only)
  // =========================================================================

  Future<void> updateGroupMetadata({
    required String groupId,
    String? name,
    String? description,
    String? avatarUrl,
  }) async {
    try {
      await _groupService.updateGroupMetadata(
        groupId: groupId,
        name: name,
        description: description,
        avatarUrl: avatarUrl,
      );
    } catch (e) {
      _error = 'Failed to update group: $e';
      notifyListeners();
    }
  }

  // =========================================================================
  // GET LEADERBOARD FOR CURRENT GROUP
  // =========================================================================

  List<GroupMember> getLeaderboard() {
    if (_currentGroup == null) return [];
    return _currentGroup!.sortedMembersByWins;
  }

  // =========================================================================
  // GET RECENT GAMES FOR CURRENT GROUP
  // =========================================================================

  List<GameRecord> getRecentGames({int limit = 10}) {
    if (_currentGroup == null) return [];
    final games = _currentGroup!.sortedGameHistory;
    return games.take(limit).toList();
  }

  // =========================================================================
  // CLEAR ERROR
  // =========================================================================

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================

  @override
  void dispose() {
    _groupSubscription?.cancel();
    super.dispose();
  }
}