import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_search/MODEL/album.dart';
//as http 탑레벨에 있는 함수를 불러일으키기 위해 쓰여 있음.

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Album? _album;

  //async 와 await 는 세트임.
  Future<Album> fetchAlbum() async {
    //await [future가 리턴되는 코드]
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // 'jsonDecode'는 'response.body'는 json 문서인데,
      // 이걸 map 형식으로 바꿔주는 것임.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum().then((album) {
      setState(() {
        _album = album;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Sample'),
      ),
      body: Container(
        child: Text(_album.toString()),
      ),
    );
  }
}
