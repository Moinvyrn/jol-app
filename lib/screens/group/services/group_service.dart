// group_service.dart - Complete Group Management Service
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../play/models/room_models.dart';
import '../../play/services/room_service.dart';
import '../models/group_metadata.dart';

class GroupService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final RoomService _roomService = RoomService();

  // =========================================================================
  // GROUP CODE GENERATION
  // =========================================================================

  String _generateGroupCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return 'GRP${List.generate(4, (index) => chars[random.nextInt(chars.length)]).join()}';
  }

  // =========================================================================
  // CREATE GROUP
  // =========================================================================

  Future<String> createGroup({
    required String creatorId,
    required String creatorName,
    required String groupName,
    String? description,
    String? avatarUrl,
  }) async {
    String groupCode;
    bool codeExists = true;

    // Ensure unique code
    do {
      groupCode = _generateGroupCode();
      final snapshot = await _database
          .ref('groups')
          .orderByChild('metadata/code')
          .equalTo(groupCode)
          .get();
      codeExists = snapshot.exists;
    } while (codeExists);

    // Generate unique group ID
    final groupRef = _database.ref('groups').push();
    final groupId = groupRef.key!;

    final groupData = {
      'metadata': {
        'name': groupName,
        'code': groupCode,
        'createdBy': creatorId,
        'createdAt': ServerValue.timestamp,
        'description': description,
        'avatarUrl': avatarUrl,
      },
      'members': {
        creatorId: {
          'name': creatorName,
          'role': 'admin',
          'joinedAt': ServerValue.timestamp,
          'gamesPlayed': 0,
          'wins': 0,
        },
      },
      'stats': {
        'totalGames': 0,
        'totalMembers': 1,
        'lastActivity': ServerValue.timestamp,
      },
      'gameHistory': {},
    };

    await groupRef.set(groupData);
    debugPrint('✅ Group created: $groupId with code $groupCode');
    return groupId;
  }

  // =========================================================================
  // JOIN GROUP BY CODE
  // =========================================================================

  Future<bool> joinGroupByCode({
    required String groupCode,
    required String userId,
    required String userName,
  }) async {
    try {
      // Find group by code
      final snapshot = await _database
          .ref('groups')
          .orderByChild('metadata/code')
          .equalTo(groupCode)
          .get();

      if (!snapshot.exists) {
        debugPrint('❌ Group not found with code: $groupCode');
        return false;
      }

      // Get first matching group
      final groupsMap = snapshot.value as Map;
      final groupId = groupsMap.keys.first;
      final groupData = groupsMap[groupId];

      // Check if already a member
      if (groupData['members'] != null &&
          groupData['members'][userId] != null) {
        debugPrint('⚠️ User already in group');
        return true;
      }

      // Add member
      await _database.ref('groups/$groupId/members/$userId').set({
        'name': userName,
        'role': 'member',
        'joinedAt': ServerValue.timestamp,
        'gamesPlayed': 0,
        'wins': 0,
      });

      // Update stats
      await _database.ref('groups/$groupId/stats').update({
        'totalMembers': ServerValue.increment(1),
        'lastActivity': ServerValue.timestamp,
      });

      debugPrint('✅ User $userId joined group $groupId');
      return true;
    } catch (e) {
      debugPrint('❌ Error joining group: $e');
      return false;
    }
  }

  // =========================================================================
  // JOIN GROUP BY ID (Direct)
  // =========================================================================

  Future<bool> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
  }) async {
    try {
      final groupRef = _database.ref('groups/$groupId');
      final snapshot = await groupRef.get();

      if (!snapshot.exists) {
        debugPrint('❌ Group not found: $groupId');
        return false;
      }

      final groupData = snapshot.value as Map;

      // Check if already a member
      if (groupData['members'] != null &&
          groupData['members'][userId] != null) {
        debugPrint('⚠️ User already in group');
        return true;
      }

      // Add member
      await groupRef.child('members/$userId').set({
        'name': userName,
        'role': 'member',
        'joinedAt': ServerValue.timestamp,
        'gamesPlayed': 0,
        'wins': 0,
      });

      // Update stats
      await groupRef.child('stats').update({
        'totalMembers': ServerValue.increment(1),
        'lastActivity': ServerValue.timestamp,
      });

      debugPrint('✅ User $userId joined group $groupId');
      return true;
    } catch (e) {
      debugPrint('❌ Error joining group: $e');
      return false;
    }
  }

  // =========================================================================
  // BROWSE PUBLIC GROUPS
  // =========================================================================

  Future<List<Group>> browseGroups({int limit = 20}) async {
    try {
      final snapshot = await _database
          .ref('groups')
          .orderByChild('stats/lastActivity')
          .limitToLast(limit)
          .get();

      if (!snapshot.exists) {
        debugPrint('No groups found for browsing');
        return [];
      }

      Map<String, dynamic> groupsMap = _convertToMap(snapshot.value);
      List<Group> groups = _parseGroupsFromMap(groupsMap);

      // Sort by last activity (most recent first)
      groups.sort((a, b) => b.stats.lastActivity.compareTo(a.stats.lastActivity));

      debugPrint('✅ Loaded ${groups.length} groups for browsing');
      return groups;
    } catch (e, stackTrace) {
      debugPrint('❌ Error browsing groups: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  // =========================================================================
  // SEARCH GROUPS BY NAME
  // =========================================================================

  Future<List<Group>> searchGroups(String query) async {
    try {
      final snapshot = await _database.ref('groups').get();

      if (!snapshot.exists) {
        debugPrint('No groups found for search');
        return [];
      }

      Map<String, dynamic> groupsMap = _convertToMap(snapshot.value);
      List<Group> groups = [];

      groupsMap.forEach((key, value) {
        if (value != null && value is Map) {
          try {
            final group = Group.fromJson(key, value);
            if (group.metadata.name.toLowerCase().contains(query.toLowerCase())) {
              groups.add(group);
            }
          } catch (e) {
            debugPrint('❌ Error parsing group $key: $e');
          }
        }
      });

      debugPrint('✅ Found ${groups.length} groups matching "$query"');
      return groups;
    } catch (e, stackTrace) {
      debugPrint('❌ Error searching groups: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  // =========================================================================
  // GET USER'S GROUPS
  // =========================================================================

  Future<List<Group>> getUserGroups(String userId) async {
    try {
      final snapshot = await _database.ref('groups').get();

      if (!snapshot.exists) {
        debugPrint('No groups found in database');
        return [];
      }

      Map<String, dynamic> groupsMap = _convertToMap(snapshot.value);
      List<Group> userGroups = [];

      groupsMap.forEach((key, value) {
        if (value != null && value is Map) {
          try {
            final group = Group.fromJson(key, value);
            if (group.isMember(userId)) {
              userGroups.add(group);
            }
          } catch (e) {
            debugPrint('❌ Error parsing group $key: $e');
          }
        }
      });

      // Sort by last activity
      userGroups.sort((a, b) => b.stats.lastActivity.compareTo(a.stats.lastActivity));

      debugPrint('✅ User $userId is in ${userGroups.length} groups');
      return userGroups;
    } catch (e, stackTrace) {
      debugPrint('❌ Error getting user groups: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  // =========================================================================
  // START GROUP GAME (Creates room with groupId tag)
  // =========================================================================

  Future<String> startGroupGame({
    required String groupId,
    required String hostId,
    required String hostName,
    required RoomSettings settings,
    required PuzzleData puzzle,
  }) async {
    debugPrint('🎮 Starting group game for group: $groupId');

    // Create a normal room using existing RoomService
    final roomCode = await _roomService.createRoom(
      hostId: hostId,
      hostName: hostName,
      settings: settings,
      puzzle: puzzle,
    );

    // Tag the room with groupId
    await _database.ref('rooms/$roomCode').update({
      'groupId': groupId,
    });

    // Update group's last activity
    await _database.ref('groups/$groupId/stats/lastActivity')
        .set(ServerValue.timestamp);

    debugPrint('✅ Room $roomCode created for group $groupId');
    return roomCode;
  }

  // =========================================================================
  // RECORD GAME RESULTS (Call after game ends)
  // =========================================================================

  Future<void> recordGameResults({
    required String groupId,
    required String roomCode,
    required Room room,
  }) async {
    try {
      debugPrint('📊 Recording game results to group $groupId');

      // Extract data from room
      final playerIds = room.players.keys.toList();
      final scores = <String, int>{};
      room.players.forEach((id, player) {
        scores[id] = player.score;
      });

      // Create game record in history
      final gameRef = _database.ref('groups/$groupId/gameHistory').push();
      await gameRef.set({
        'roomCode': roomCode,
        'playerIds': playerIds,
        'scores': scores,
        'winnerId': room.winnerId,
        'timestamp': ServerValue.timestamp,
        'settings': room.settings.toJson(),
      });

      // Update group stats
      await _database.ref('groups/$groupId/stats').update({
        'totalGames': ServerValue.increment(1),
        'lastActivity': ServerValue.timestamp,
      });

      // Update each player's stats
      for (String playerId in playerIds) {
        await _database.ref('groups/$groupId/members/$playerId').update({
          'gamesPlayed': ServerValue.increment(1),
        });
      }

      // Update winner's stats
      if (room.winnerId != null) {
        await _database.ref('groups/$groupId/members/${room.winnerId}').update({
          'wins': ServerValue.increment(1),
        });
      }

      debugPrint('✅ Game results recorded successfully');
    } catch (e) {
      debugPrint('❌ Error recording results: $e');
      rethrow;
    }
  }

  // =========================================================================
  // LEAVE GROUP
  // =========================================================================

  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      final groupRef = _database.ref('groups/$groupId');
      final memberRef = groupRef.child('members/$userId');

      // Check if user is admin
      final memberSnapshot = await memberRef.get();
      if (!memberSnapshot.exists) {
        debugPrint('⚠️ User not in group');
        return;
      }

      final memberData = memberSnapshot.value as Map;
      final isAdmin = memberData['role'] == 'admin';

      // Get member count
      final membersSnapshot = await groupRef.child('members').get();
      final membersMap = membersSnapshot.value as Map;
      final memberCount = membersMap.length;

      if (isAdmin && memberCount > 1) {
        // Transfer admin to another member
        final otherMemberId = membersMap.keys
            .firstWhere((key) => key != userId, orElse: () => null);

        if (otherMemberId != null) {
          await groupRef.child('members/$otherMemberId').update({
            'role': 'admin',
          });
          debugPrint('✅ Admin transferred to $otherMemberId');
        }
      }

      // Remove member
      await memberRef.remove();

      // Update stats
      await groupRef.child('stats').update({
        'totalMembers': ServerValue.increment(-1),
        'lastActivity': ServerValue.timestamp,
      });

      // Delete group if no members left
      if (memberCount == 1) {
        await groupRef.remove();
        debugPrint('✅ Group deleted (no members left)');
      } else {
        debugPrint('✅ User $userId left group $groupId');
      }
    } catch (e) {
      debugPrint('❌ Error leaving group: $e');
    }
  }

  // =========================================================================
  // LISTEN TO GROUP (Real-time updates)
  // =========================================================================

  Stream<Group> listenToGroup(String groupId) {
    return _database.ref('groups/$groupId').onValue.map((event) {
      if (!event.snapshot.exists) {
        throw Exception('Group not found');
      }
      return Group.fromJson(groupId, event.snapshot.value as Map);
    });
  }

  // =========================================================================
  // GET GROUP ID FROM ROOM CODE
  // =========================================================================

  Future<String?> getGroupIdFromRoom(String roomCode) async {
    try {
      final snapshot = await _database.ref('rooms/$roomCode/groupId').get();
      return snapshot.exists ? snapshot.value as String : null;
    } catch (e) {
      debugPrint('❌ Error getting groupId from room: $e');
      return null;
    }
  }

  // =========================================================================
  // CHECK IF GROUP EXISTS BY CODE
  // =========================================================================

  Future<String?> getGroupIdByCode(String code) async {
    try {
      final snapshot = await _database
          .ref('groups')
          .orderByChild('metadata/code')
          .equalTo(code)
          .get();

      if (!snapshot.exists) {
        return null;
      }

      final groupsMap = snapshot.value as Map;
      return groupsMap.keys.first;
    } catch (e) {
      debugPrint('❌ Error finding group by code: $e');
      return null;
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
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

      if (updates.isNotEmpty) {
        await _database.ref('groups/$groupId/metadata').update(updates);
        debugPrint('✅ Group metadata updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating group metadata: $e');
    }
  }

  // =========================================================================
  // HELPER METHODS
  // =========================================================================

  Map<String, dynamic> _convertToMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    } else if (data is List) {
      // Convert List to Map
      final map = <String, dynamic>{};
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          map[i.toString()] = data[i];
        }
      }
      return map;
    }
    return {};
  }

  List<Group> _parseGroupsFromMap(Map<String, dynamic> groupsMap) {
    List<Group> groups = [];
    groupsMap.forEach((key, value) {
      if (value != null && value is Map) {
        try {
          groups.add(Group.fromJson(key, value));
        } catch (e) {
          debugPrint('❌ Error parsing group $key: $e');
        }
      }
    });
    return groups;
  }
}