import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentSessionId;
  String? _userIp;

  Future<void> recordVisit() async {
    try {
      _currentSessionId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Get IP
      String ip = 'unknown';
      try {
        final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          ip = data['ip'];
        }
      } catch (e) {
        debugPrint('IP fetch error: $e');
      }
      _userIp = ip;

      // Get user agent
      String userAgent = 'unknown';
      if (kIsWeb) {
        try {
           userAgent = web.window.navigator.userAgent;
        } catch (_) {}
      } else {
         userAgent = defaultTargetPlatform.name;
      }

      await _firestore.collection('visits').add({
        'sessionId': _currentSessionId,
        'ip': ip,
        'userAgent': userAgent,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to record visit: $e');
    }
  }

  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    try {
      await _firestore.collection('events').add({
        'sessionId': _currentSessionId ?? 'unknown',
        'ip': _userIp ?? 'unknown',
        'eventName': eventName,
        'parameters': parameters ?? {},
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to log event: $e');
    }
  }
}

final analyticsService = AnalyticsService();
