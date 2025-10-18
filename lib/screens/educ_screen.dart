import 'package:flutter/material.dart';

class EducScreen extends StatelessWidget {
  const EducScreen({super.key});

  final Color primaryGreen = const Color(0xFF00A651);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Education',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'The Importance of Waste Segregation',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Waste segregation is the process of separating different types of waste at the source. It is a crucial step in waste management as it helps in recycling, reducing landfill burden, and preventing environmental pollution. Proper segregation ensures that waste is processed in the most efficient and environmentally friendly manner.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  Divider(color: primaryGreen),
                  const SizedBox(height: 10),
                  Text(
                    'Types of Waste',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                  const SizedBox(height: 10),
                  _buildWasteTypeCard(
                    title: 'Organic Waste (Wet Waste)',
                    icon: Icons.eco,
                    color: primaryGreen,
                    description:
                        'This includes biodegradable waste from your kitchen.',
                    examples: 'Examples: Fruit peels, vegetable scraps, leftover food, eggshells, coffee grounds, tea bags.',
                  ),
                  _buildWasteTypeCard(
                    title: 'Recyclable Waste (Dry Waste)',
                    icon: Icons.recycling,
                    color: Colors.blue,
                    description:
                        'Items that can be processed and used to make new products.',
                    examples: 'Examples: Paper, cardboard, plastic bottles, glass containers, metal cans.',
                  ),
                  _buildWasteTypeCard(
                    title: 'Hazardous Waste',
                    icon: Icons.warning,
                    color: Colors.red,
                    description:
                        'Waste that is harmful to people or the environment and needs special disposal.',
                    examples: 'Examples: Batteries, paint cans, CFL bulbs, expired medicines, chemical cleaners.',
                  ),
                  _buildWasteTypeCard(
                    title: 'E-Waste (Electronic Waste)',
                    icon: Icons.devices,
                    color: Colors.grey[700]!,
                    description:
                        'Discarded electronic devices.',
                    examples: 'Examples: Old phones, laptops, chargers, TVs, refrigerators.',
                  ),
                  _buildWasteTypeCard(
                    title: 'Sanitary Waste',
                    icon: Icons.medical_services,
                    color: Colors.pink[200]!,
                    description:
                        'Waste items that are contaminated with bodily fluids.',
                    examples: 'Examples: Diapers, sanitary napkins, bandages, used masks and gloves.',
                  ),
                  const SizedBox(height: 20),
                  Divider(color: primaryGreen),
                  const SizedBox(height: 10),
                  Text(
                    'Frequently Asked Questions (FAQs)',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                  const SizedBox(height: 10),
                  _buildFaq(
                    question: 'Why can\'t I mix wet and dry waste?',
                    answer: 'Mixing wet and dry waste contaminates the recyclable materials, making them difficult to process. It also leads to the emission of harmful greenhouse gases from landfills.',
                  ),
                  _buildFaq(
                    question: 'How should I dispose of e-waste?',
                    answer: 'E-waste should not be thrown in regular dustbins. Look for authorized e-waste collection centers or drop-off points in your city. Many electronics brands also have take-back programs.',
                  ),
                  _buildFaq(
                    question: 'What about medical waste from home?',
                    answer: 'Wrap sanitary waste securely in newspaper or a bag and place it in the bin for non-recyclable waste. For items like syringes or expired medicines, consult your local pharmacy or a medical waste disposal service for safe disposal options.',
                  ),
                  const SizedBox(height: 20),
                  Divider(color: primaryGreen),
                  const SizedBox(height: 10),
                  Text(
                    'Helpful Links',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                  const SizedBox(height: 10),
                  _buildLink(
                      context,
                      'National Geographic: Waste Management',
                      '[link-to-be-added]'),
                  _buildLink(
                      context,
                      'YouTube: How Does Recycling Work?',
                      '[link-to-be-added]'),
                  _buildLink(
                      context,
                      'EPA: Learn about E-Waste',
                      '[link-to-be-added]'),
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteTypeCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required String examples,
  }) {
    return Card(
      color: primaryGreen.withAlpha(26),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Text(examples, style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildFaq({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer, textAlign: TextAlign.justify),
        )
      ],
    );
  }

  Widget _buildLink(BuildContext context, String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  url,
                  style: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
