import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import '../model/ludia_item.dart';
import '../service/sqlite.dart';

enum LudiaTarget { home, lock, both }

extension LudiaTargetExtension on LudiaTarget {
  String get name {
    switch (this) {
      case LudiaTarget.home:
        return 'Home Screen';
      case LudiaTarget.lock:
        return 'Lock Screen';
      default:
        return 'Both Screens';
    }
  }
}

class LudiaLogic extends ChangeNotifier {
  LudiaLogic() {
    init();
    refresh();
  }

  final _items = <LudiaItem>[];
  final _db = SqliteService();
  bool _busy = false;
  int _gridColumns = 2;
  late final Directory _dir;

  List<LudiaItem> get items => _items;
  int get gridColumns => _gridColumns;
  bool get busy => _busy;

  Future init() async {
    _dir = await getApplicationDocumentsDirectory();
    debugPrint('document dir:${_dir.path}');
  }

  void changeGridColumns() {
    debugPrint('chageGridColumns: $_gridColumns');
    if (_gridColumns == 1) {
      _gridColumns = 2;
    } else if (_gridColumns == 2) {
      _gridColumns = 3;
    } else if (_gridColumns == 3) {
      _gridColumns = 1;
    }
    notifyListeners();
  }

  //
  // Item
  //
  Future refresh() async {
    _items.clear();
    _items.addAll(await _db.getItems());
    notifyListeners();
  }

  Future insertItem(LudiaItem item) async {
    await _db.addItem(item);
    refresh();
  }

  Future deleteItem(LudiaItem item) async {
    // delete image files if exists
    await purgeImageData(item);
    await _db.deleteItem(item);
    refresh();
  }

  Future updateItem(LudiaItem item) async {
    createImageData(item);
    await _db.updateItem(item);
    refresh();
  }

  //
  // Image Data
  //
  void createImageData(LudiaItem item) {
    // move image from cache folder to document folder
    if (item.imagePath != null && item.imagePath!.contains('/cache/')) {
      final file = File(item.imagePath!);
      final newPath = '${_dir.path}/${item.title}_'
          '${item.imagePath!.split('/').last}';
      file.rename(newPath);
      item.imagePath = newPath;
      debugPrint('image file moved to: $newPath');
    }
  }

  Future purgeImageData(LudiaItem item) async {
    final entities = await _dir.list().toList();
    // delete image files started with the item title
    for (final entity in entities) {
      if (entity.path == item.imagePath) {
        await entity.delete();
      }
    }
  }

  Future setWallpaper(LudiaItem item, LudiaTarget target) async {
    _busy = true;
    notifyListeners();
    if (item.imagePath != null) {
      await AsyncWallpaper.setWallpaperFromFile(
        filePath: item.imagePath!,
        wallpaperLocation: target.index + 1,
      );
    }
    _busy = false;
    notifyListeners();
  }
}
