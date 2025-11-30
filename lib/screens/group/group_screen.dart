import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/group_controller.dart';
import 'group_detail_screen.dart';
import 'models/group_metadata.dart';

class GroupsScreenWrapper extends StatelessWidget {
  final String userId;
  final String userName;

  const GroupsScreenWrapper({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupController(
        userId: userId,
        userName: userName,
      ),
      child: GroupsScreen(),
    );
  }
}

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);
  static const Color textOrange = Color(0xFFfc6839);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GroupController>();
      controller.loadMyGroups();
      controller.loadBrowseGroups();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC0CB),
              Color(0xFFADD8E6),
              Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Compact Title Section
                        Text(
                          "MANAGE GROUPS",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Compact Header Action Buttons
                        _buildCompactHeaderButton(
                          context,
                          title: "JOIN BY CODE",
                          icon: Icons.code_rounded,
                          color: textBlue,
                          onTap: () => _showJoinByCodeDialog(context),
                        ),
                        const SizedBox(height: 10),

                        _buildCompactHeaderButton(
                          context,
                          title: "CREATE GROUP",
                          icon: Icons.add_circle_outline,
                          color: textPink,
                          onTap: () => _showCreateGroupDialog(context),
                        ),

                        const SizedBox(height: 20),

                        // Compact Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "YOUR GROUPS",
                                style: TextStyle(
                                  fontFamily: 'Digitalt',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // My Groups Content
                        _buildMyGroupsContent(),

                        const SizedBox(height: 20),

                        // Compact Divider for Browse
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "BROWSE GROUPS",
                                style: TextStyle(
                                  fontFamily: 'Digitalt',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Browse Content
                        _buildBrowseContent(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyGroupsContent() {
    return Consumer<GroupController>(
      builder: (context, controller, _) {
        if (controller.isLoadingMyGroups) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: textPink),
            ),
          );
        }
        if (controller.myGroups.isEmpty) {
          return _buildEmptyState(
            icon: Icons.group_outlined,
            title: "NO GROUPS YET",
            subtitle: "Create or join a group to get started!",
          );
        }
        return Column(
          children: [
            // Compact Header
            Row(
              children: [
                Text(
                  "GROUPS: ${controller.myGroups.length.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontFamily: 'Digitalt',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Compact List
            ...controller.myGroups.map((group) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCompactMyGroupCard(
                context,
                group: group,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: controller,
                        child: GroupDetailScreen(
                          groupId: group.metadata.id,
                        ),
                      ),
                    ),
                  );
                  if (mounted) {
                    controller.loadMyGroups();
                    controller.loadBrowseGroups();
                  }
                },
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildBrowseContent() {
    return Consumer<GroupController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.white.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          controller.loadBrowseGroups();
                        } else {
                          controller.searchGroups(value);
                        }
                      },
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: "SEARCH GROUPS...",
                        hintStyle: TextStyle(
                          fontFamily: 'Digitalt',
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Results
            if (controller.isLoadingBrowse)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: textOrange),
                ),
              )
            else if (controller.browseGroups.isEmpty)
              _buildEmptyState(
                icon: Icons.search_off,
                title: "NO GROUPS FOUND",
                subtitle: "Try a different search term",
              )
            else
              ...controller.browseGroups.map((group) {
                final isMember = group.isMember(context.read<GroupController>().userId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildCompactBrowseGroupCard(
                    context,
                    group: group,
                    isMember: isMember,
                    onJoin: () async {
                      final success = await controller.joinGroup(group.metadata.id);
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Joined group!'),
                            backgroundColor: textGreen,
                          ),
                        );
                      }
                    },
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: controller,
                            child: GroupDetailScreen(
                              groupId: group.metadata.id,
                            ),
                          ),
                        ),
                      );
                      if (mounted) {
                        controller.loadMyGroups();
                        controller.loadBrowseGroups();
                      }
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  // Empty State Widget
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Compact Header Button (adapted from multiplayer button)
  Widget _buildCompactHeaderButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // Compact My Group Card (similar to grid card)
  Widget _buildCompactMyGroupCard(
      BuildContext context, {
        required Group group,
        required VoidCallback onTap,
      }) {
    final controller = context.read<GroupController>();
    final isAdmin = group.isAdmin(controller.userId);
    final color = isAdmin ? textOrange : textGreen;
    final statusText = isAdmin ? "ADMIN" : "MEMBER";
    final statusColor = isAdmin ? textOrange : textGreen;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Compact Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.group,
                size: 28,
                color: textPink,
              ),
            ),
            const SizedBox(width: 12),

            // Compact Text
            Expanded(
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.metadata.name,
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${group.memberCount} MEM",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "GAMES: ${group.stats.totalGames}",
                            style: const TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: textOrange,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "CODE: ${group.metadata.code}",
                            style: const TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: textOrange,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusText,
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact Browse Group Card (similar to grid card)
  Widget _buildCompactBrowseGroupCard(
      BuildContext context, {
        required Group group,
        required bool isMember,
        required VoidCallback onJoin,
        required VoidCallback onTap,
      }) {
    final color = textPink;

    return InkWell(
      onTap: isMember ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Compact Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.group,
                size: 28,
                color: textPink,
              ),
            ),
            const SizedBox(width: 12),

            // Compact Text
            Expanded(
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.metadata.name,
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${group.memberCount} MEM • ${group.stats.totalGames} GAMES",
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: textOrange,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Join Button or Joined Badge
            if (isMember)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: textGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "JOINED",
                  style: TextStyle(
                    fontFamily: 'Digitalt',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: onJoin,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: textPink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "JOIN",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Create Group Dialog
  Future<void> _showCreateGroupDialog(BuildContext dialogContext) async {
    final controller = context.read<GroupController>();
    final result = await showDialog<Map<String, String>?>(
      context: dialogContext,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: CreateGroupDialogContent(
            onCreate: (name, description) {
              Navigator.pop(context, {'name': name, 'description': description});
            },
          ),
        ),
      ),
    );
    if (result != null && mounted) {
      final groupId = await controller.createGroup(
        groupName: result['name']!,
        description: result['description'],
      );
      if (groupId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group created!'),
            backgroundColor: textGreen,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: controller,
              child: GroupDetailScreen(groupId: groupId),
            ),
          ),
        );
      }
    }
  }

  // Join by Code Dialog
  Future<void> _showJoinByCodeDialog(BuildContext dialogContext) async {
    final controller = context.read<GroupController>();
    final code = await showDialog<String?>(
      context: dialogContext,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: JoinByCodeDialogContent(
            onJoin: (code) {
              Navigator.pop(context, code);
            },
          ),
        ),
      ),
    );
    if (code != null && mounted) {
      final success = await controller.joinGroupByCode(code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Joined group!' : 'Group not found'),
            backgroundColor: success ? textGreen : Colors.red,
          ),
        );
      }
    }
  }
}

