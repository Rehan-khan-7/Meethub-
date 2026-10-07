import 'package:flutter/material.dart';

import '../../../models/user.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final User user;
  final VoidCallback onTaskUpdated;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.user,
    required this.onTaskUpdated,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController commentController = TextEditingController();

  final List<Map<String, dynamic>> checklist = [];

  final List<String> comments = [];

  bool get completed => widget.task['completed'] == true;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _toggleComplete() {
    setState(() {
      widget.task['completed'] = !completed;
      widget.task['status'] = widget.task['completed'] ? 'Done' : 'To Do';
    });

    widget.onTaskUpdated();
  }

  Future<void> _editTask() async {
    final titleController = TextEditingController(
      text: widget.task['title']?.toString() ?? '',
    );

    final descriptionController = TextEditingController(
      text: widget.task['description']?.toString() ?? '',
    );

    final dueDateController = TextEditingController(
      text: widget.task['dueDate']?.toString() ?? 'Today',
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF292E3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Task title',
                    labelStyle: const TextStyle(color: Color(0xFFB8BECC)),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Color(0xFFB8BECC)),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: dueDateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Due date',
                    labelStyle: const TextStyle(color: Color(0xFFB8BECC)),
                    prefixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF858B9B),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      dueDateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();

                if (title.isEmpty) return;

                setState(() {
                  widget.task['title'] = title;
                  widget.task['description'] = descriptionController.text
                      .trim();
                  widget.task['dueDate'] = dueDateController.text.trim().isEmpty
                      ? 'Today'
                      : dueDateController.text.trim();
                });

                widget.onTaskUpdated();

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2864E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
  }

  void _addChecklistItem() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF292E3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add checklist item',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Checklist item',
              hintStyle: const TextStyle(color: Color(0xFF777E8F)),
              filled: true,
              fillColor: const Color(0xFF202431),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();

                if (text.isEmpty) return;

                setState(() {
                  checklist.add({'title': text, 'completed': false});
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2864E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addComment() {
    final text = commentController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      comments.add(text);
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.task['title'] ?? 'Untitled task';
    final String description = widget.task['description'] ?? '';
    final String assignee = widget.task['assignee'] ?? widget.user.name;
    final String status = widget.task['status'] ?? 'To Do';

    return Scaffold(
      backgroundColor: const Color(0xFF202431),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
                children: [
                  _buildTopBar(),

                  const SizedBox(height: 22),

                  _buildTaskHeader(title, assignee, status),

                  const SizedBox(height: 18),

                  _buildDescription(description),

                  const SizedBox(height: 14),

                  _buildChecklist(),

                  const SizedBox(height: 14),

                  _buildActivity(),
                ],
              ),
            ),

            _buildCompleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 23),
        ),

        const SizedBox(width: 12),

        const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          color: const Color(0xFF343A4A),
          onSelected: (value) {
            if (value == 'edit') {
              _editTask();
            }

            if (value == 'delete') {
              // Delete feature baad mein connect karenge
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete task feature coming soon'),
                ),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: Colors.white, size: 19),
                  SizedBox(width: 8),
                  Text('Edit', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 19),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskHeader(String title, String assignee, String status) {
    final bool isDone = status == 'Done';
    final String dueDate = widget.task['dueDate']?.toString() ?? 'Today';
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Acme Corp HQ / Your Tasks',
                  style: TextStyle(color: Color(0xFF7B8293), fontSize: 11),
                ),
              ),

              _statusChip(isDone ? 'Done' : status),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF202431),
              fontSize: 25,
              fontWeight: FontWeight.w700,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),

          const SizedBox(height: 14),

          const Divider(color: Color(0xFFE3E6EC)),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _infoColumn('Assignee', assignee, Icons.person_outline),
              ),

              Expanded(
                child: _infoColumn(
                  'Due Date',
                  widget.task['dueDate']?.toString() ?? 'Today',
                  Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3E3),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFFE05252),
                ),
                const SizedBox(width: 7),
                Text(
                  isDone
                      ? 'Completed'
                      : 'Due $dueDate · Keep your task on track',
                  style: const TextStyle(
                    color: Color(0xFFE05252),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF858B9B), fontSize: 11),
        ),

        const SizedBox(height: 7),

        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFECE8FF),
              child: Text(
                value.isNotEmpty ? value[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Color(0xFF6950B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 7),

            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF252A38),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final bool done = status == 'Done';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFDDF5EA) : const Color(0xFFFFE0E0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: done ? const Color(0xFF079663) : const Color(0xFFD94C4C),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: done ? const Color(0xFF079663) : const Color(0xFFD94C4C),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Color(0xFF252A38),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description.isEmpty
                ? 'No description added for this task.'
                : description,
            style: const TextStyle(
              color: Color(0xFF73798C),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    final completedItems = checklist
        .where((item) => item['completed'] == true)
        .length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Checklist',
                style: TextStyle(
                  color: Color(0xFF252A38),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              if (checklist.isNotEmpty)
                Text(
                  '$completedItems of ${checklist.length} complete',
                  style: const TextStyle(
                    color: Color(0xFF858B9B),
                    fontSize: 10,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (checklist.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: checklist.isEmpty
                    ? 0
                    : completedItems / checklist.length,
                minHeight: 4,
                backgroundColor: const Color(0xFFE5E8EF),
                color: const Color(0xFF2864E8),
              ),
            ),

            const SizedBox(height: 14),
          ],

          if (checklist.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No checklist items yet.',
                style: TextStyle(color: Color(0xFF858B9B), fontSize: 12),
              ),
            ),

          ...List.generate(checklist.length, (index) {
            final item = checklist[index];
            final bool done = item['completed'] == true;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    item['completed'] = !done;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      done ? Icons.check_circle_outline : Icons.circle_outlined,
                      size: 18,
                      color: done
                          ? const Color(0xFF00A878)
                          : const Color(0xFFB8BECC),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          color: const Color(0xFF6F7687),
                          fontSize: 12,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          TextButton.icon(
            onPressed: _addChecklistItem,
            icon: const Icon(Icons.add, size: 17),
            label: const Text('Add item'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2864E8),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Activity',
                style: TextStyle(
                  color: Color(0xFF252A38),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              const Text(
                'Today',
                style: TextStyle(color: Color(0xFF858B9B), fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFECE8FF),
                child: Text(
                  widget.user.name.isNotEmpty
                      ? widget.user.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Color(0xFF6950B8),
                    fontSize: 10,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: Color(0xFF252A38),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      comments.isEmpty
                          ? 'Task details are ready for review.'
                          : comments.last,
                      style: const TextStyle(
                        color: Color(0xFF858B9B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  style: const TextStyle(
                    color: Color(0xFF252A38),
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF858B9B),
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.chat_bubble_outline,
                      size: 17,
                      color: Color(0xFF858B9B),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4F5F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(width: 7),

              IconButton(
                onPressed: _addComment,
                icon: const Icon(
                  Icons.send_outlined,
                  color: Color(0xFF2864E8),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 47,
        child: ElevatedButton.icon(
          onPressed: _toggleComplete,
          icon: Icon(completed ? Icons.check : Icons.check, size: 18),
          label: Text(completed ? 'Mark as incomplete' : 'Mark as complete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2864E8),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
