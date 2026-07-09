import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/album.dart';
import '../viewmodels/album_details_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';

class AlbumDetailsView extends StatefulWidget {
  const AlbumDetailsView({super.key});

  @override
  State<AlbumDetailsView> createState() => _AlbumDetailsViewState();
}

class _AlbumDetailsViewState extends State<AlbumDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final album = ModalRoute.of(context)!.settings.arguments as Album;
      Provider.of<AlbumDetailsViewModel>(context, listen: false).loadAlbumDetails(
        mbid: album.mbid,
        artist: album.artist,
        albumName: album.name,
      );
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final album = ModalRoute.of(context)!.settings.arguments as Album;

    return Scaffold(
      body: Consumer2<AlbumDetailsViewModel, FavoritesViewModel>(
        builder: (context, detailsVM, favoritesVM, child) {
          final isFav = favoritesVM.isFavorite(album);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: album.imageUrl.isNotEmpty
                      ? Image.network(
                          album.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[900]),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () => favoritesVM.toggleFavorite(album),
                  ),
                ],
              ),
              if (detailsVM.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (detailsVM.errorMessage != null)
                SliverFillRemaining(
                  child: Center(child: Text(detailsVM.errorMessage!)),
                )
              else if (detailsVM.albumDetails != null)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailsVM.albumDetails!.album.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            detailsVM.albumDetails!.album.artist,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: detailsVM.albumDetails!.tags
                                .map((tag) => Chip(
                                      label: Text(tag),
                                      backgroundColor: Colors.deepPurple.withAlpha(77),
                                      labelStyle: const TextStyle(fontSize: 12),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Faixas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    ...detailsVM.albumDetails!.tracks.map((track) => ListTile(
                          leading: const Icon(Icons.music_note, color: Colors.grey),
                          title: Text(track.name),
                          trailing: Text(
                            _formatDuration(track.duration),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )),
                    const SizedBox(height: 32),
                  ]),
                ),
            ],
          );
        },
      ),
    );
  }
}
