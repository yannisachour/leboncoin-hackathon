import 'package:flutter/material.dart';

//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

//void main() => runApp(new MyApp());

void main() {
//  debugPaintSizeEnabled=true;
  debugPaintSizeEnabled=false;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: const MyHomePage(title: 'le Bon Broker'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {


    //switch pic according to document status case
    var pic = new Container(
        child: new Column(
          children: <Widget>[
            (document['status'] == 'rdv fixé'
                ? new Column(
              children: <Widget>[
                new Icon(Icons.check, color: Colors.green,),
                new Text(document['status'],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 11.0,
                      color: Colors.green,
                    )
                ),
              ],
            )
                : new Container()),
            (document['status'] == 'à appeler'
                ? new Column(
              children: <Widget>[
                new Icon(Icons.local_phone, color: Colors.grey,),
                new Text(document['status'],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey,
                    )
                ),
              ],
            )
                : new Container()),
            (document['status'] == 'refusé'
                ? new Column(
              children: <Widget>[
                new Icon(Icons.close, color: Colors.red,),
                new Text(document['status'],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 11.0,
                      color: Colors.red,
                    )
                ),
              ],
            )
                : new Container()),
            (document['status'] == 'appel en cours...'
                ? new Column(
              children: <Widget>[
                new Icon(Icons.local_phone, color: Colors.orange,),
                new Text(document['status'],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 11.0,
                      color: Colors.orange,
                    )
                ),
              ],
            )
                : new Container()),
          ],
        )
    );

    return new ListTile(
      key: new ValueKey(document.documentID),
      title: new Container(
        height: 110.0,
        margin: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey[300]),
          borderRadius: new BorderRadius.circular(5.0),
        ),

        padding: const EdgeInsets.all(0.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                width: 125.0,
                child: new Container(
                    padding: const EdgeInsets.all(0.0),
                    decoration: new BoxDecoration(
                        color: Colors.grey[100],
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage(document['imageurl']),
                        )
                    )
                ),

            ),
            new Expanded(

                child: new Container(
                    padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),

                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(document['name'],
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold

                              )
                          ),
                          new Text(document['votes']+' €',
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold

                              )
                          ),
                          new Text('Instruments',
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.grey,

                              )
                          ),
                          new Text('Paris, 18ème',
                              style: new TextStyle(
                                fontSize: 11.0,
                                color: Colors.blueGrey,
                              )
                          ),
                          new Text('Aujourhui, 18:15',
                              style: new TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                              )
                          ),
                         ]
                     )

                )


            ),
            new Container(
              padding: const EdgeInsets.all(0.0),

              width: 70.0,
                decoration: new BoxDecoration(
                    color: Colors.grey[200]
                ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  new Text('statut'),
                  pic,


//                    (document['status'] == 'rdv fixé'
//                        ? new Icon(Icons.check, color: Colors.green,)
//                        : new Icon(Icons.local_phone,  color: Colors.grey[600])),

                  ],
                ),
            )

          ]


        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.orange[800],
          title: new Text(title),
        ),
        body: new Column(children: <Widget>[
          new Container(
              height: 40.0,
              padding: const EdgeInsets.only(top: 5.0, left: 20.0),
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey[300]),

              ),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
//                        padding:
                      child: new Text('4 annonces sélectionnées',
                          style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey
                          )),
                    ),

                  ),
                  new Container(
                      width: 50.0,
                      child: new Column(
                        children: <Widget>[
                          new Icon(Icons.calendar_today,
                            size: 18.0,
                            color: Colors.orange,),
                          new Text("Date",
                              style: new TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.orange
                              ))
                        ],
                      )
                  ),
                  new Container(
                      width: 50.0,
                      child: new Column(
                        children: <Widget>[
                          new Icon(Icons.euro_symbol,
                            size: 18.0,
                            color: Colors.grey,),
                          new Text("Date",
                              style: new TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                              ))
                        ],
                      )
                  ),

                ],
              )
          ),

          new Flexible(
              child:
              new Stack(
                children: <Widget>[
                  new StreamBuilder(
                      stream: Firestore.instance.collection('baby').snapshots,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text('Loading...');
                        return new ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          padding: const EdgeInsets.only(top: 10.0),
                          itemExtent: 130.0,
                          itemBuilder: (context, index) =>
                              _buildListItem(context, snapshot.data.documents[index]),
                        );
                      }),

                  new Positioned(
                      bottom: 20.0,
                      left: 0.0,
                      right: 0.0,
                      child:
                      new Center(
                        child:
                        new MaterialButton(
                          child: new Text(
                            'Contacter les vendeurs avec le Bon Broker',
                            style: new TextStyle(color: Colors.white),
                          ),
                          color: Colors.orange[800],
                          height: 60.0,
                          elevation: 10.0,
                          splashColor: Colors.orange[800],
                          onPressed: () {
                            // Perform some action
                          },
                        ),
                      )
                  )

                ],
              )
//
          ),

          new Divider(height: 0.0),
          new Container(
            width: 340.0,
            height: 80.0,
            decoration: const BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: const AssetImage("assets/tabbar.png"),
              ),
            ),

          ),
        ]
        )
    );
  }
}
