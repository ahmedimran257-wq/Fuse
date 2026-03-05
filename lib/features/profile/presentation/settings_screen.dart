import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Account?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your posts, time donated, and data will be destroyed.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'DELETE',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // User profile header
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surfaceElevated,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? 'User',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Member since ${_formatDate(user?.createdAt)}',
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Preferences section
          _buildSectionHeader('PREFERENCES'),
          _buildListTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            trailing: const _NotificationToggle(),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('LEGAL & COMPLIANCE'),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _launchURL('https://fuse.app/privacy'),
          ),
          _buildListTile(
            icon: Icons.gavel,
            title: 'Terms of Service',
            onTap: () => _launchURL('https://fuse.app/terms'),
          ),
          _buildListTile(
            icon: Icons.rule,
            title: 'Community Guidelines',
            onTap: () => _launchURL('https://fuse.app/guidelines'),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('ACCOUNT'),
          _buildListTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            color: AppColors.timerWarning,
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
          _buildListTile(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            color: AppColors.danger,
            onTap: () => _confirmDeleteAccount(context, ref),
          ),

          // App version
          const SizedBox(height: 40),
          Center(
            child: Text(
              'FUSE v1.0.0',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'recently';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return 'recently';
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color color = const Color(0xFFF5F5F7),
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(title, style: TextStyle(color: color, fontSize: 15)),
      trailing:
          trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}

class _NotificationToggle extends StatefulWidget {
  const _NotificationToggle();

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (mounted) {
      setState(() {
        _notificationsEnabled =
            settings.authorizationStatus == AuthorizationStatus.authorized;
      });
    }
  }

  Future<void> _toggle(bool value) async {
    if (value) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (mounted) {
        setState(() {
          _notificationsEnabled =
              settings.authorizationStatus == AuthorizationStatus.authorized;
        });
        if (settings.authorizationStatus != AuthorizationStatus.authorized) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable notifications in system settings'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disable notifications in system settings'),
        ),
      );
      if (mounted) {
        setState(() => _notificationsEnabled = false); // Optimistic UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _notificationsEnabled,
      activeTrackColor: AppColors.accent,
      onChanged: _toggle,
    );
  }
}
