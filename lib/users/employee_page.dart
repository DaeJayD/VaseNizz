import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vasenizzpos/main.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final supabase = Supabase.instance.client;

  bool _loading = false;
  Map<String, dynamic>? _employee;
  List<Map<String, dynamic>> _attendanceHistory = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _status = "Off Duty";

  @override
  void initState() {
    super.initState();
    _loadEmployeeInfo();
    _loadAttendanceHistory();
  }

  Future<void> _loadEmployeeInfo() async {
    try {
      final data = await supabase
          .from('employees')
          .select()
          .eq('user_id', widget.userId)
          .maybeSingle();

      if (data == null) return;

      setState(() => _employee = Map<String, dynamic>.from(data));
    } catch (e) {
      print('Error fetching employee: $e');
    }
  }

  Future<void> _loadAttendanceHistory() async {
    try {
      final data = await supabase
          .from('attendance')
          .select()
          .eq('user_id', widget.userId)
          .order('date', ascending: false);

      if (data == null) return;

      setState(() {
        _attendanceHistory = List<Map<String, dynamic>>.from(data);
        _updateStatus();
      });
    } catch (e) {
      print('Error fetching attendance: $e');
    }
  }

  void _updateStatus() {
    if (_attendanceHistory.isEmpty) {
      _status = "Off Duty";
      return;
    }
    final lastEntry = _attendanceHistory.first;
    if (lastEntry['time_out'] == null) {
      _status = "On Duty";
    } else {
      _status = "Off Duty";
    }
  }

  Future<void> _timeIn() async {
    setState(() {
      _loading = true;
      _status = "On Duty";
    });
    final today = DateTime.now().toIso8601String().split('T')[0];

    try {
      await supabase.from('attendance').insert({
        'user_id': widget.userId,
        'time_in': DateTime.now().toIso8601String(),
        'date': today,
      });
      await _loadAttendanceHistory();
    } catch (e) {
      print('Time In error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _timeOut() async {
    setState(() => _loading = true);
    final today = DateTime.now().toIso8601String().split('T')[0];

    try {
      await supabase.from('attendance').update({
        'time_out': DateTime.now().toIso8601String(),
      }).eq('user_id', widget.userId).eq('date', today);

      await _loadAttendanceHistory();
    } catch (e) {
      print('Time Out error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  bool _isAttendanceDay(DateTime day) {
    return _attendanceHistory.any((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return day.year == entryDate.year &&
          day.month == entryDate.month &&
          day.day == entryDate.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCE4EC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF48FB1),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();

              // Redirect to login page
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VasenizzApp()), // replace with your login/home widget
                );
              }
            },
          ),
        ],
      ),
      body: _employee == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User info card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pink[100],
                      child: Icon(Icons.person, size: 50, color: Colors.pink[400]),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_employee!['name'] ?? '',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                          SizedBox(height: 8),
                          Text("Status: $_status",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: _status == "On Duty" ? Colors.green[700] : Colors.red[700])),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _loading ? null : _timeIn,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text('Time In', style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _loading ? null : _timeOut,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text('Time Out', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Attendance calendar
            SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Attendance Calendar",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                    TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (_isAttendanceDay(day)) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink[400]),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Attendance history
            SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Attendance History",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                    SizedBox(height: 12),
                    ..._attendanceHistory.map((entry) {
                      final timeIn = entry['time_in'] != null ? DateTime.parse(entry['time_in']) : null;
                      final timeOut = entry['time_out'] != null ? DateTime.parse(entry['time_out']) : null;
                      return ListTile(
                        title: Text(
                            "${entry['date']} - In: ${timeIn != null ? "${timeIn.hour}:${timeIn.minute.toString().padLeft(2, '0')}" : "N/A"} | Out: ${timeOut != null ? "${timeOut.hour}:${timeOut.minute.toString().padLeft(2, '0')}" : "N/A"}"),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            // Employee info
            SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Personal Information",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _employee!['name'] ?? '',
                      decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _employee!['user_id'] ?? '',
                      decoration: InputDecoration(labelText: 'Employee ID', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _employee!['phone'] ?? '',
                      decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      initialValue: _employee!['branch_assigned'] ?? '',
                      decoration: InputDecoration(labelText: 'Branch Assigned', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
