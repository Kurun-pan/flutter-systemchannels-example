import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SystemChannels API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter SystemChannels API Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformMessage;

  void _accessibilitySample () async {
    /// Same as SemanticsService.announce
    //SemanticsService.announce('Hello world', TextDirection.ltr);
    final AnnounceSemanticsEvent event = AnnounceSemanticsEvent('Hello world', TextDirection.ltr);
    await SystemChannels.accessibility.send(event.toMap());
  }

  @override
  initState() {
    super.initState();

    ///
    /// SystemChannels.lifecycle
    ///
    SystemChannels.lifecycle.setMessageHandler((message){
      print('<SystemChannels.lifecycle> $message');
      /*
      AppLifecycleState.paused
      AppLifecycleState.inactive
      AppLifecycleState.resumed
      AppLifecycleState.suspending
      AppLifecycleState.detached
       */
      return Future<String>.value();
    });

    ///
    /// SystemChannels.navigation
    ///
    SystemChannels.navigation.setMethodCallHandler((call) {
      print('<SystemChannels.navigation> ${call.method} (${call.arguments})');
      /*
       popRoute
       pushRoute
       */
      return Future<dynamic>.value();
    });

    ///
    /// SystemChannels.keyEvent
    ///
    SystemChannels.keyEvent.setMessageHandler((message) {
      print('<SystemChannels.keyEvent> $message');
      setState(() => _platformMessage = message.toString());
      return Future<dynamic>.value();
    });

    ///
    /// SystemChannels.textInput
    ///
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChannels.textInput.invokeMethod('TextInput.show');
    SystemChannels.textInput.setMethodCallHandler((call) {
      print('<SystemChannels.textInput> ${call.method} (${call.arguments})');
      return Future<dynamic>.value();
    });

    ///
    /// SystemChannels.system
    ///
    SystemChannels.system.setMessageHandler((message) {
      print('<SystemChannels.system> $message');
      return Future<dynamic>.value();
    });

    ///
    /// SystemChannels.skia
    /// Set the maximum number of bytes that can be held in the GPU resource cache.
    ///
    const maxBytes = 4 * 1024 * 1024;
    SystemChannels.skia.invokeMethod('setResourceCacheMaxBytes', maxBytes);

    ///
    /// SystemChannels.platform_views
    ///
    /*
    final Map<String, dynamic> args = <String, dynamic>{
      'id': 1,
      'viewType': 'Create WebView',
    };
    SystemChannels.platform_views.invokeMethod('create', args);
    stemChannels.platform_views.setMethodCallHandler((call){
      print('<SystemChannels.platform_views> ${call.method} (${call.arguments})');
      return Future<dynamic>.value();
    });
    //SystemChannels.platform_views.invokeMethod<void>('dispose', 1);
    */

    ///
    /// SystemChannels.accessibility
    SystemChannels.accessibility.setMessageHandler((message) {
      print('<SystemChannels.accessibility> $message');
      return Future<dynamic>.value();
    });

    ///
    /// SystemChannels.platform
    /// Same as SystemNavigator.pop()
    /// https://api.flutter.dev/flutter/services/SystemNavigator/pop.html
    ///
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
              'Your Platform keyEvent: $_platformMessage',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _accessibilitySample,
        child: Icon(Icons.accessibility),
      ),
    );
  }
}
