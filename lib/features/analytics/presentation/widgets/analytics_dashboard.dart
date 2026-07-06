import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Visits
            Expanded(
              flex: 1,
              child: Card(
                color: AppColors.deepSpace,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Visits',
                        style: AppTypography.h3.copyWith(color: AppColors.accentCyan),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('visits')
                              .orderBy('timestamp', descending: true)
                              .limit(50)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                            }
                            
                            final docs = snapshot.data?.docs ?? [];
                            if (docs.isEmpty) {
                              return const Text('No visits yet.', style: TextStyle(color: Colors.white));
                            }

                            return ListView.separated(
                              itemCount: docs.length,
                              separatorBuilder: (context, index) => Divider(color: AppColors.gray500.withValues(alpha: 0.3)),
                              itemBuilder: (context, index) {
                                final data = docs[index].data() as Map<String, dynamic>;
                                final timestamp = data['timestamp'] as Timestamp?;
                                final dateStr = timestamp != null
                                    ? DateFormat('MM/dd HH:mm:ss').format(timestamp.toDate())
                                    : 'Unknown';
                                final ip = data['ip'] ?? 'Unknown IP';
                                final ua = data['userAgent'] ?? '';

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('$ip', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Text('$dateStr • $ua', style: const TextStyle(color: AppColors.gray300, fontSize: 12)),
                                  leading: const Icon(Icons.person, color: AppColors.primaryBlue),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Right Column: Events
            Expanded(
              flex: 1,
              child: Card(
                color: AppColors.deepSpace,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Events',
                        style: AppTypography.h3.copyWith(color: AppColors.accentCyan),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('events')
                              .orderBy('timestamp', descending: true)
                              .limit(50)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                            }
                            
                            final docs = snapshot.data?.docs ?? [];
                            if (docs.isEmpty) {
                              return const Text('No events yet.', style: TextStyle(color: Colors.white));
                            }

                            return ListView.separated(
                              itemCount: docs.length,
                              separatorBuilder: (context, index) => Divider(color: AppColors.gray500.withValues(alpha: 0.3)),
                              itemBuilder: (context, index) {
                                final data = docs[index].data() as Map<String, dynamic>;
                                final timestamp = data['timestamp'] as Timestamp?;
                                final dateStr = timestamp != null
                                    ? DateFormat('MM/dd HH:mm:ss').format(timestamp.toDate())
                                    : 'Unknown';
                                final eventName = data['eventName'] ?? 'Unknown Event';
                                final params = data['parameters'] as Map<String, dynamic>? ?? {};
                                final ip = data['ip'] ?? 'Unknown IP';

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('$eventName', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Text('$dateStr • IP: $ip\nParams: $params', style: const TextStyle(color: AppColors.gray300, fontSize: 12)),
                                  leading: const Icon(Icons.touch_app, color: AppColors.highlightGreen),
                                  isThreeLine: true,
                                );
                              },
                            );
                          },
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
    );
  }
}
