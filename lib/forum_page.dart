import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final Color _primaryColor = const Color.fromARGB(255, 240, 98, 146);

  final List<Map<String, String>> _posts = [];
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  int? _editIndex;

  void _showPostDialog({bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isEdit ? "Edit Postingan" : "Tambah Postingan",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: "Judul",
                  prefixIcon: Icon(Icons.title, color: _primaryColor),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _isiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Isi Postingan",
                  prefixIcon:
                      Icon(Icons.chat_bubble_outline, color: _primaryColor),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _judulController.clear();
                _isiController.clear();
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
              onPressed: () {
                if (_judulController.text.isEmpty ||
                    _isiController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Judul dan isi wajib diisi!"),
                      backgroundColor: Colors.red.shade400,
                    ),
                  );
                  return;
                }

                setState(() {
                  if (isEdit) {
                    _posts[_editIndex!] = {
                      "judul": _judulController.text,
                      "isi": _isiController.text,
                    };
                  } else {
                    _posts.add({
                      "judul": _judulController.text,
                      "isi": _isiController.text,
                    });
                  }
                });

                _judulController.clear();
                _isiController.clear();

                Navigator.pop(context);
              },
              child: Text(
                isEdit ? "Update" : "Simpan",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editPost(int index) {
    _editIndex = index;
    _judulController.text = _posts[index]["judul"]!;
    _isiController.text = _posts[index]["isi"]!;
    _showPostDialog(isEdit: true);
  }

  void _deletePost(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Postingan"),
        content:
            const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              setState(() {
                _posts.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Forum Diskusi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _primaryColor,
        elevation: 2,
      ),
      body: _posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    "Belum ada postingan",
                    style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Tekan tombol + untuk menambah posting",
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _posts.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    title: Text(
                      post["judul"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(post["isi"]!),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.edit, color: Colors.blue.shade600),
                          onPressed: () => _editPost(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePost(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showPostDialog(),
      ),
    );
  }
}
