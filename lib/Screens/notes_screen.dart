import 'package:flutter/material.dart';
import 'package:noteapp/notes_database/notes_database.dart';
import 'package:noteapp/Screens/note_editor_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/theme_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    final data = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMd().add_jm().format(date);
    } catch (e) {
      return dateStr; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      // backgroundColor: handled by Theme
      appBar: AppBar(
        // properties handled by Theme
        title: const Text(
          'Notes',
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined,
                          size: 100, color: Theme.of(context).dividerColor),
                      const SizedBox(height: 16),
                      Text(
                        'Create your first note',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final noteColor = note['color'] != null && note['color'] != 0
                        ? Color(note['color'])
                        : const Color(0xFF333333);
                        
                    // Determine text color based on note brightness
                    final isNoteDark = ThemeData.estimateBrightnessForColor(noteColor) == Brightness.dark;
                    final textColor = isNoteDark ? Colors.white : Colors.black;
                    final secondaryTextColor = isNoteDark ? Colors.white70 : Colors.black54;
                        
                    return Dismissible(
                      key: Key(note['id'].toString()),
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white, size: 30),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await NotesDatabase.instance.deleteNote(note['id']);
                        if (!mounted) return;
                        // Remove item from list immediately to avoid jitter before refresh
                        setState(() {
                          notes.removeAt(index);
                        });
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(content: Text('Note deleted')),
                        );
                        refreshNotes(); // Ensure sync
                      },
                      child: Card(
                        color: noteColor,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteEditorScreen(note: note),
                              ),
                            );
                            refreshNotes();
                          },
                          borderRadius: BorderRadius.circular(16),
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
                                        note['title'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Removed delete button as we have swipe-to-delete now, 
                                    // but keeping an icon for clarity is okay? 
                                    // Actually swipe is cleaner. Let's remove the redundancy.
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note['description'],
                                  style: TextStyle(
                                      color: secondaryTextColor, fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _formatDate(note['date']),
                                  style: TextStyle(
                                    color: secondaryTextColor.withValues(alpha: 0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
          );
          refreshNotes();
        },
        backgroundColor: const Color(0xFF64B5F6),
        label: const Text("Add Note", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
