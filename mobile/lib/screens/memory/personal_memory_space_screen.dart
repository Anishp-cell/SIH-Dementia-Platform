import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/caregiver_feedback.dart';
import '../../models/memory_item.dart';
import '../../services/memory_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';

/// Caregiver-managed Personal Memory Space Screen.
/// Enables adding, editing, previewing, and removing familiar photos,
/// people, places, music, memories, and conversation topics used in patient activities.
class PersonalMemorySpaceScreen extends StatefulWidget {
  const PersonalMemorySpaceScreen({super.key});

  @override
  State<PersonalMemorySpaceScreen> createState() => _PersonalMemorySpaceScreenState();
}

class _PersonalMemorySpaceScreenState extends State<PersonalMemorySpaceScreen> {
  MemoryType? _selectedCategory; // null = All
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    MemoryService.instance.initialize();
    MemoryService.instance.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    MemoryService.instance.removeListener(_onServiceUpdate);
    super.dispose();
  }

  List<MemoryItem> _filterMemories(List<MemoryItem> all) {
    return all.where((item) {
      if (_selectedCategory != null && item.type != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchContext = (item.relationOrContext ?? '').toLowerCase().contains(q);
        return matchTitle || matchContext;
      }
      return true;
    }).toList();
  }

  void _openAddEditSheet({MemoryItem? existingItem}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddEditMemorySheet(existingItem: existingItem),
    );
  }

  void _openPreviewDialog(MemoryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => _MemoryDetailPreviewDialog(
        item: item,
        onEdit: () {
          Navigator.of(ctx).pop();
          _openAddEditSheet(existingItem: item);
        },
        onDelete: () {
          Navigator.of(ctx).pop();
          _confirmDelete(item);
        },
      ),
    );
  }

  void _confirmDelete(MemoryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWarm,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Remove from Activities?', style: AppTypography.patientTitle),
        content: Text(
          'Are you sure you want to remove "${item.title}"? It will no longer appear in patient recognition and conversation activities.',
          style: AppTypography.caregiverBody,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          ElderButton(
            label: 'Keep Item',
            variant: ElderButtonVariant.primary,
            height: 48,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          const SizedBox(height: 10),
          ElderButton(
            label: 'Remove Item',
            variant: ElderButtonVariant.peach,
            height: 48,
            onPressed: () {
              MemoryService.instance.deleteMemory(item.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "${item.title}" safely.'),
                  backgroundColor: AppColors.forestPrimary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMemories = MemoryService.instance.memories;
    final filtered = _filterMemories(allMemories);

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        title: const Text('Personal Memory Space', style: AppTypography.caregiverHeading),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.forestPrimary),
            tooltip: 'Add Personal Content',
            onPressed: () => _openAddEditSheet(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Informative Banner
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 8),
              child: FeedbackBanner(
                type: FeedbackBannerType.info,
                title: 'Personalized Activity Content',
                message: 'Photos, songs, and memories added here are used directly inside matching and conversation experiences.',
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search memories, people, places...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.forestPrimary),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderSoft),
                  ),
                ),
              ),
            ),

            // Category Horizontal Tabs
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildCategoryChip(label: 'All (${allMemories.length})', type: null),
                  _buildCategoryChip(label: 'Photos', type: MemoryType.photo),
                  _buildCategoryChip(label: 'People', type: MemoryType.person),
                  _buildCategoryChip(label: 'Places', type: MemoryType.place),
                  _buildCategoryChip(label: 'Music', type: MemoryType.music),
                  _buildCategoryChip(label: 'Memories', type: MemoryType.story),
                  _buildCategoryChip(label: 'Conversation', type: MemoryType.conversationPrompt),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Content List or Empty State
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _buildMemoryCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.forestPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Content', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        onPressed: () => _openAddEditSheet(),
      ),
    );
  }

  Widget _buildCategoryChip({required String label, required MemoryType? type}) {
    final isSelected = _selectedCategory == type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.forestPrimary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        onSelected: (val) => setState(() => _selectedCategory = type),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CalmCard(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceWarm,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_album_outlined, size: 48, color: AppColors.sage),
              ),
              const SizedBox(height: 18),
              const Text(
                'No Memories Here Yet',
                style: AppTypography.patientTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Add family photographs, beloved songs, or cherished hometown memories to make activities warmly familiar.',
                style: AppTypography.caregiverBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElderButton(
                label: 'Add First Memory',
                icon: Icons.add,
                variant: ElderButtonVariant.primary,
                height: 50,
                onPressed: () => _openAddEditSheet(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryCard(MemoryItem item) {
    IconData icon;
    Color iconColor;

    switch (item.type) {
      case MemoryType.photo:
      case MemoryType.person:
        icon = Icons.photo_camera_front_outlined;
        iconColor = AppColors.domainMemory;
        break;
      case MemoryType.place:
        icon = Icons.nature_people_outlined;
        iconColor = AppColors.domainOrientation;
        break;
      case MemoryType.music:
        icon = Icons.music_note_outlined;
        iconColor = AppColors.domainLanguage;
        break;
      case MemoryType.story:
      case MemoryType.conversationPrompt:
        icon = Icons.chat_bubble_outline;
        iconColor = AppColors.forestPrimary;
        break;
      case MemoryType.object:
        icon = Icons.category_outlined;
        iconColor = AppColors.domainVisuospatial;
        break;
    }

    return CalmCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      onTap: () => _openPreviewDialog(item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon or Media Placeholder
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    if (item.relationOrContext != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.relationOrContext!,
                        style: AppTypography.caregiverBody.copyWith(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
              // Context Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.forestPrimary),
                onSelected: (action) {
                  if (action == 'preview') _openPreviewDialog(item);
                  if (action == 'edit') _openAddEditSheet(existingItem: item);
                  if (action == 'delete') _confirmDelete(item);
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'preview', child: Text('Preview')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit Content')),
                  const PopupMenuItem(value: 'delete', child: Text('Remove', style: TextStyle(color: AppColors.peachDark))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category badge and sync status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.typeLabel,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.forestDark),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.syncStatus == SyncStatus.synced ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined,
                    size: 16,
                    color: item.syncStatus == SyncStatus.synced ? AppColors.sage : AppColors.offlineAmber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.syncStatus == SyncStatus.synced ? 'Synced' : 'Saved Locally',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: item.syncStatus == SyncStatus.synced ? AppColors.sage : AppColors.offlineAmber,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Activity Usage Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundWarm,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSoft, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.extension_outlined, size: 16, color: AppColors.forestPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Used in: ${item.activityUsageLabels.join(', ')}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.forestPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal bottom sheet for adding or editing a personal memory item.
class _AddEditMemorySheet extends StatefulWidget {
  final MemoryItem? existingItem;

  const _AddEditMemorySheet({this.existingItem});

  @override
  State<_AddEditMemorySheet> createState() => _AddEditMemorySheetState();
}

class _AddEditMemorySheetState extends State<_AddEditMemorySheet> {
  late TextEditingController _titleController;
  late TextEditingController _contextController;
  late MemoryType _type;
  bool _hasPlaceholderMedia = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingItem?.title ?? '');
    _contextController = TextEditingController(text: widget.existingItem?.relationOrContext ?? '');
    _type = widget.existingItem?.type ?? MemoryType.photo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a gentle title for this memory.')),
      );
      return;
    }

    final contextText = _contextController.text.trim();

    if (widget.existingItem != null) {
      final updated = widget.existingItem!.copyWith(
        title: title,
        type: _type,
        relationOrContext: contextText.isEmpty ? null : contextText,
        syncStatus: SyncStatus.synced,
      );
      MemoryService.instance.updateMemory(updated);
    } else {
      final newItem = MemoryItem(
        id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        type: _type,
        relationOrContext: contextText.isEmpty ? null : contextText,
        iconOrImagePath: 'assets/images/placeholder_memory.jpg',
        syncStatus: SyncStatus.synced,
        dateAdded: DateTime.now(),
      );
      MemoryService.instance.addMemory(newItem);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

    return Container(
      padding: EdgeInsets.fromLTRB(22, 20, 22, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWarm,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  isEditing ? 'Edit Memory Item' : 'Add New Memory Item',
                  style: AppTypography.patientTitle,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Category Picker
            const Text('Category', style: AppTypography.caregiverSubheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                MemoryType.photo,
                MemoryType.person,
                MemoryType.place,
                MemoryType.music,
                MemoryType.story,
                MemoryType.conversationPrompt,
              ].map((t) {
                final isSelected = _type == t;
                String label;
                switch (t) {
                  case MemoryType.photo:
                    label = 'Photo';
                    break;
                  case MemoryType.person:
                    label = 'Person';
                    break;
                  case MemoryType.place:
                    label = 'Place';
                    break;
                  case MemoryType.music:
                    label = 'Music';
                    break;
                  case MemoryType.story:
                    label = 'Memory';
                    break;
                  case MemoryType.conversationPrompt:
                    label = 'Conversation';
                    break;
                  case MemoryType.object:
                    label = 'Object';
                    break;
                }
                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: AppColors.forestPrimary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (val) => setState(() => _type = t),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Title
            const Text('Title / Name', style: AppTypography.caregiverSubheading),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. Priyanka’s Graduation, Tezpur Veranda',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSoft),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Relation / Context
            const Text('Relation or Context', style: AppTypography.caregiverSubheading),
            const SizedBox(height: 6),
            TextField(
              controller: _contextController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Eldest daughter wearing muga silk sari on her special day',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSoft),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Media attachment placeholder
            CalmCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _type == MemoryType.music ? Icons.audio_file_outlined : Icons.image_outlined,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hasPlaceholderMedia ? 'Sample media attached' : 'No media selected',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const Text(
                          'Local demo media safe for offline display',
                          style: AppTypography.caregiverCaption,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _hasPlaceholderMedia = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Media selected safely from device.')),
                      );
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElderButton(
              label: isEditing ? 'Save Changes' : 'Add to Memory Space',
              icon: Icons.check,
              variant: ElderButtonVariant.primary,
              height: 52,
              onPressed: _saveItem,
            ),
          ],
        ),
      ),
    );
  }
}

/// Preview dialog for inspecting a personal memory item in detail.
class _MemoryDetailPreviewDialog extends StatelessWidget {
  final MemoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemoryDetailPreviewDialog({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundWarm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceWarm,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.type == MemoryType.music ? Icons.music_note : Icons.photo_library,
                      color: AppColors.forestPrimary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.title, style: AppTypography.patientTitle),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Placeholder media preview container
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.type == MemoryType.music ? Icons.album_outlined : Icons.image,
                      size: 54,
                      color: AppColors.sage,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.typeLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (item.relationOrContext != null) ...[
                const Text('Story & Context:', style: AppTypography.caregiverSubheading),
                const SizedBox(height: 4),
                Text(item.relationOrContext!, style: AppTypography.caregiverBody),
                const SizedBox(height: 16),
              ],

              const Text('Where this item can appear:', style: AppTypography.caregiverSubheading),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: item.activityUsageLabels.map((usage) {
                  return Chip(
                    backgroundColor: AppColors.surfaceWarm,
                    label: Text(usage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElderButton(
                      label: 'Edit',
                      icon: Icons.edit,
                      variant: ElderButtonVariant.secondary,
                      height: 48,
                      onPressed: onEdit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElderButton(
                      label: 'Remove',
                      icon: Icons.delete_outline,
                      variant: ElderButtonVariant.peach,
                      height: 48,
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
