import 'package:entrevista/models/characters-model.dart';
import 'package:entrevista/provider/provider-api.dart';
import 'package:entrevista/utils/loading-widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();

  void _listener() {
    final data = Provider.of<ProviderApi>(context, listen: false);
    if ((controller.offset + 500 >= controller.position.maxScrollExtent) &&
        !data.loading) {
      print('loading');
      data.getInfo(data.info.info.next);
    }
  }

  @override
  void initState() {
    controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        print(orientation);
        return (orientation != Orientation.portrait)
            ? PortatilOrientation(controller: controller)
            : LandscapeOrientation(controller: controller);
      }),
    );
  }
}

class LandscapeOrientation extends StatelessWidget {
  const LandscapeOrientation({Key key, this.controller}) : super(key: key);
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProviderApi>(context);

    return (data.info != null)
        ? SafeArea(
            child: Container(
            child: ListView.builder(
                controller: controller,
                itemCount: data.info.results.length,
                itemBuilder: (context, i) {
                  final information = data.info.results[i];
                  return CardModel(information: information);
                }),
          ))
        : LoadingWidget();
  }
}

class PortatilOrientation extends StatelessWidget {
  const PortatilOrientation({Key key, this.controller}) : super(key: key);
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProviderApi>(context);
    return (data.info != null)
        ? SafeArea(
            child: Container(
            child: GridView.builder(
              controller: controller,
              itemCount: data.info.results.length,
              itemBuilder: (context, i) {
                final information = data.info.results[i];
                return CardModel(information: information);
              },
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            ),
          ))
        : LoadingWidget();
  }
}

class CardModel extends StatelessWidget {
  const CardModel({
    Key key,
    @required this.information,
  }) : super(key: key);

  final Result information;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Card(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  '${information.image}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                children: [
                  Text(
                    '${information.name}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${information.status}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 10,
                            offset: Offset(5, 5),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
