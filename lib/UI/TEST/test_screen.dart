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

  //flutter 문서에서 cookbook에서 network에서 http패키지 넣고,
  // 네트워크 요청하는 리퀘스트 권한
  // 받아온 데이터를 http.리스폰스 객체 안에, 다트에서 사용하고자 할 때,
  // 코드를 변환해야 하는데, fromjson 생성자를 만들어서 암묵적으로
  //이렇게 하자고 정리가 됨.
  // json가지고 객체를 만들 때, factory 쓰자고 암묵적인 약속을 정함.

  Future<void> init() async {
    //async에서는 await를 써저야 함.
    Album album =
        await fetchAlbum(); //미래에 답이 와야 되기 때문에 'await'를 써줘야 함. 아래 then 코드와 동일
    setState(() {
      _album = album;
    });
  }

  //async 와 await 는 세트임.
  //uri에서 정보를 받아와야 하기 떄문에, 기다림이 필요.
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

    init();

    // fetchAlbum().then((album) {
    //   setState(() {
    //     _album = album;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Sample'),
      ),

      //예를 들어, 날씨 바꾸거나 실시간 정보들을 불러일으킬 때, futurer builder를 사용
      //setstate를 사용하지 않음.
      body: FutureBuilder<Album>(
        future: fetchAlbum(),
        builder: (context, snapshot) {

          if(snapshot.hasError) {
            return const Center(child: Text('네트워크 에러!!!'));
          }
          // 연결상태를 보는 것.
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          //데이터가 없다면
          if(!snapshot.hasData) {
            return const Center(child:  Text('데이터가 없습니다'));

          }
          //데이터가 여기에서는 무조건 있는 상황
          final Album album = snapshot.data!;


          //여기가 데이터를 ui로 구현하는 메서드
          return Text(
            '${album.id} : ${album.toString()}',
            style: const TextStyle(fontSize: 30),
          );
        },
      ),



     /*
     _album == null

          // 앨범이 서버에 요청하고 요구 받는 동안에는
          // 앨범 값이 'null'임. 그 간극을 '로딩'으로 표시해야 함

          ? const Center(child: const CircularProgressIndicator())
          : Text(
              '${_album!.id} : ${_album.toString()}',
              style: const TextStyle(fontSize: 30),
            ), */
    );
  }


  //***
  // widget _buildBody(Album album){
  //   return Text(
  //     '${album.id} : ${album.toString()}',
  //     style: const TextStyle(fontSize: 30),
  //   );
  // },

    )
  }
}
