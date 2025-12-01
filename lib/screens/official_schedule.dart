import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// DATA MODELS
class ActiveSchedule {
  final String id;
  final String name;
  final String location;
  final String wasteType;
  final DateTime date;
  final String timePeriod;

  ActiveSchedule({
    required this.id,
    required this.name,
    required this.location,
    required this.wasteType,
    required this.date,
    required this.timePeriod,
  });
}

class OldSchedule {
  final String id;
  final String name;
  final String location;
  final String wasteType;
  final DateTime date;
  final String timePeriod;

  OldSchedule({
    required this.id,
    required this.name,
    required this.location,
    required this.wasteType,
    required this.date,
    required this.timePeriod,
  });
}

// SERVICE
class ScheduleService {
  Future<void> deleteSchedule(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> createSchedule(ActiveSchedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> updateSchedule(ActiveSchedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> activateOldSchedule(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class OfficialSchedule extends StatefulWidget {
  const OfficialSchedule({super.key});

  @override
  State<OfficialSchedule> createState() => _OfficialScheduleState();
}

class _OfficialScheduleState extends State<OfficialSchedule> {
  final ScheduleService _scheduleService = ScheduleService();
  final Color primaryGreen = const Color(0xFF00A651);

  // FORM CONTROLLERS
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wasteTypeController = TextEditingController();
  final TextEditingController _timePeriodController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  final List<String> labangonStreets = [
    'B. Zubiri Street',
    'Bliss Road',
    'Mariano M. Abella Street',
    'Pedro Q. Cabaluna Street',
    'Katipunan Street',
    'E. Jabonero Street',
    'Osmeña Drive',
    'Salvador Street',
    'Tres de Abril Street',
    'La Tresas Street',
    'Natalio Bacalso Avenue',
  ];

  String? _selectedStreet;

  // DUMMY DATA
  List<ActiveSchedule> _activeSchedules = [
    ActiveSchedule(
      id: '1',
      name: 'North District Residential',
      location: 'Sunshine Road, Elm Street',
      wasteType: 'Biodegradable',
      date: DateTime(2025, 1, 10),
      timePeriod: '6 AM - 10 AM',
    ),
    ActiveSchedule(
      id: '2',
      name: 'Downtown Commercial',
      location: 'Main Avenue, Central Plaza',
      wasteType: 'Recyclable',
      date: DateTime(2025, 1, 12),
      timePeriod: '8 AM - 12 PM',
    ),
    ActiveSchedule(
      id: '3',
      name: 'West Suburbs',
      location: 'Oakwood Drive, Willow Creek',
      wasteType: 'All Types',
      date: DateTime(2025, 1, 15),
      timePeriod: '7 AM - 11 AM',
    ),
  ];

  List<OldSchedule> _oldSchedules = [
    OldSchedule(
      id: 'old1',
      name: 'Holiday Special Schedule',
      location: 'City-wide',
      wasteType: 'All Types',
      date: DateTime(2024, 12, 25),
      timePeriod: '9 AM - 1 PM',
    ),
    OldSchedule(
      id: 'old2',
      name: 'Summer Festival Schedule',
      location: 'Beachfront area',
      wasteType: 'Recyclable',
      date: DateTime(2024, 6, 10),
      timePeriod: '10 AM - 2 PM',
    ),
  ];

  bool _isCreatingSchedule = false;

  @override
  void dispose() {
    _nameController.dispose();
    _wasteTypeController.dispose();
    _dateController.dispose();
    _timePeriodController.dispose();
    super.dispose();
  }

  void _toggleCreateScheduleForm() {
    setState(() {
      _isCreatingSchedule = !_isCreatingSchedule;
      if (!_isCreatingSchedule) _clearForm();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _selectedStreet = null;
    _wasteTypeController.clear();
    _timePeriodController.clear();
    _dateController.clear();
    _selectedDate = null;
  }

  Future<void> _saveSchedule() async {
    if (_nameController.text.isEmpty ||
        _selectedStreet == null ||
        _wasteTypeController.text.isEmpty ||
        _timePeriodController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final newSchedule = ActiveSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      location: _selectedStreet!,
      wasteType: _wasteTypeController.text,
      date: _selectedDate!,
      timePeriod: _timePeriodController.text,
    );

    await _scheduleService.createSchedule(newSchedule);

    setState(() {
      _activeSchedules.add(newSchedule);
      _isCreatingSchedule = false;
    });

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule created successfully')),
    );
  }

  void _showOldScheduleDetails(OldSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${schedule.location}"),
            Text("Waste Type: ${schedule.wasteType}"),
            Text("Time Period: ${schedule.timePeriod}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Use Schedule'),
            onPressed: () async {
              await _scheduleService.activateOldSchedule(schedule.id);

              final newActive = ActiveSchedule(
                id: schedule.id,
                name: schedule.name,
                location: schedule.location,
                wasteType: schedule.wasteType,
                date: schedule.date,
                timePeriod: schedule.timePeriod,
              );

              setState(() {
                _activeSchedules.add(newActive);
                _oldSchedules.removeWhere((s) => s.id == schedule.id);
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (_isCreatingSchedule) _buildCreateScheduleForm(),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeSchedules.length,
            itemBuilder: (context, i) =>
                _buildActiveScheduleCard(_activeSchedules[i]),
          ),

          const Divider(height: 40),

          const Text(
            'Old Schedules',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _oldSchedules.length,
            itemBuilder: (context, i) =>
                _buildOldScheduleCard(_oldSchedules[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateScheduleForm() {
    return Card(
      color: primaryGreen.withAlpha(26),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'New Schedule Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Schedule Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStreet,
              items: labangonStreets
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStreet = v),
              decoration: const InputDecoration(
                labelText: 'Location(streets)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _wasteTypeController.text.isEmpty
                  ? null
                  : _wasteTypeController.text,
              decoration: const InputDecoration(
                labelText: 'Waste Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Biodegradable',
                  child: Text('Biodegradable'),
                ),
                DropdownMenuItem(
                  value: 'Recyclable',
                  child: Text('Recyclable'),
                ),
                DropdownMenuItem(value: 'Residual', child: Text('Residual')),
                DropdownMenuItem(value: 'All Types', child: Text('All Types')),
              ],
              onChanged: (value) {
                setState(() {
                  _wasteTypeController.text = value!;
                });
              },
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Collection Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  });
                }
              },
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _timePeriodController,
              decoration: const InputDecoration(
                labelText: 'Time Period (e.g., 6 AM - 10 AM)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveSchedule,
                child: const Text('Save Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveScheduleCard(ActiveSchedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.schedule_outlined,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              "Location: ${schedule.location}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text("Collection: ${schedule.wasteType}"),
            const SizedBox(height: 4),
            Text("Date: ${DateFormat('yyyy-MM-dd').format(schedule.date)}"),
            const SizedBox(height: 4),
            Text("Time: ${schedule.timePeriod}"),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ==================== EDIT BUTTON ====================
                TextButton(
                  child: Text('Edit', style: TextStyle(color: primaryGreen)),
                  onPressed: () {
                    _showEditScheduleDialog(schedule);
                  },
                ),
                // ==================== DELETE BUTTON ====================
                TextButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    _showDeleteConfirmation(schedule);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DELETE CONFIRMATION ====================
  void _showDeleteConfirmation(ActiveSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              setState(() {
                _activeSchedules.removeWhere((s) => s.id == schedule.id);
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ==================== EDIT MODAL ====================
  void _showEditScheduleDialog(ActiveSchedule schedule) {
    final nameController = TextEditingController(text: schedule.name);
    final locationController = TextEditingController(text: schedule.location);
    final wasteTypeController = TextEditingController(text: schedule.wasteType);
    DateTime selectedDate = schedule.date;
    String timePeriod = schedule.timePeriod;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: wasteTypeController,
                  decoration: const InputDecoration(labelText: "Waste Type"),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: const Text("Select Date"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Close the dialog without saving
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          int index = _activeSchedules.indexWhere(
                            (s) => s.id == schedule.id,
                          );
                          _activeSchedules[index] = ActiveSchedule(
                            id: schedule.id,
                            name: nameController.text,
                            location: locationController.text,
                            wasteType: wasteTypeController.text,
                            date: selectedDate,
                            timePeriod: timePeriod,
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOldScheduleCard(OldSchedule schedule) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Date: ${schedule.date.toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.info_outline, color: Colors.grey),
        onTap: () => _showOldScheduleDetails(schedule),
      ),
    );
  }
}
