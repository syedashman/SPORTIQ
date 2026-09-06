import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/surfaces/app_avatar.dart';

const List<String> _availableSports = ['Cricket', 'Football', 'Padel'];

const List<String> _defaultInterests = [
  'Analytics',
  'Endurance',
  'Strength',
  'Recovery',
  'Mental Edge',
  'Nutrition',
];

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String? _primarySport;

  final Set<String> _selectedSports = <String>{};
  final Set<String> _selectedInterests = <String>{};

  final List<String> _customSports = <String>[];
  final List<String> _customInterests = <String>[];

  Uint8List? _profileImageBytes;
  bool _isPickingImage = false;

  List<String> get _allSports => [..._availableSports, ..._customSports];

  List<String> get _allInterests => [..._defaultInterests, ..._customInterests];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _continue() {
    context.push('/choose-sport');
  }

  Future<void> _showProfilePhotoOptions() async {
    if (_isPickingImage) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Profile Photo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Choose how you want to add your profile picture.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                _PhotoOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from Gallery',
                  subtitle: 'Select a photo from your device',
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();
                    _pickProfileImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _PhotoOptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Use your device camera',
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();
                    _pickProfileImage(ImageSource.camera);
                  },
                ),
                if (_profileImageBytes != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _PhotoOptionTile(
                    icon: Icons.delete_outline,
                    title: 'Remove Photo',
                    subtitle: 'Use the default profile image',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(bottomSheetContext).pop();

                      setState(() {
                        _profileImageBytes = null;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    if (_isPickingImage) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? selectedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (selectedImage == null) {
        return;
      }

      final Uint8List imageBytes = await selectedImage.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _profileImageBytes = imageBytes;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Camera is not available on this device. Try choosing a photo from the gallery.'
                : 'Unable to select this photo. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _showAddCustomSportDialog() async {
    final TextEditingController controller = TextEditingController();

    final String? customSport = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Custom Sport'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 30,
            decoration: const InputDecoration(hintText: 'Example: Badminton'),
            onSubmitted: (value) {
              final String sport = value.trim();

              if (sport.isNotEmpty) {
                Navigator.of(dialogContext).pop(sport);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String sport = controller.text.trim();

                if (sport.isNotEmpty) {
                  Navigator.of(dialogContext).pop(sport);
                }
              },
              child: const Text('Add Sport'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (customSport == null || customSport.trim().isEmpty) {
      return;
    }

    final String formattedSport = _formatCustomValue(customSport);

    final bool alreadyExists = _allSports.any(
      (sport) => sport.toLowerCase() == formattedSport.toLowerCase(),
    );

    if (alreadyExists) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This sport has already been added.')),
      );

      return;
    }

    setState(() {
      _customSports.add(formattedSport);
      _selectedSports.add(formattedSport);
    });
  }

  Future<void> _showAddCustomInterestDialog() async {
    final TextEditingController controller = TextEditingController();

    final String? customInterest = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Custom Interest'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 30,
            decoration: const InputDecoration(hintText: 'Example: Agility'),
            onSubmitted: (value) {
              final String interest = value.trim();

              if (interest.isNotEmpty) {
                Navigator.of(dialogContext).pop(interest);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String interest = controller.text.trim();

                if (interest.isNotEmpty) {
                  Navigator.of(dialogContext).pop(interest);
                }
              },
              child: const Text('Add Interest'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (customInterest == null || customInterest.trim().isEmpty) {
      return;
    }

    final String formattedInterest = _formatCustomValue(customInterest);

    final bool alreadyExists = _allInterests.any(
      (interest) => interest.toLowerCase() == formattedInterest.toLowerCase(),
    );

    if (alreadyExists) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This interest has already been added.')),
      );

      return;
    }

    setState(() {
      _customInterests.add(formattedInterest);
      _selectedInterests.add(formattedInterest);
    });
  }

  String _formatCustomValue(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word.length == 1
              ? word.toUpperCase()
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  Widget _buildPrimarySportChip(String sport) {
    final bool selected = _primarySport == sport;

    return ChoiceChip(
      label: Text(sport),
      selected: selected,
      showCheckmark: true,
      checkmarkColor: AppColors.onPrimaryContainer,
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? AppColors.onPrimaryContainer
            : AppColors.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
      ),
      onSelected: (_) {
        setState(() {
          _primarySport = sport;
          _selectedSports.add(sport);
        });
      },
    );
  }

  Widget _buildSportChip(String sport) {
    final bool selected = _selectedSports.contains(sport);

    return FilterChip(
      label: Text(sport),
      selected: selected,
      showCheckmark: true,
      checkmarkColor: AppColors.onPrimaryContainer,
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? AppColors.onPrimaryContainer
            : AppColors.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
      ),
      onSelected: (value) {
        setState(() {
          if (value) {
            _selectedSports.add(sport);
          } else {
            _selectedSports.remove(sport);

            if (_primarySport == sport) {
              _primarySport = null;
            }
          }
        });
      },
    );
  }

  Widget _buildInterestChip(String interest) {
    final bool selected = _selectedInterests.contains(interest);

    return FilterChip(
      label: Text(interest),
      selected: selected,
      showCheckmark: true,
      checkmarkColor: AppColors.onPrimaryContainer,
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? AppColors.onPrimaryContainer
            : AppColors.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
      ),
      onSelected: (value) {
        setState(() {
          if (value) {
            _selectedInterests.add(interest);
          } else {
            _selectedInterests.remove(interest);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tell Us About You',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Complete your profile to unlock personalized coaching and competitive insights.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Semantics(
                  button: true,
                  label: 'Add or change profile photo',
                  child: InkWell(
                    onTap: _showProfilePhotoOptions,
                    customBorder: const CircleBorder(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _profileImageBytes == null
                              ? const AppAvatar(
                                  key: ValueKey('default-profile-avatar'),
                                  size: 88,
                                )
                              : Container(
                                  key: const ValueKey(
                                    'selected-profile-avatar',
                                  ),
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.outline,
                                    ),
                                    image: DecorationImage(
                                      image: MemoryImage(_profileImageBytes!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 3,
                              ),
                            ),
                            child: _isPickingImage
                                ? const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.onPrimaryContainer,
                                    ),
                                  )
                                : const Icon(
                                    Icons.photo_camera_outlined,
                                    size: 16,
                                    color: AppColors.onPrimaryContainer,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Display Name',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(controller: _nameController, hint: 'Your name'),
              const SizedBox(height: AppSpacing.md),
              Text('City', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(controller: _cityController, hint: 'Your city'),
              const SizedBox(height: AppSpacing.md),
              Text('Bio', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _bioController,
                hint: 'Tell us a little about yourself',
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Primary Sport',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Select the sport you play most often',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ..._allSports.map(_buildPrimarySportChip),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Custom Sport'),
                    onPressed: _showAddCustomSportDialog,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Other Sports You Play',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'You can select multiple sports',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ..._allSports.map(_buildSportChip),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Add Sport'),
                    onPressed: _showAddCustomSportDialog,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Sports Interests',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose everything you are interested in',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ..._allInterests.map(_buildInterestChip),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Add Interest'),
                    onPressed: _showAddCustomInterestDialog,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Continue', onPressed: _continue),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(label: 'Complete Later', onPressed: _continue),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoOptionTile extends StatelessWidget {
  const _PhotoOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor =
        isDestructive ? Colors.redAccent : Colors.white;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.redAccent.withValues(alpha: 0.12)
                      : AppColors.primaryContainer.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? Colors.redAccent
                      : AppColors.primaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: foregroundColor),
            ],
          ),
        ),
      ),
    );
  }
}
