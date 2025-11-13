import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import '../models/avatar_config.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/avatar_preview.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final nameController = TextEditingController(text: userProvider.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.colors.background,
        title: Text(
          'Edit Nama',
          style: context.theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: context.theme.colors.foreground,
          ),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: TextStyle(color: context.theme.colors.foreground),
          decoration: InputDecoration(
            labelText: 'Nama',
            labelStyle: TextStyle(color: context.theme.colors.mutedForeground),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.theme.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.theme.colors.primary,
                width: 2,
              ),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: context.theme.colors.mutedForeground),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<UserProvider>().updateUserName(
                  nameController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.colors.primary,
              foregroundColor: context.theme.colors.primaryForeground,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final avatarConfig = userProvider.avatarConfig;

    return Scaffold(
      backgroundColor: context.theme.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil',
                style: context.theme.typography.xl3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colors.foreground,
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    AvatarPreview(config: avatarConfig, size: 110),
                    const SizedBox(height: 16),
                    Text(
                      userProvider.userName,
                      style: context.theme.typography.xl.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.theme.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _showEditAvatarSheet(context),
                      child: Text(
                        'Edit Avatar',
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showEditNameDialog(context),
                      child: Text(
                        'Edit Nama',
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Pengaturan',
                style: context.theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.theme.colors.foreground,
                ),
              ),
              const SizedBox(height: 12),

              FCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: context.theme.colors.foreground,
                      ),
                      title: Text(
                        'Mode Gelap',
                        style: context.theme.typography.base.copyWith(
                          color: context.theme.colors.foreground,
                        ),
                      ),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (_) => themeProvider.toggleTheme(),
                        activeTrackColor: context.theme.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Tentang',
                style: context.theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.theme.colors.foreground,
                ),
              ),
              const SizedBox(height: 12),

              FCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: context.theme.colors.foreground,
                      ),
                      title: Text(
                        'Tentang Aplikasi',
                        style: context.theme.typography.base.copyWith(
                          color: context.theme.colors.foreground,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: context.theme.colors.mutedForeground,
                      ),
                      onTap: () => _showAboutDialog(context),
                    ),
                    Divider(height: 1, color: context.theme.colors.border),
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: context.theme.colors.foreground,
                      ),
                      title: Text(
                        'Bantuan',
                        style: context.theme.typography.base.copyWith(
                          color: context.theme.colors.foreground,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: context.theme.colors.mutedForeground,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Halaman bantuan akan segera hadir'),
                            backgroundColor: context.theme.colors.muted,
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: context.theme.colors.border),
                    ListTile(
                      leading: Icon(
                        Icons.privacy_tip_outlined,
                        color: context.theme.colors.foreground,
                      ),
                      title: Text(
                        'Kebijakan Privasi',
                        style: context.theme.typography.base.copyWith(
                          color: context.theme.colors.foreground,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: context.theme.colors.mutedForeground,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Kebijakan privasi akan segera hadir',
                            ),
                            backgroundColor: context.theme.colors.muted,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  'DompetKuy v1.0.0',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.colors.background,
        title: Text(
          'Tentang DompetKuy',
          style: context.theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: context.theme.colors.foreground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DompetKuy adalah aplikasi pengelola keuangan pribadi yang membantu Anda mencatat transaksi dan mencapai target tabungan.',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.foreground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Versi: 1.0.0',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
            Text(
              'Build: 1',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: TextStyle(color: context.theme.colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditAvatarSheet(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final theme = context.theme;
    var tempConfig = userProvider.avatarConfig;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: AvatarPreview(config: tempConfig, size: 140)),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            tempConfig = AvatarConfig.random();
                          });
                        },
                        icon: const Icon(Icons.casino_outlined),
                        label: const Text('Acak'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colors.primary,
                        ),
                      ),
                    ),
                    _buildSectionTitle('Warna Latar', context),
                    _buildColorSelector(
                      context: context,
                      palette: AvatarConfig.backgroundPalette,
                      selected: tempConfig.backgroundColor,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(
                            backgroundColor: value,
                          );
                        });
                      },
                    ),
                    _buildSectionTitle('Warna Kulit', context),
                    _buildColorSelector(
                      context: context,
                      palette: AvatarConfig.facePalette,
                      selected: tempConfig.faceColor,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(faceColor: value);
                        });
                      },
                    ),
                    _buildSectionTitle('Warna Rambut', context),
                    _buildColorSelector(
                      context: context,
                      palette: AvatarConfig.hairPalette,
                      selected: tempConfig.hairColor,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(hairColor: value);
                        });
                      },
                    ),
                    _buildSectionTitle('Gaya Rambut', context),
                    _buildStyleSelector<AvatarHairStyle>(
                      context: context,
                      options: AvatarHairStyle.values,
                      selected: tempConfig.hairStyle,
                      labelBuilder: _hairLabel,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(hairStyle: value);
                        });
                      },
                    ),
                    _buildSectionTitle('Mata', context),
                    _buildStyleSelector<AvatarEyeStyle>(
                      context: context,
                      options: AvatarEyeStyle.values,
                      selected: tempConfig.eyeStyle,
                      labelBuilder: _eyeLabel,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(eyeStyle: value);
                        });
                      },
                    ),
                    _buildSectionTitle('Mulut', context),
                    _buildStyleSelector<AvatarMouthStyle>(
                      context: context,
                      options: AvatarMouthStyle.values,
                      selected: tempConfig.mouthStyle,
                      labelBuilder: _mouthLabel,
                      onSelect: (value) {
                        setState(() {
                          tempConfig = tempConfig.copyWith(mouthStyle: value);
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colors.mutedForeground,
                              side: BorderSide(color: theme.colors.border),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context
                                  .read<UserProvider>()
                                  .updateAvatarConfig(tempConfig);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colors.primary,
                              foregroundColor: theme.colors.primaryForeground,
                            ),
                            child: const Text('Simpan'),
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
      },
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: context.theme.typography.base.copyWith(
          fontWeight: FontWeight.w600,
          color: context.theme.colors.foreground,
        ),
      ),
    );
  }

  Widget _buildColorSelector({
    required BuildContext context,
    required List<String> palette,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final color in palette)
          GestureDetector(
            onTap: () => onSelect(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorFromHex(color),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color == selected
                      ? context.theme.colors.primary
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: color == selected
                  ? Icon(
                      Icons.check,
                      color: context.theme.colors.primaryForeground,
                      size: 20,
                    )
                  : null,
            ),
          ),
      ],
    );
  }

  Widget _buildStyleSelector<T>({
    required BuildContext context,
    required Iterable<T> options,
    required T selected,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onSelect,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(
              labelBuilder(option),
              style: context.theme.typography.sm.copyWith(
                color: option == selected
                    ? context.theme.colors.primary
                    : context.theme.colors.foreground,
                fontWeight: option == selected
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
            selected: option == selected,
            onSelected: (_) => onSelect(option),
            selectedColor: context.theme.colors.primary.withValues(alpha: 0.12),
            backgroundColor: context.theme.colors.muted,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: option == selected
                    ? context.theme.colors.primary
                    : context.theme.colors.border,
              ),
            ),
          ),
      ],
    );
  }

  Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String _hairLabel(AvatarHairStyle style) {
    switch (style) {
      case AvatarHairStyle.none:
        return 'Botak';
      case AvatarHairStyle.short:
        return 'Pendek';
      case AvatarHairStyle.wave:
        return 'Wavy';
      case AvatarHairStyle.bun:
        return 'Konde';
      case AvatarHairStyle.buzz:
        return 'Cepak';
    }
  }

  String _eyeLabel(AvatarEyeStyle style) {
    switch (style) {
      case AvatarEyeStyle.round:
        return 'Round';
      case AvatarEyeStyle.happy:
        return 'Happy';
      case AvatarEyeStyle.wink:
        return 'Wink';
    }
  }

  String _mouthLabel(AvatarMouthStyle style) {
    switch (style) {
      case AvatarMouthStyle.smile:
        return 'Smile';
      case AvatarMouthStyle.grin:
        return 'Grin';
      case AvatarMouthStyle.surprised:
        return 'Surprise';
    }
  }
}
