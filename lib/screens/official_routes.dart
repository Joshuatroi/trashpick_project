import 'package:flutter/material.dart';

// Data models for the routes
class ActiveRoute {
  final String name;
  final String location;
  final String wasteType;
  final String timePeriod;

  ActiveRoute({required this.name, required this.location, required this.wasteType, required this.timePeriod});
}

class OldRoute {
  final String name;
  final String location;
  final String wasteType;
  final String timePeriod;

  OldRoute({required this.name, required this.location, required this.wasteType, required this.timePeriod});
}

class OfficialRoutes extends StatefulWidget {
  const OfficialRoutes({super.key});

  @override
  State<OfficialRoutes> createState() => _OfficialRoutesState();
}

class _OfficialRoutesState extends State<OfficialRoutes> {
  // Dummy Data
  final List<ActiveRoute> _activeRoutes = [
    ActiveRoute(name: 'North District Residential', location: 'Sunshine Road, Elm Street', wasteType: 'Biodegradable', timePeriod: '6 AM - 10 AM'),
    ActiveRoute(name: 'Downtown Commercial', location: 'Main Avenue, Central Plaza', wasteType: 'Recyclable', timePeriod: '8 AM - 12 PM'),
    ActiveRoute(name: 'West Suburbs', location: 'Oakwood Drive, Willow Creek', wasteType: 'All Types', timePeriod: '7 AM - 11 AM'),
  ];

  final List<OldRoute> _oldRoutes = [
    OldRoute(name: 'Holiday Special Route', location: 'City-wide', wasteType: 'All Types', timePeriod: '9 AM - 1 PM'),
    OldRoute(name: 'Summer Festival Route', location: 'Beachfront area', wasteType: 'Recyclable', timePeriod: '10 AM - 2 PM'),
  ];

  bool _isCreatingRoute = false;
  final Color primaryGreen = const Color(0xFF00A651);

  void _toggleCreateRouteForm() {
    setState(() {
      _isCreatingRoute = !_isCreatingRoute;
    });
  }

  void _showOldRouteDetails(OldRoute route) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(route.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [const TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: route.location)])),
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [const TextSpan(text: 'Waste Type: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: route.wasteType)])),
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [const TextSpan(text: 'Time Period: ', style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: route.timePeriod)])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () { /* TODO: Handle Use Route */ },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
              child: const Text('Use Route'),
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
          // Active Routes Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Routes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _toggleCreateRouteForm,
                child: Text(
                  _isCreatingRoute ? 'Cancel' : '+ Create Route',
                  style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Conditionally show the create route form
          if (_isCreatingRoute) _buildCreateRouteForm(),

          // Active Routes List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeRoutes.length,
            itemBuilder: (context, index) {
              final route = _activeRoutes[index];
              return _buildActiveRouteCard(route);
            },
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // Old Routes Section
          const Text(
            'Old Routes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _oldRoutes.length,
            itemBuilder: (context, index) {
              final route = _oldRoutes[index];
              return _buildOldRouteCard(route);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRouteForm() {
    return Card(
      color: primaryGreen.withAlpha(26),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Route Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Route Name', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Location (e.g., Street Names)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Waste Type (e.g., Recyclable)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Time Period (e.g., 6 AM - 10 AM)', border: OutlineInputBorder(), fillColor: Colors.white, filled: true)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('Save Route'), style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRouteCard(ActiveRoute route) {
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
                    route.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.map_outlined, color: Colors.blueAccent),
                  onPressed: () { /* TODO: Handle map click */ },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Location: ${route.location}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Collection: ${route.wasteType}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('Time: ${route.timePeriod}', style: const TextStyle(fontSize: 16)),
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

   Widget _buildOldRouteCard(OldRoute route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(route.name),
        onTap: () => _showOldRouteDetails(route),
        trailing: const Icon(Icons.info_outline, color: Colors.grey),
      ),
    );
  }
}
