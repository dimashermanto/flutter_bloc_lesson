import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_info.dart';

enum NewsAction{
  Fetch, Delete
}

class NewsBloc{
  final _stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get _newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;


  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  NewsBloc(){
    _eventStream.listen((event) async {
      if(event == NewsAction.Fetch){

      } try {
        var news = await getNews();
        if (news != null) {
          _newsSink.add(news.articles);
        }else{
          _newsSink.addError("No News being fetch");
        }
      } on Exception catch (e) {
        _newsSink.addError("Something when fucked up");
      }
    });
  }

  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get('http://newsapi.org/v2/everything?domains=wsj.com&apiKey=033924e27d27460bb479fe777c8972f5');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return newsModel;
    }

    return newsModel;
  }

  void disposeBloc(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

}