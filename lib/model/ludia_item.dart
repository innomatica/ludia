const defaultItemTitle = 'New Item';

//
// Item
//
class LudiaItem {
  int? id;
  String? title; // for now this is not used
  String? imagePath;

  LudiaItem({
    this.id,
    this.title,
    this.imagePath,
  });

  factory LudiaItem.fromDefault() {
    return LudiaItem(
      title: defaultItemTitle,
    );
  }

  factory LudiaItem.fromDbMap(Map<String, Object?> map) {
    return LudiaItem(
      id: map['id'] as int,
      title: map['title'] != null ? (map['title'] as String) : null,
      imagePath: map['imagePath'] != null ? (map['imagePath'] as String) : null,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'title': title,
      'imagePath': imagePath,
    };
  }

  @override
  String toString() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
    }.toString();
  }
}