// ============================================
// CREATE GROUP DIALOG CONTENT
// ============================================
class CreateGroupDialogContent extends StatefulWidget {
  final Function(String, String?) onCreate;

  const CreateGroupDialogContent({
    super.key,
    required this.onCreate,
  });

  @override
  State<CreateGroupDialogContent> createState() => _CreateGroupDialogContentState();
}

class _CreateGroupDialogContentState extends State<CreateGroupDialogContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  static const Color textPink = Color(0xFFF82A87);
  static const Color textOrange = Color(0xFFfc6839);
  static const Color textPurple = Color(0xFFC42AF8);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CREATE GROUP",
              style: TextStyle(
                fontFamily: "Digitalt",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textOrange,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Group Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Group Name",
                labelStyle: const TextStyle(
                  fontFamily: 'Rubik',
                  color: textPink,
                ),
                hintText: "e.g., Math Warriors",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: textPink, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),

            // Description (Optional)
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description (Optional)",
                labelStyle: const TextStyle(
                  fontFamily: 'Rubik',
                  color: textPink,
                ),
                hintText: "Tell members what this group is about...",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: textPink, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: textPink, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textPink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a group name'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final description = _descController.text.trim().isEmpty ? null : _descController.text.trim();
                      widget.onCreate(name, description);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPurple,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "CREATE",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: -40,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.group_add,
              size: 32,
              color: textOrange,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

// ============================================
// JOIN BY CODE DIALOG CONTENT
// ============================================
class JoinByCodeDialogContent extends StatefulWidget {
  final Function(String) onJoin;

  const JoinByCodeDialogContent({
    super.key,
    required this.onJoin,
  });

  @override
  State<JoinByCodeDialogContent> createState() => _JoinByCodeDialogContentState();
}

class _JoinByCodeDialogContentState extends State<JoinByCodeDialogContent> {
  final TextEditingController _codeController = TextEditingController();

  static const Color textPink = Color(0xFFF82A87);
  static const Color textOrange = Color(0xFFfc6839);
  static const Color textPurple = Color(0xFFC42AF8);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "JOIN BY CODE",
              style: TextStyle(
                fontFamily: "Digitalt",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textOrange,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: "Enter group code (e.g., GRPABC1)",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: textPink, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(
                fontFamily: 'Digitalt',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: textPink, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textPink,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final code = _codeController.text.trim().toUpperCase();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a group code'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      widget.onJoin(code);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPurple,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "JOIN",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: -40,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.code,
              size: 32,
              color: textOrange,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}