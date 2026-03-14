import 'package:flutter/material.dart';
import 'package:masjid_berhasil/model/admin/info_kajian_model.dart';
import 'package:masjid_berhasil/views/admin/info_kajian_form.dart';
import 'package:provider/provider.dart';
import 'package:masjid_berhasil/provider/user/event_provider.dart';

class KajianListScreen extends StatefulWidget {
  const KajianListScreen({super.key});

  @override
  State<KajianListScreen> createState() => _KajianListScreenState();
}

class _KajianListScreenState extends State<KajianListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Info Kajian Masjid")),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          final kajianList = provider.kajianList;

          if (kajianList.isEmpty) {
            return const Center(child: Text("Belum ada kajian"));
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
              itemCount: kajianList.length,
              itemBuilder: (context, index) {
                final kajian = kajianList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TIMELINE DOT + LINE
                      Column(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 260,
                            color: Colors.grey.shade100,
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      /// CARD CONTENT
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// POSTER
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                                child: Stack(
                                  children: [
                                    (kajian.poster.isNotEmpty &&
                                            Uri.tryParse(
                                                  kajian.poster,
                                                )?.hasAbsolutePath ==
                                                true)
                                        ? Image.network(
                                            kajian.poster,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 180,
                                            color: Colors.grey.shade300,
                                          ),

                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 14,
                                      left: 14,
                                      right: 14,
                                      child: Text(
                                        kajian.judul,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 14,
                                          child: Icon(Icons.person, size: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          kajian.pemateri,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16),
                                        const SizedBox(width: 6),
                                        Text(kajian.tanggal),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      kajian.deskripsi,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 10),

                                    /// ADMIN BUTTONS
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    KajianFormScreen(
                                                      kajian: kajian,
                                                    ),
                                              ),
                                            );

                                            if (result == true) {
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => context
                                              .read<EventProvider>()
                                              .deleteKajian(kajian.id!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KajianFormScreen()),
          );

          if (result == true) {
            setState(() {});
          }
        },
      ),
    );
  }
}
