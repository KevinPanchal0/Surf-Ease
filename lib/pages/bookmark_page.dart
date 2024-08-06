import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_ease/provider/bookmark_provider.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final bookmark = Provider.of<BookmarkProvider>(context).bookMarkList;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left),
        ),
        centerTitle: true,
        title: const Text('Book Marks'),
      ),
      body: (bookmark.isEmpty)
          ? const Center(child: Text('Add BookMarks'))
          : ListView.builder(
              itemCount: bookmark.length,
              itemBuilder: (context, index) {
                return ListTile(

                  leading: Text('${index + 1}'),
                  title: Text(bookmark[index].tittle),
                  onTap: () {
                    Navigator.of(context).pop(bookmark[index].url);
                  },
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value == 1){
                        Provider.of<BookmarkProvider>(context, listen: false).removeBookMark(bookmark[index]);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.delete),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
