import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masjid_berhasil/model/admin/news_model.dart';
import 'package:masjid_berhasil/provider/user/news_provider.dart';
import 'package:masjid_berhasil/views/admin/news_form.dart';

class BeritaListScreen extends StatefulWidget {
  const BeritaListScreen({super.key});

  @override
  State<BeritaListScreen> createState() => _BeritaListScreenState();
}

class _BeritaListScreenState extends State<BeritaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Berita Masjid")),

      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          final beritaList = provider.newsList;

          if (beritaList.isEmpty) {
            return const Center(child: Text("Belum ada berita"));
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              itemCount: beritaList.length,
              itemBuilder: (context, index) {
                final berita = beritaList[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// FOTO BERITA
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: (berita.foto.isNotEmpty)
                            ? Image.network(
                                berita.foto,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 180,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image, size: 40),
                                ),
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// JUDUL
                            Text(
                              berita.judul,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// CLICKBAIT
                            Text(
                              berita.clickbait,
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            /// TANGGAL
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 5),
                                Text(berita.tanggal),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// BUTTON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                /// EDIT
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FormBerita(berita: berita),
                                      ),
                                    );
                                  },
                                ),

                                /// DELETE
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    provider.deleteNews(berita.id!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),

      /// TAMBAH BERITA
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormBerita()),
          );
        },
      ),
    );
  }
}
