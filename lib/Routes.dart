import 'package:flutter/material.dart';

import 'Screens/Home/Home.dart';
import 'Screens/Login/index.dart';

class Routes {
  Routes() {
    runApp(new MaterialApp(
      title: "Dribbble Animation App",
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      // ignore: missing_return
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );

          case '/home':
            return new MyCustomRoute(
              builder: (_) => new HomeScreen(),
              settings: settings,
            );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
      return new FadeTransition(opacity: animation, child: child);
  }
}
