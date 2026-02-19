import 'package:flutter/material.dart';
import 'package:noteapp/notes_database/notes_database.dart';


class NoteEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  int _selectedColor = 0xFF333333; // Default dark grey

  final List<int> _colors = [
    0xFF333333, // Default
    0xFFE57373, // Red
    0xFF81C784, // Green
    0xFF64B5F6, // Blue
    0xFFFFD54F, // Yellow
    0xFFBA68C8, // Purple
    0xFFFF8A65, // Orange
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?['description'] ?? '');
    _selectedColor = widget.note?['color'] ?? 0xFF333333;
    if (_selectedColor == 0) _selectedColor = 0xFF333333;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeData.estimateBrightnessForColor(Color(_selectedColor)) == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color hintColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: Color(_selectedColor),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? textColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                           BoxShadow(
                             color: Colors.black.withValues(alpha: 0.2),
                             blurRadius: 4,
                           )
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: hintColor),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                style: TextStyle(color: textColor, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty && description.isEmpty) {
      return;
    }

    final date = DateTime.now().toIso8601String();

    if (widget.note == null) {
      await NotesDatabase.instance.addNote(
        title,
        description,
        date,
        _selectedColor,
      );
    } else {
      await NotesDatabase.instance.updateNote(
        widget.note!['id'],
        title,
        description,
        date,
        _selectedColor,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
