import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'forum_page.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _currentIndex = 0;
  
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _npmController = TextEditingController();
  final _prodiController = TextEditingController();
  final _kelasController = TextEditingController();
  final _jkController = TextEditingController();

  final List<String> _listProdi = [
    "Informatika",
    "Teknologi Pangan",
    "Teknik Mesin",
    "Teknik Sipil",
    "Teknik Elektro",
  ];

  final List<String> _listKelas = ["A", "B", "C", "D"];
  final List<String> _listJK = ["Laki-Laki", "Perempuan"];

  String? _selectedProdi;
  String? _selectedKelas;
  String? _selectedJK;

  final List<Map<String, String>> _mahasiswaList = [];
  int? _editIndex;

  final Color _primaryColor = const Color.fromARGB(255, 240, 98, 146);

  void _resetForm() {
    _namaController.clear();
    _alamatController.clear();
    _npmController.clear();
    _prodiController.clear();
    _kelasController.clear();
    _jkController.clear();

    _selectedProdi = null;
    _selectedKelas = null;
    _selectedJK = null;
    _editIndex = null;

    setState(() {});
  }

  void _saveMahasiswa() {
    if (_namaController.text.isEmpty || _npmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nama dan NPM wajib diisi!"),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    setState(() {
      Map<String, String> mahasiswa = {
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'npm': _npmController.text,
        'prodi': _prodiController.text,
        'kelas': _kelasController.text,
        'jk': _jkController.text,
      };

      if (_editIndex != null) {
        _mahasiswaList[_editIndex!] = mahasiswa;
      } else {
        _mahasiswaList.add(mahasiswa);
      }
    });

    _resetForm();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editIndex != null
            ? "Data berhasil diupdate!"
            : "Data berhasil ditambahkan!"),
        backgroundColor: Colors.green.shade400,
      ),
    );
  }

  void _editMahasiswa(int index) {
    setState(() {
      _editIndex = index;
      Map<String, String> mhs = _mahasiswaList[index];

      _namaController.text = mhs['nama']!;
      _alamatController.text = mhs['alamat']!;
      _npmController.text = mhs['npm']!;
      _prodiController.text = mhs['prodi']!;
      _kelasController.text = mhs['kelas']!;
      _jkController.text = mhs['jk']!;

      _selectedProdi = mhs['prodi']!.isEmpty ? null : mhs['prodi'];
      _selectedKelas = mhs['kelas']!.isEmpty ? null : mhs['kelas'];
      _selectedJK = mhs['jk']!.isEmpty ? null : mhs['jk'];
    });

    _showFormDialog();
  }

  void _deleteMahasiswa(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _mahasiswaList.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Data berhasil dihapus!"),
                  backgroundColor: Colors.orange.shade400,
                ),
              );
            },
            child: Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showFormDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFormPage(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return ForumPage();
      case 2:
        return _buildProfilePage();
      case 3:
        return _buildDataPage();
      default:
        return _buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        body: _getPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: "Forum",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              label: "Data",
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: FloatingNavBar(
        hapticFeedback: true,
        horizontalPadding: 20,
        color: _primaryColor,
        selectedIconColor: Colors.white,
        unselectedIconColor: Colors.white70,
        items: [
          FloatingNavBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/home.png"),
            ),
            title: "Beranda",
            page: _buildHomePage(),
          ),
          FloatingNavBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/group.png"),
            ),
            title: "Forum",
            page: ForumPage(),
          ),
          FloatingNavBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/user.png"),
            ),
            title: "Profil",
            page: _buildProfilePage(),
          ),
          FloatingNavBarItem(
            icon: const ImageIcon(AssetImage("assets/icons/data.png")),
            title: "Data",
            page: _buildDataPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  "Aplikasi Kemahasiswaan",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Kelola data mahasiswa dengan mudah",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                // Stats Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        Icons.people,
                        _mahasiswaList.length.toString(),
                        "Mahasiswa",
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildStatItem(
                        Icons.school,
                        _listProdi.length.toString(),
                        "Program Studi",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with avatar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
                ),
              ),
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Admin User",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Administrator",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Info Cards
                  _buildProfileInfoCard(
                    icon: Icons.email,
                    title: "Email",
                    value: "admin@example.com",
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInfoCard(
                    icon: Icons.phone,
                    title: "Telepon",
                    value: "+62 812-3456-7890",
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInfoCard(
                    icon: Icons.location_on,
                    title: "Lokasi",
                    value: "Semarang, Central Java",
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInfoCard(
                    icon: Icons.school,
                    title: "Institusi",
                    value: "Universitas XYZ",
                    color: Colors.purple,
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  _buildActionButton(
                    icon: Icons.edit,
                    label: "Edit Profil",
                    color: _primaryColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fitur Edit Profil")),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.lock,
                    label: "Ubah Password",
                    color: Colors.indigo,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fitur Ubah Password")),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.settings,
                    label: "Pengaturan",
                    color: Colors.teal,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fitur Pengaturan")),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.logout,
                    label: "Keluar",
                    color: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Keluar"),
                          content: const Text("Apakah Anda yakin ingin keluar?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Berhasil keluar")),
                                );
                              },
                              child: const Text(
                                "Keluar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Daftar Mahasiswa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: _mahasiswaList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data mahasiswa",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tekan tombol + untuk menambah data",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mahasiswaList.length,
              itemBuilder: (context, index) {
                Map<String, String> mhs = _mahasiswaList[index];
                String initial = mhs['nama']!.isNotEmpty
                    ? mhs['nama']![0].toUpperCase()
                    : "?";

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _primaryColor,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      mhs['nama']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("NPM: ${mhs['npm']}"),
                        if (mhs['prodi']!.isNotEmpty)
                          Text("${mhs['prodi']} - Kelas ${mhs['kelas']}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editMahasiswa(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMahasiswa(index),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showDetailDialog(mhs);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () {
          _resetForm();
          _showFormDialog();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDetailDialog(Map<String, String> mhs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _primaryColor,
              child: Text(
                mhs['nama']![0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mhs['nama']!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem(Icons.badge_outlined, "NPM", mhs['npm']!),
              _buildDetailItem(Icons.school_outlined, "Program Studi",
                  mhs['prodi']!.isEmpty ? "-" : mhs['prodi']!),
              _buildDetailItem(Icons.class_outlined, "Kelas",
                  mhs['kelas']!.isEmpty ? "-" : mhs['kelas']!),
              _buildDetailItem(Icons.wc_outlined, "Jenis Kelamin",
                  mhs['jk']!.isEmpty ? "-" : mhs['jk']!),
              _buildDetailItem(Icons.location_on_outlined, "Alamat",
                  mhs['alamat']!.isEmpty ? "-" : mhs['alamat']!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: _primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _editIndex != null ? "Edit Mahasiswa" : "Tambah Mahasiswa",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _resetForm();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildInput(_namaController, "Nama Lengkap", Icons.person),
                  buildInput(_alamatController, "Alamat Domisili",
                      Icons.location_on_outlined),
                  buildInput(_npmController, "NPM", Icons.badge_outlined,
                      isNumber: true),
                  const SizedBox(height: 5),
                  buildDropdown(
                    label: "Program Studi",
                    value: _selectedProdi,
                    items: _listProdi,
                    icon: Icons.school_outlined,
                    onChange: (val) {
                      setState(() {
                        _selectedProdi = val;
                        _prodiController.text = val ?? "";
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildDropdown(
                          label: "Kelas",
                          value: _selectedKelas,
                          items: _listKelas,
                          icon: Icons.class_outlined,
                          onChange: (val) {
                            setState(() {
                              _selectedKelas = val;
                              _kelasController.text = val ?? "";
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: buildDropdown(
                          label: "Gender",
                          value: _selectedJK,
                          items: _listJK,
                          icon: Icons.wc_outlined,
                          onChange: (val) {
                            setState(() {
                              _selectedJK = val;
                              _jkController.text = val ?? "";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _saveMahasiswa,
                      child: Text(
                        _editIndex != null ? "UPDATE DATA" : "SIMPAN DATA",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput(TextEditingController c, String label, IconData icon,
      {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChange,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChange,
      ),
    );
  }
}