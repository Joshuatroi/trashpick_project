import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashpick_project/models/schedule.dart';

class OfficialSchedule extends StatefulWidget {
  const OfficialSchedule({super.key});

  @override
  State<OfficialSchedule> createState() => _OfficialScheduleState();
}

class _OfficialScheduleState extends State<OfficialSchedule> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color primaryGreen = const Color(0xFF00A651);

  // Opens the create schedule form in a dialog
  void _showCreateScheduleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EditScheduleDialog(); // Use the Edit Dialog for creation as well
      },
    );
  }

  // Opens the edit schedule form in a dialog
  void _showEditScheduleDialog(Schedule schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditScheduleDialog(schedule: schedule);
      },
    );
  }

  // Shows a confirmation dialog before deleting a schedule
  Future<void> _showDeleteConfirmationDialog(String scheduleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this schedule? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _firestore.collection('schedules').doc(scheduleId).delete();
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateScheduleDialog,
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('schedules').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No schedules found. Click + to create one.'));
          }

          final allSchedules = snapshot.data!.docs.map((doc) => Schedule.fromFirestore(doc)).toList();
          
          final activeSchedules = allSchedules.where((s) => s.status == 'Active').toList();
          final oldSchedules = allSchedules.where((s) => s.status != 'Active').toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Add padding for FAB
            children: [
              const Text('Active Schedules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              activeSchedules.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No active schedules.')))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeSchedules.length,
                      itemBuilder: (context, i) => _buildScheduleCard(activeSchedules[i]),
                    ),
              const Divider(height: 40),
              const Text('Old Schedules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              oldSchedules.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No old schedules.')))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: oldSchedules.length,
                      itemBuilder: (context, i) => _buildScheduleCard(oldSchedules[i]),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    final bool isActive = schedule.status == 'Active';

    return Card(
      margin: const EdgeInsets.only(top: 14),
      elevation: isActive ? 2 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(schedule.scheduleName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                if (isActive) Icon(Icons.fire_truck, color: primaryGreen),
              ],
            ),
            const SizedBox(height: 8),
            Text("Location: ${schedule.location}", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text("Collection: ${schedule.wasteType}"),
            const SizedBox(height: 4),
            Text("Date: ${DateFormat('MMMM dd, yyyy').format(schedule.date)}"),
            const SizedBox(height: 4),
            Text("Time: ${schedule.timePeriod}"),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isActive) ...[
                  TextButton(child: Text('Edit', style: TextStyle(color: primaryGreen)), onPressed: () => _showEditScheduleDialog(schedule)),
                  TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () => _showDeleteConfirmationDialog(schedule.id),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () => _showEditScheduleDialog(schedule),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                    child: const Text('Set as Active'),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// A dedicated StatefulWidget for the creation/editing form to manage its own state
class EditScheduleDialog extends StatefulWidget {
  final Schedule? schedule; // If null, it's a new schedule
  const EditScheduleDialog({Key? key, this.schedule}) : super(key: key);

  @override
  EditScheduleDialogState createState() => EditScheduleDialogState();
}

class EditScheduleDialogState extends State<EditScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _timePeriodController = TextEditingController();
  final _dateController = TextEditingController();
  
  String? _selectedStreet;
  String? _selectedWasteType;
  DateTime? _selectedDate;
  String _currentStatus = 'Active';

  final List<String> labangonStreets = [
      'B. Zubiri Street', 'Bliss Road', 'Mariano M. Abella Street', 'Pedro Q. Cabaluna Street',
      'Katipunan Street', 'E. Jabonero Street', 'Osmeña Drive', 'Salvador Street',
      'Tres de Abril Street', 'La Tresas Street', 'Natalio Bacalso Avenue',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      final s = widget.schedule!;
      _nameController.text = s.scheduleName;
      _timePeriodController.text = s.timePeriod;
      _selectedDate = s.date;
      _dateController.text = DateFormat('MMMM dd, yyyy').format(s.date);
      _selectedStreet = s.location;
      _selectedWasteType = s.wasteType;
      // If editing an old schedule, default its status in the dialog to Active.
      _currentStatus = s.status == 'Active' ? s.status : 'Active';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timePeriodController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    final firestore = FirebaseFirestore.instance;
    final scheduleData = {
      'scheduleName': _nameController.text,
      'location': _selectedStreet!,
      'wasteType': _selectedWasteType!,
      'date': Timestamp.fromDate(_selectedDate!),
      'timePeriod': _timePeriodController.text,
      'status': _currentStatus,
      'barangayName': 'Barangay Pardo',
    };

    try {
      if (widget.schedule == null) { // Creating new schedule
        final currentUser = FirebaseAuth.instance.currentUser;
        scheduleData['createdBy'] = currentUser?.displayName ?? currentUser?.email ?? 'Official';
        await firestore.collection('schedules').add(scheduleData);
        if (!mounted) return; // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule created successfully')));
      } else { // Updating existing schedule
        await firestore.collection('schedules').doc(widget.schedule!.id).update(scheduleData);
        if (!mounted) return; // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule updated successfully')));
      }
      if (!mounted) return; // Check if the widget is still in the tree
      Navigator.pop(context); // Close dialog on success
    } catch (e) {
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save schedule: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.schedule != null;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isEditing ? 'Edit Schedule' : 'New Schedule', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (isEditing)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentStatus = _currentStatus == 'Active' ? 'Inactive' : 'Active';
                          });
                        },
                        icon: Icon(
                          _currentStatus == 'Active' ? Icons.visibility : Icons.visibility_off,
                          size: 16,
                          color: _currentStatus == 'Active' ? Colors.green : Colors.red,
                        ),
                        label: Text(
                          _currentStatus,
                          style: TextStyle(
                            color: _currentStatus == 'Active' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _currentStatus == 'Active' ? Colors.green : Colors.red,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Schedule Name', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStreet,
                  items: labangonStreets.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _selectedStreet = v),
                  decoration: const InputDecoration(labelText: 'Location (Street)', border: OutlineInputBorder()),
                  validator: (v) => v == null ? 'Please select a street' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedWasteType,
                  items: const ['Biodegradable', 'Recyclable', 'Residual', 'All Types'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setState(() => _selectedWasteType = v),
                  decoration: const InputDecoration(labelText: 'Waste Type', border: OutlineInputBorder()),
                  validator: (v) => v == null ? 'Please select a waste type' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Collection Date', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                  onTap: () async {
                    final picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
                      });
                    }
                  },
                  validator: (v) => v!.isEmpty ? 'Please select a date' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _timePeriodController,
                  decoration: const InputDecoration(labelText: 'Time Period (e.g., 6 AM - 10 AM)', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Please enter a time period' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _saveSchedule, child: const Text('Save Changes')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
