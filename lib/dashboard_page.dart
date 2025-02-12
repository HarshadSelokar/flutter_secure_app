import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'credential_list_page.dart';
import 'file_storage_page.dart';
import 'settings_page.dart';
import 'utils/theme_provider.dart';
import 'utils/page_transitions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isGridView = true; // Toggle between Grid & List View

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          /// ✅ Toggle Grid/List View
          IconButton(
            icon: Icon(_isGridView ? Icons.grid_view : Icons.list),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ).animate().fade(duration: 400.ms),

          /// ✅ Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, SlidePageRoute(page: const SettingsPage()));
            },
          ).animate().fade(duration: 500.ms),
        ],
      ),
      body: Stack(
        children: [
          /// ✅ Background Gradient
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.isDarkMode
                    ? [Colors.black, Colors.grey[900]!]
                    : [Colors.blueAccent, Colors.lightBlue[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 20),

              /// ✅ Animated Welcome Message
              const Text(
                "Welcome to Your Secure Dashboard!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fade(duration: 600.ms).slideY(begin: -0.5, end: 0),

              const SizedBox(height: 20),

              /// ✅ Dashboard Options (Grid/List Toggle)
              Expanded(
                child: _isGridView ? _buildGridView() : _buildListView(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Grid View
  Widget _buildGridView() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(
          label: "Manage Credentials",
          icon: Icons.lock,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const CredentialListPage()));
          },
        ),
        _buildDashboardCard(
          label: "Manage Files",
          icon: Icons.folder,
          color: Colors.green,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const FileStoragePage()));
          },
        ),
        _buildDashboardCard(
          label: "Backup Data",
          icon: Icons.backup,
          color: Colors.orange,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Backup Started...")),
            );
          },
        ),
        _buildDashboardCard(
          label: "Settings",
          icon: Icons.settings,
          color: Colors.purple,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const SettingsPage()));
          },
        ),
      ],
    ).animate().fade(duration: 700.ms).slideY(begin: 0.5, end: 0);
  }

  /// ✅ List View
  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildListTile(
          label: "Manage Credentials",
          icon: Icons.lock,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const CredentialListPage()));
          },
        ),
        _buildListTile(
          label: "Manage Files",
          icon: Icons.folder,
          color: Colors.green,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const FileStoragePage()));
          },
        ),
        _buildListTile(
          label: "Backup Data",
          icon: Icons.backup,
          color: Colors.orange,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Backup Started...")),
            );
          },
        ),
        _buildListTile(
          label: "Settings",
          icon: Icons.settings,
          color: Colors.purple,
          onTap: () {
            Navigator.push(context, SlidePageRoute(page: const SettingsPage()));
          },
        ),
      ],
    ).animate().fade(duration: 700.ms).slideY(begin: 0.5, end: 0);
  }

  /// ✅ Animated Grid Card
  Widget _buildDashboardCard({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50).animate().scale(duration: 500.ms),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ).animate().fade(duration: 600.ms),
          ],
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOut);
  }

  /// ✅ Animated List Tile
  Widget _buildListTile({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 40),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    ).animate().fade(duration: 500.ms).slideX(begin: -0.5, end: 0);
  }
}
