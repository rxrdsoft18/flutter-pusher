import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';


PusherOptions options = PusherOptions(
  host: '192.168.18.77',
  wsPort: 6001,
  encrypted: true,
  cluster: 'us2',
  auth: PusherAuth(
    'http://192.168.18.77:3000/broadcasting/auth',
    headers: {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjMwMDAvYXBpL3YxL2F1dGgvbG9naW4iLCJpYXQiOjE2NDk3MDYwNzIsIm5iZiI6MTY0OTcwNjA3MiwianRpIjoiY0RuOU02bTNnS2hTbElPUyIsInN1YiI6MzgsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.TAP6g6BOOtZFUIG2kIhm2Z8bVI37w7d8cuzxwO3KZm8',
    },
  ),
);

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter pusher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Pusher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PusherClient pusherClint =
      PusherClient('b2e9642fe8620d16d19d', options, autoConnect: false);

  void initPusher() {
    pusherClint.connect();

    print("socket id ${pusherClint.getSocketId()}");

    pusherClint.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });
    pusherClint.onConnectionError((error) {
      print("error es: ${error?.message}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter Pusher Options',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                initPusher();
              },
              child: const Text("CALL CONNECTION PUSHER"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Channel channel =
                pusherClint.subscribe("private-orderStatusUpdated-12");
                channel.bind("order-status-updated", (PusherEvent? event) {
                  print('MESSAGE EVENT: ${event?.data}');
                });
              },
              child: const Text("SUBSCRIBE EVENT"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Channel channel = pusherClint.subscribe("private-newOrder");
                const Name = 'Richhard jans';
                channel.trigger("order-check", Name);
              },
              child: const Text("TRIGGER EVENT"),
            ),
          ),
        ],
      ),
    );
  }

}
