import 'package:flutter/material.dart';

import '../data/task_repository.dart';
import 'task_detail_screen.dart';
import '../../../models/user.dart';
import '../../../widgets/deskverse_bottom_nav.dart';

class TasksScreen extends StatefulWidget {
  final User user;
  final String workspaceId;

  const TasksScreen({super.key, required this.user, required this.workspaceId});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskRepository taskRepository = TaskRepository();

  List<Map<String, dynamic>> get tasks => taskRepository.getTasks();

  String searchQuery = '';
  bool assignedToMe = false;

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF292E3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A66D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_task,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Create a new task for your workspace',
                            style: TextStyle(
                              color: Color(0xFF9DA3B4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF9DA3B4),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Task title
                const Text(
                  'Task title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'e.g. Review project',
                    hintStyle: const TextStyle(
                      color: Color(0xFF777E8F),
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    prefixIcon: const Icon(
                      Icons.task_alt_outlined,
                      color: Color(0xFF7F8DAA),
                      size: 19,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF2864E8),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Add some details about this task...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF777E8F),
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(
                        Icons.description_outlined,
                        color: Color(0xFF7F8DAA),
                        size: 19,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF2864E8),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Due Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: dueDateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Select due date',
                    hintStyle: const TextStyle(
                      color: Color(0xFF777E8F),
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF202431),
                    prefixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF7F8DAA),
                      size: 19,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF2864E8),
                        width: 1.2,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2035),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xFF2864E8),
                              surface: Color(0xFF292E3D),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (selectedDate != null) {
                      dueDateController.text =
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                          '${selectedDate.month.toString().padLeft(2, '0')}/'
                          '${selectedDate.year}';
                    }
                  },
                ),

                const SizedBox(height: 22),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFB8BECC),
                          side: const BorderSide(color: Color(0xFF454B5B)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();

                          if (title.isEmpty || dueDateController.text.isEmpty) {
                            return;
                          }

                          taskRepository.addTask({
                            'title': title,
                            'description': descriptionController.text.trim(),
                            'completed': false,
                            'status': 'To Do',
                            'assignee': widget.user.name,
                            'dueDate': dueDateController.text,
                          });

                          setState(() {});

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2864E8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Create Task',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      taskRepository.deleteTask(index);
    });
  }

  List<Map<String, dynamic>> get filteredTasks {
    return tasks.where((task) {
      final title = task['title'].toString().toLowerCase();

      final matchesSearch = title.contains(searchQuery.toLowerCase());

      final matchesAssignee =
          !assignedToMe || task['assignee'] == widget.user.name;

      return matchesSearch && matchesAssignee;
    }).toList();
  }

  int get completedCount {
    return tasks.where((task) => task['completed'] == true).length;
  }

  int get overdueCount {
    // Actual due-date logic backend/model aane ke baad add karenge.
    return 0;
  }

  int get totalCount => tasks.length;

  int get efficiency {
    if (totalCount == 0) return 0;

    return ((completedCount / totalCount) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202431),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  _buildHeader(),

                  const SizedBox(height: 28),

                  _buildTitleSection(),

                  const SizedBox(height: 18),

                  _buildStatistics(),

                  const SizedBox(height: 18),

                  _buildUpcomingDeadline(),

                  const SizedBox(height: 22),

                  _buildYourTasksHeader(),

                  const SizedBox(height: 12),

                  _buildSearchAndFilter(),

                  const SizedBox(height: 12),

                  _buildFilterTabs(),

                  const SizedBox(height: 12),

                  if (filteredTasks.isEmpty)
                    _buildEmptyTasks()
                  else
                    _buildTaskList(),

                  const SizedBox(height: 18),

                  _buildTeamWorkload(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Existing bottom navigation — unchanged.
      bottomNavigationBar: DeskVerseBottomNav(
        currentIndex: 3,
        user: widget.user,
        workspaceId: widget.workspaceId,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.layers_outlined, color: Colors.white, size: 34),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DeskVerse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Acme Corp HQ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 12,
              ),
            ),
          ],
        ),

        const Spacer(),

        Icon(
          Icons.notifications_none_rounded,
          color: Colors.white.withOpacity(0.8),
          size: 24,
        ),

        const SizedBox(width: 16),

        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFEAF0FF),
          child: Text(
            widget.user.name.isNotEmpty
                ? widget.user.name[0].toUpperCase()
                : 'U',
            style: const TextStyle(
              color: Color(0xFF2864E8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Your team's work, all in one place.",
                style: TextStyle(color: Color(0xFF9DA3B4), fontSize: 13),
              ),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: _showAddTaskDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Task'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2864E8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.75,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard(
          title: 'Total Tasks',
          value: totalCount.toString(),
          valueColor: const Color(0xFF202431),
        ),
        _statCard(
          title: 'Completed',
          value: completedCount.toString(),
          valueColor: const Color(0xFF0A9F6E),
        ),
        _statCard(
          title: 'Overdue Tasks',
          value: overdueCount.toString(),
          valueColor: const Color(0xFFF08A22),
        ),
        _statCard(
          title: 'Task Efficiency',
          value: '$efficiency%',
          valueColor: const Color(0xFF202431),
          showProgress: true,
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required Color valueColor,
    bool showProgress = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF7C8293), fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          if (showProgress)
            Positioned(
              right: 2,
              bottom: 2,
              child: SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  value: efficiency / 100,
                  strokeWidth: 3,
                  backgroundColor: const Color(0xFFE5E8EF),
                  color: const Color(0xFF0A9F6E),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadline() {
    final pendingTasks = tasks
        .where((task) => task['completed'] != true)
        .toList();

    if (pendingTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No upcoming deadlines',
          style: TextStyle(color: Color(0xFF73798C), fontSize: 13),
        ),
      );
    }

    pendingTasks.sort((a, b) {
      final dateA = _parseDate(a['dueDate']);
      final dateB = _parseDate(b['dueDate']);

      return dateA.compareTo(dateB);
    });

    final task = pendingTasks.first;

    final dueDate = _parseDate(task['dueDate']);
    final today = DateTime.now();

    final todayOnly = DateTime(today.year, today.month, today.day);

    final dueOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = dueOnly.difference(todayOnly).inDays;

    String deadlineText;

    if (difference == 0) {
      deadlineText = 'Due today';
    } else if (difference == 1) {
      deadlineText = 'Due tomorrow';
    } else if (difference > 1) {
      deadlineText = 'Due in $difference days';
    } else {
      deadlineText = 'Overdue';
    }

    final deadlineColor = difference < 0
        ? const Color(0xFFFFE0E0)
        : const Color(0xFFFFE3E3);

    final textColor = difference < 0
        ? const Color(0xFFD94C4C)
        : const Color(0xFFE05252);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 68,
            decoration: BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Deadline',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202431),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  task['title'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202431),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${task['dueDate']} · ${task['assignee']}',
                  style: const TextStyle(
                    color: Color(0xFF858B9B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: deadlineColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              deadlineText,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDate(String date) {
    final parts = date.split('/');

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  Widget _buildYourTasksHeader() {
    return Row(
      children: [
        const Text(
          'Your Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Text(
          '${tasks.length} tasks',
          style: const TextStyle(color: Color(0xFF9DA3B4), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            style: const TextStyle(color: Color(0xFF202431), fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search Task...',
              hintStyle: const TextStyle(color: Color(0xFF858B9B)),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Color(0xFF858B9B),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune, size: 17),
          label: const Text('Filter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2864E8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              assignedToMe = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: !assignedToMe ? Colors.white : const Color(0xFF292E3D),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              'All tasks',
              style: TextStyle(
                color: !assignedToMe
                    ? const Color(0xFF2864E8)
                    : const Color(0xFFAAB0C0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: () {
            setState(() {
              assignedToMe = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: assignedToMe ? Colors.white : const Color(0xFF292E3D),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              'Assigned to me',
              style: TextStyle(
                color: assignedToMe
                    ? const Color(0xFF2864E8)
                    : const Color(0xFFAAB0C0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(filteredTasks.length, (index) {
          final task = filteredTasks[index];

          return _buildTaskItem(task);
        }),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    final bool completed = task['completed'] == true;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(
              task: task,
              user: widget.user,
              onTaskUpdated: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE8EAF0))),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  task['completed'] = !completed;
                  task['status'] = task['completed'] ? 'Done' : 'To Do';
                });
              },
              child: Icon(
                completed ? Icons.check_circle_outline : Icons.circle_outlined,
                color: completed
                    ? const Color(0xFF00A878)
                    : const Color(0xFFB8BECC),
                size: 22,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'].toString(),
                    style: TextStyle(
                      color: const Color(0xFF252A38),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: const Color(0xFFECE8FF),
                        child: Text(
                          task['assignee']
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF6950B8),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        task['assignee'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF858B9B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statusChip(task['status'].toString()),

                const SizedBox(height: 7),

                const Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Color(0xFF777E8F),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Today',
                      style: TextStyle(color: Color(0xFF777E8F), fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 5),

            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: Color(0xFF7B8191),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  final index = tasks.indexOf(task);

                  if (index != -1) {
                    _deleteTask(index);
                  }
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),

            const Icon(Icons.chevron_right, size: 19, color: Color(0xFF8A90A0)),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color background;
    Color foreground;

    if (status == 'Done') {
      background = const Color(0xFFDDF5EA);
      foreground = const Color(0xFF079663);
    } else if (status == 'In Progress') {
      background = const Color(0xFFFFEDC9);
      foreground = const Color(0xFFC67A00);
    } else {
      background = const Color(0xFFFFE0E0);
      foreground = const Color(0xFFD94C4C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasks() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.task_alt, size: 42, color: Color(0xFF2864E8)),
          SizedBox(height: 12),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202431),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Create a task to keep your workspace organized.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF7C8293), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamWorkload() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Team workload',
              style: TextStyle(
                color: Color(0xFF202431),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),

          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF777E8F)),
        ],
      ),
    );
  }
}
