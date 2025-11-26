import 'package:flutter/material.dart';

import '../dashboard/notification_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../settings/account_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  static const Color textPink = Color(0xFFF82A87);
  static const Color textOrange = Color(0xFFfc6839);
  static const Color textGreen = Color(0xFF4CAF50);

  final List<Map<String, dynamic>> groups = [
    {
      "name": "YOUTH GROUP",
      "members": 24,
      "created": "2 MONTHS AGO",
      "games": 21,
    },
    {
      "name": "GAME BREAKERS",
      "members": 11,
      "created": "2 MONTHS AGO",
      "games": 21,
    },
    {
      "name": "BROKEN GAMERS",
      "members": 92,
      "created": "2 MONTHS AGO",
      "games": 21,
    },
    {
      "name": "WINNERS SQUAD",
      "members": 124,
      "created": "2 MONTHS AGO",
      "games": 21,
    },
  ];

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 📌 App Bar
              _buildAppBar(context),

              // 📋 Groups Container
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: textPink.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      // 🔝 Header Row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "GROUPS: ${groups.length.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontFamily: 'Digitalt',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final newGroupName = await showDialog<String>(
                                  context: context,
                                  builder: (context) => const CreateNewGroup(),
                                );

                                if (newGroupName != null && newGroupName.isNotEmpty) {
                                  setState(() {
                                    groups.add({
                                      "name": newGroupName,
                                      "members": 1, // default
                                      "created": "JUST NOW",
                                      "games": 0,
                                    });
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: textOrange,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(Icons.add,
                                            size: 16, color: Colors.black),
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: const Text(
                                          "CREATE NEW GROUP",
                                          style: TextStyle(
                                            fontFamily: 'Digitalt',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 📋 Groups List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final group = groups[index];
                            return GroupCard(
                              name: group["name"],
                              members: group["members"],
                              created: group["created"],
                              games: group["games"],
                              onDelete: () {
                                setState(() => groups.removeAt(index));
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // 🔠 JOL logo builder
  Widget _buildJolLogo() {
    const letters = ["J", "O", "L"];
    const colors = [Color(0xFFf8bc64), textPink, Color(0xFFfc6839)];

    return Row(
      children: List.generate(
        letters.length,
            (index) => Text(
          letters[index],
          style: const TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w500,
            fontSize: 35,
            height: 0.82,
          ).copyWith(
            color: colors[index],
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 12,
        right: 12,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildJolLogo(),
          Row(
            children: [
              // ✅ HOW TO PLAY (pill button)
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const HelpDialog(),
                  );
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: textGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.9), width: 2.5),
                  ),
                  child: const Text(
                    "HOW TO PLAY",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 🔔 Notification Bell
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationScreen()), // Replace with NotificationScreen()
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    size: 20,
                    color: textPink,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 💰 Coins
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: textPink,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    // Circle with "J"
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "J",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPink,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "5M",
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 👤 Profile Avatar
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const AccountScreen(),),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                  AssetImage("lib/assets/images/settings_emoji.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🎴 Group Card Widget
class GroupCard extends StatelessWidget {
  final String name;
  final int members;
  final String created;
  final int games;
  final VoidCallback onDelete;

  const GroupCard({
    super.key,
    required this.name,
    required this.members,
    required this.created,
    required this.games,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷 Group Name + Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF82A87),
                ),
              ),
              InkWell(
                onTap: onDelete,
                child: const Icon(
                  Icons.delete_outline_outlined,
                  color: Color(0xFFF82A87),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "$members Members",
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 12,
              color: _GroupsScreenState.textPink,
            ),
          ),

          Divider(thickness: 0.1, color: Colors.grey),
          // 📌 Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CREATED $created",
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfc6839),
                ),
              ),
              Text(
                "GAMES PLAYED: $games",
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfc6839),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class CreateNewGroup extends StatefulWidget {
  const CreateNewGroup({super.key});

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  final TextEditingController _nameController = TextEditingController();

  static const Color textPink = Color(0xFFC42AF8);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create a new group",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfc6839),
                    ),
                  ),
                  const SizedBox(height: 12),
        
                  // 📝 TextField for group name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter group name",
                      hintStyle: const TextStyle(
                        color: Color(0xFFF82A87),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                      // 👇 Default border (very grey)
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey, // light grey border
                          width: 0.5,
                        ),
                      ),

                      // 👇 Focused border (pink when clicked)
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFF82A87), // pink border
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        Navigator.pop(context, name); // return the name
                      }
                    },
                    child: const Text(
                      "Create Group",
                      style: TextStyle(
                        fontFamily: "Digitalt",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -40,
              child: Image.asset(
                'lib/assets/images/settings_emoji.png',
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

