class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  //json 문서 내용을 다트 언어로 변환하는 과정.
  //json 문서는 다트에서 무조건 map으로 변환하면 됨.
  //앨범 객체를 만들어주는 클래스고, 생성자임.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  @override
  String toString() {
    return 'Album{userId: $userId, id: $id, title: $title}';
  }
}
