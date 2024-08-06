import 'package:flutter/material.dart';
import 'package:surf_ease/model/bookmark_modal.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookmarkModal> bookMarkList = [];

  void addBookMark(BookmarkModal data, BuildContext context) {
    if (bookMarkList.any((bookMark) => bookMark.tittle == data.tittle)) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80),
        content: const Text('BookMark Already Added'),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar);
    } else {
      bookMarkList.add(data);
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80),
        action: SnackBarAction(
          label: 'Go',
          onPressed: () {
            Navigator.of(context)
                .pushNamed('bookMark');
          },
        ),
        content: const Text('BookMark Added'),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar);
    }

    notifyListeners();
  }

  void removeBookMark(BookmarkModal data) {
    bookMarkList.remove(data);
    notifyListeners();
  }
}
