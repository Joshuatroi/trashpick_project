import 'package:flutter/material.dart';

// Data models for the schedules
class ActiveSchedule {
  final String name;
  final String location;
  final String wasteType;
  final String timePeriod;

  ActiveSchedule({required this.name, required this.location, required this.wasteType, required this.timePeriod});
}

class OldSchedule {
  final String name;
  final String location;
  final String wasteType;
  final String timePeriod;

  OldSchedule({required this.name, required this.location, required this.wasteType, required this.timePeriod});
}

class OfficialSchedule extends StatefulWidget {
  const OfficialSchedule({super.key});

  @override
  State<OfficialSchedule> createState() => _OfficialScheduleState();
}

class _OfficialScheduleState extends State<OfficialSchedule> {
  // Dummy Data
  final List<ActiveSchedule> _activeSchedules = [
    ActiveSchedule(name: 'North District Residential', location: 'Sunshine Road, Elm Street', wasteType: 'Biodegradable', timePeriod: '6 AM - 10 AM'),
    ActiveSchedule(name: 'Downtown Commercial', location: 'Main Avenue, Central Plaza', wasteType: 'Recyclable', timePeriod: '8 AM - 12 PM'),
    ActiveSchedule(name: 'West Suburbs', location: 'Oakwood Drive, Willow Creek', wasteType: 'All Types', timePeriod: '7 AM - 11 AM'),
  ];

  final List<OldSchedule> _oldSchedules = [
    OldSchedule(name: 'Holiday Special Schedule', location: 'City-wide', wasteType: 'All Types', timePeriod: '9 AM - 1 PM'),
    OldSchedule(name: 'Summer Festival Schedule', location: 'Beachfront area', wasteType: 'Recyclable', timePeriod: '10 AM - 2 PM'),
  ];

  bool _isCreatingSchedule = false;
  final Color primaryGreen = const Color(0xFF00A651);

  void _toggleCreateScheduleForm() {
    setState(() {
      _isCreatingSchedule = !_isCreatingSchedule;
    });
  }

  void _showOldScheduleDetails(OldSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(schedule.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [const TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: schedule.location)])),
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [const TextSpan(text: 'Waste Type: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: schedule.wasteType)])),
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [const TextSpan(text: 'Time Period: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: schedule.timePeriod)])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () { /* TODO: Handle Use Schedule */ },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
              child: const Text('Use Schedule'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Active Schedules Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Schedules',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _toggleCreateScheduleForm,
                child: Text(
                  _isCreatingSchedule ? 'Cancel' : '+ Create Schedule',
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Conditionally show the create schedule form
          if (_isCreatingSchedule) _buildCreateScheduleForm(),

          // Active Schedules List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeSchedules.length,
            itemBuilder: (context, index) {
              final schedule = _activeSchedules[index];
              return _buildActiveScheduleCard(schedule);
            },
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // Old Schedules Section
          const Text(
            'Old Schedules',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _oldSchedules.length,
            itemBuilder: (context, index) {
              final schedule = _oldSchedules[index];
              return _buildOldScheduleCard(schedule);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateScheduleForm() {
    return Card(
      color: primaryGreen.withAlpha(26),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Schedule Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Schedule Name', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Location (e.g., Street Names)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Waste Type (e.g., Recyclable)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Time Period (e.g., 6 AM - 10 AM)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('Save Schedule'), style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActiveScheduleCard(ActiveSchedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    schedule.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.schedule_outlined, color: Colors.blueAccent),
                  onPressed: () { /* TODO: Handle map/schedule click */ },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Location: ${schedule.location}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Collection: ${schedule.wasteType}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('Time: ${schedule.timePeriod}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () { /* TODO: Handle Edit */ },
                  child: Text('Edit', style: TextStyle(color: primaryGreen)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () { /* TODO: Handle Delete */ },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOldScheduleCard(OldSchedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(schedule.name),
        onTap: () => _showOldScheduleDetails(schedule),
        trailing: const Icon(Icons.info_outline, color: Colors.grey),
      ),
    );
  }
}
