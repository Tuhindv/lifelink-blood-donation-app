
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LifeLinkApp());
}

class LifeLinkApp extends StatelessWidget {
  const LifeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      ),
      home: const AuthGate(),
    );
  }
}

// --------------------------------------------------
// AUTH GATE
// --------------------------------------------------

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        return const AuthScreen();
      },
    );
  }
}

// --------------------------------------------------
// DASHBOARD
// --------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Logout failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LifeLink',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'My Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Donate Blood, Save Lives!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome ${user?.displayName ?? user?.email ?? "User"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your one donation can make a difference.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.search,
              title: 'Find Blood Donors',
              subtitle: 'Search by blood group and district',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FindDonorsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.volunteer_activism,
              title: 'Become a Donor',
              subtitle: 'Register or update donor information',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BecomeDonorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.person,
              title: 'My Profile',
              subtitle: 'Manage your donor information',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 17),
        onTap: onTap,
      ),
    );
  }
}

// --------------------------------------------------
// BECOME / UPDATE DONOR
// --------------------------------------------------

class BecomeDonorScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const BecomeDonorScreen({
    super.key,
    this.initialData,
  });

  @override
  State<BecomeDonorScreen> createState() =>
      _BecomeDonorScreenState();
}

class _BecomeDonorScreenState extends State<BecomeDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _districtController = TextEditingController();

  String? _bloodGroup;
  bool _available = true;
  bool _shareContact = false;
  bool _loading = false;
  bool _initialized = false;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-',
    'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeForm();
  }

  void _initializeForm() {
    if (_initialized) return;
    _initialized = true;

    final data = widget.initialData;
    if (data == null) return;

    _nameController.text = (data['fullName'] ?? '').toString();
    _mobileController.text = (data['mobile'] ?? '').toString();
    _districtController.text = (data['district'] ?? '').toString();

    final savedGroup = data['bloodGroup']?.toString();
    if (_bloodGroups.contains(savedGroup)) {
      _bloodGroup = savedGroup;
    }

    _available = data['availability'] is bool
        ? data['availability'] as bool
        : true;

    _shareContact = data['shareContact'] == true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _saveDonor() async {
    if (!_formKey.currentState!.validate()) return;

    if (_bloodGroup == null) {
      _showMessage(context, 'Please select your blood group.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(context, 'Please login first.');
      return;
    }

    setState(() => _loading = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final uid = user.uid;

      final donorRef = firestore.collection('donors').doc(uid);
      final publicRef = firestore.collection('publicDonors').doc(uid);

      final existingDonor = await donorRef.get();
      final existingData = existingDonor.data();

      // Private donor data.
      final donorData = <String, dynamic>{
        'uid': uid,
        'fullName': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'bloodGroup': _bloodGroup,
        'district': _districtController.text.trim(),
        'availability': _available,
        'shareContact': _shareContact,
        'createdAt': existingData?['createdAt'] ??
            FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await donorRef.set(
        donorData,
        SetOptions(merge: true),
      );

      if (_available) {
        // Replace the public document so an old mobile number
        // is removed when the donor withdraws consent.
        final publicData = <String, dynamic>{
          'uid': uid,
          'fullName': _nameController.text.trim(),
          'bloodGroup': _bloodGroup,
          'district': _districtController.text.trim(),
          'availability': true,
          'shareContact': _shareContact,
          'createdAt': existingData?['createdAt'] ??
              FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (_shareContact) {
          publicData['mobile'] = _mobileController.text.trim();
        }

        await publicRef.set(publicData);
      } else {
        // Unavailable donors should not appear in search.
        await publicRef.delete();
      }

      if (!mounted) return;

      _showMessage(context, 'Donor information saved successfully!');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        _showMessage(context, 'Could not save donor: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialData == null
              ? 'Become a Donor'
              : 'Update Donor Information',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(
                Icons.volunteer_activism,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your mobile number';
                  }
                  if (value.trim().length < 8) {
                    return 'Enter a valid mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _bloodGroup,
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                items: _bloodGroups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _bloodGroup = value);
                },
                validator: (value) =>
                    value == null ? 'Select blood group' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'District',
                  hintText: 'e.g. Dhaka, Gopalganj',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your district'
                        : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available to Donate'),
                subtitle: const Text(
                  'Show your profile in donor search',
                ),
                value: _available,
                onChanged: (value) {
                  setState(() => _available = value);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Allow my mobile number to be shared'),
                subtitle: const Text(
                  'If enabled, your number can be read by signed-in '
                  'users searching donor profiles.',
                ),
                value: _shareContact,
                onChanged: (value) {
                  setState(() => _shareContact = value ?? false);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _saveDonor,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _loading ? 'Saving...' : 'Save Donor Information',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// FIND DONORS
// --------------------------------------------------

class FindDonorsScreen extends StatefulWidget {
  const FindDonorsScreen({super.key});

  @override
  State<FindDonorsScreen> createState() => _FindDonorsScreenState();
}

class _FindDonorsScreenState extends State<FindDonorsScreen> {
  String? _selectedBloodGroup;
  final _districtController = TextEditingController();

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-',
    'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void dispose() {
    _districtController.dispose();
    super.dispose();
  }

  Query<Map<String, dynamic>> _buildQuery() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('publicDonors');

    if (_selectedBloodGroup != null) {
      query = query.where(
        'bloodGroup',
        isEqualTo: _selectedBloodGroup,
      );
    }

    return query.where('availability', isEqualTo: true);
  }

  @override
  Widget build(BuildContext context) {
    final district =
        _districtController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Find Blood Donors')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: _selectedBloodGroup,
                  decoration: const InputDecoration(
                    labelText: 'Select Blood Group',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bloodtype),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Blood Groups'),
                    ),
                    ..._bloodGroups.map(
                      (group) => DropdownMenuItem<String?>(
                        value: group,
                        child: Text(group),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedBloodGroup = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: 'District',
                    hintText: 'Enter district name',
                    prefixIcon: const Icon(Icons.location_on),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _districtController.clear();
                        setState(() {});
                      },
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unable to load donors. Check Firestore rules.',
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final donors = snapshot.data?.docs ?? [];

                final filteredDonors = donors.where((doc) {
                  final data = doc.data();
                  final donorDistrict = (data['district'] ?? '')
                      .toString()
                      .trim()
                      .toLowerCase();

                  return district.isEmpty ||
                      donorDistrict == district;
                }).toList();

                // Newest profiles first.
                filteredDonors.sort((a, b) {
                  final aCreatedAt = a.data()['createdAt'];
                  final bCreatedAt = b.data()['createdAt'];

                  final aDate = aCreatedAt is Timestamp
                      ? aCreatedAt
                      : Timestamp.fromMillisecondsSinceEpoch(0);

                  final bDate = bCreatedAt is Timestamp
                      ? bCreatedAt
                      : Timestamp.fromMillisecondsSinceEpoch(0);

                  return bDate.compareTo(aDate);
                });

                if (filteredDonors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text('No matching donors found.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredDonors.length,
                  itemBuilder: (context, index) {
                    final data = filteredDonors[index].data();

                    final name =
                        (data['fullName'] ?? 'Donor').toString();
                    final bloodGroup =
                        (data['bloodGroup'] ?? '').toString();
                    final donorDistrict =
                        (data['district'] ?? '').toString();

                    final shareContact =
                        data['shareContact'] == true;
                    final mobile = shareContact
                        ? (data['mobile'] ?? '').toString()
                        : '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.red.shade50,
                              child: Text(
                                bloodGroup,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('District: $donorDistrict'),
                                  const SizedBox(height: 6),
                                  if (shareContact && mobile.isNotEmpty)
                                    SelectableText(
                                      'Mobile: $mobile',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  else
                                    const Text(
                                      'Mobile number is private',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// MY PROFILE
// --------------------------------------------------

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('donors')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load your profile.'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You have not registered as a donor yet.',
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BecomeDonorScreen(),
                          ),
                        );
                      },
                      child: const Text('Become a Donor'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!.data()!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const CircleAvatar(
                radius: 42,
                child: Icon(Icons.person, size: 42),
              ),
              const SizedBox(height: 20),
              _ProfileItem(
                label: 'Full Name',
                value: data['fullName'] ?? '',
              ),
              _ProfileItem(
                label: 'Mobile',
                value: data['mobile'] ?? '',
              ),
              _ProfileItem(
                label: 'Blood Group',
                value: data['bloodGroup'] ?? '',
              ),
              _ProfileItem(
                label: 'District',
                value: data['district'] ?? '',
              ),
              _ProfileItem(
                label: 'Available to Donate',
                value: data['availability'] == true ? 'Yes' : 'No',
              ),
              _ProfileItem(
                label: 'Share Mobile Number',
                value: data['shareContact'] == true ? 'Yes' : 'No',
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BecomeDonorScreen(
                        initialData: Map<String, dynamic>.from(data),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Update Donor Information'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final dynamic value;

  const _ProfileItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SHARED MESSAGE HELPER
// --------------------------------------------------

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
