import 'package:flutter/material.dart';

class WordListTab extends StatefulWidget {
  const WordListTab({super.key});

  @override
  State<WordListTab> createState() => _WordListTabState();
}

class _WordListTabState extends State<WordListTab>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.search, size: 24),
              Text(
                'My Words',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.settings, size: 24),
            ],
          ),
        ),

        // TABS
        TabBar(
          controller: _controller,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorColor: Color(0xFF2B7CEE),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'All Words'),
            Tab(text: 'Weak Words'),
            Tab(text: 'Familiar Words'),
          ],
        ),

        const SizedBox(height: 10),

        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [_buildWordsList(), _buildWordsList(), _buildWordsList()],
          ),
        ),
      ],
    );
  }

  // WORD ITEM BUILDER
  Widget _buildWordsList() {
    final words = [
      _wordTile("Ghosting", "3d ago", 5, 2),
      _wordTile("BRB", "1d ago", 12, 1),
      _wordTile("Spam", "7d ago", 8, 0),
      _wordTile("Noob", "2d ago", 6, 4),
      _wordTile("Meme", "5d ago", 10, 1),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: words,
    );
  }

  // SINGLE WORD TILE
  Widget _wordTile(
    String name,
    String practicedAgo,
    int correct,
    int incorrect,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chat_bubble_outline),
          ),

          const SizedBox(width: 14),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WORD NAME
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "Last practiced:\n$practicedAgo",
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          // STATS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Correct: $correct",
                style: TextStyle(color: Colors.grey[300], fontSize: 13),
              ),
              Text(
                "Incorrect: $incorrect",
                style: TextStyle(color: Colors.grey[300], fontSize: 13),
              ),
            ],
          ),

          const SizedBox(width: 10),

          IconButton(
            onPressed: () {
              print('delete');
            },
            icon: Icon(Icons.delete_forever_sharp, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
