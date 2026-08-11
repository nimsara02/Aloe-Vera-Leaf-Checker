import 'dart:io';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'detailed_result_screen.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ResultRecord> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // FR32: Load all inspection results from SQLite
  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllResults();
    setState(() {
      _historyList = data;
      _isLoading = false;
    });
  }

  // FR42: Search History by Leaf ID, Grade, or Disease
  Future<void> _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      _loadHistory();
      return;
    }
    setState(() => _isLoading = true);
    final filteredData = await DatabaseHelper.instance.searchResults(query.trim());
    setState(() {
      _historyList = filteredData;
      _isLoading = false;
    });
  }

  // FR33: Delete record from SQLite with confirmation
  Future<void> _deleteRecord(int id, String leafId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete scan "$leafId"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteResult(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspection record deleted.')),
        );
      }
      _loadHistory(); // Refresh list after deletion
    }
  }

  Color _getGradeColor(String grade) {
    if (grade.contains('A')) return Colors.green[700]!;
    if (grade.contains('B')) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('Inspection History'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Column(
        children: [
          // FR42: Search Bar Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.green[700],
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by Leaf ID, Grade, or Disease...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _loadHistory();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // FR32: History Record List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.green))
                : _historyList.isEmpty
                ? Center(child: _buildEmptyState())
                : RefreshIndicator(
              onRefresh: _loadHistory,
              color: Colors.green[700],
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: _historyList.length,
                itemBuilder: (context, index) {
                  final record = _historyList[index];
                  final gradeColor = _getGradeColor(record.finalGrade);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 8.0,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: File(record.imagePath).existsSync()
                              ? Image.file(
                            File(record.imagePath),
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.eco, color: Colors.green),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              record.leafId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: gradeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              record.finalGrade,
                              style: TextStyle(
                                color: gradeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Disease: ${record.diseaseDetected}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            record.timestamp,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          if (record.id != null) {
                            _deleteRecord(record.id!, record.leafId);
                          }
                        },
                      ),
                      onTap: () async {
                        final refreshed = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedResultScreen(record: record),
                          ),
                        );
                        if (refreshed == true) {
                          _loadHistory();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history_toggle_off, size: 70, color: Colors.grey[400]),
        const SizedBox(height: 12),
        Text(
          _searchController.text.isNotEmpty ? 'No matching records found' : 'No inspection history yet',
          style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          _searchController.text.isNotEmpty
              ? 'Try searching with a different term'
              : 'Completed leaf scans will automatically appear here',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}