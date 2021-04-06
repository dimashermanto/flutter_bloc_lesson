import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'news_bloc.dart';
import 'news_info.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  final newsBloc = NewsBloc();

  @override
  void initState() {
    newsBloc.eventSink.add(NewsAction.Fetch);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    newsBloc.disposeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Container(
        child: StreamBuilder<List<Article>>(
          stream: newsBloc.newsStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error ?? "Error"),
              );
            }
            if (snapshot.hasData) {
              List<Article> newsList = snapshot.data;
              return NewsList(newsList);
            } else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class NewsList extends StatelessWidget {


  const NewsList(this.newsList);

  final List<Article> newsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          var article = newsList[index];
          var formattedTime = DateFormat('dd MMM - HH:mm')
              .format(article.publishedAt);
          return Container(
            height: 100,
            margin: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        article.urlToImage,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(formattedTime),
                      Text(
                        article.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
