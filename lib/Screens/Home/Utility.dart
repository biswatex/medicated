import 'package:medicated/Screens/profile/PeofileScreen.dart';
import 'package:medicated/drawerFragments/FragmentAbout.dart';
import 'package:medicated/drawerFragments/FragmentContactUs.dart';
import 'package:medicated/drawerFragments/FragmentFeedback.dart';
import 'package:medicated/drawerFragments/FragmentSettings.dart';
import 'package:medicated/drawerFragments/fragmentHome.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<FragmentHome>(() => FragmentHome());
    register<About>(() => About());
    register<Settings>(() => Settings());
    register<ProfilePage>(() => ProfilePage());
    register<FeedbackUs>(() => FeedbackUs());
    register<ContactUs>(() => ContactUs());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}