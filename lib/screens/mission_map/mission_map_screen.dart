import 'package:flutter/material.dart';
import '../../models/mission_model.dart';
import '../../services/mission_service.dart';

class MissionMapScreen extends StatefulWidget {
  final String username;
  final String mode;

  const MissionMapScreen({
    super.key,
    required this.username,
    required this.mode,
  });

  @override
  State<MissionMapScreen> createState() => _MissionMapScreenState();
}

class _MissionMapScreenState extends State<MissionMapScreen> {
  late Future<List<Mission>> missions;

  @override
  void initState() {
    super.initState();
    missions = MissionService.loadMissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF9),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text("Peta Misi - ${widget.username}"),
      ),
      body: FutureBuilder<List<Mission>>(
        future: missions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada misi aktif"));
          }

          final missions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade300,
                    child: Text(mission.id.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(mission.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text("Tipe: ${mission.type}"),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Misi '${mission.title}' (${mission.type}) dimulai!"),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
