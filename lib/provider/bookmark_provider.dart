import 'package:flutter/material.dart';
import 'package:surf_ease/model/bookmark_modal.dart';

class BookmarkProvider with ChangeNotifier{
  List<BookmarkModal> bookMarkList = [];

  void addBookMark(BookmarkModal data){
    bookMarkList.add(data);
    notifyListeners();
  }

  void removeBookMark(BookmarkModal data){
    bookMarkList.remove(data);
    notifyListeners();
  }
}