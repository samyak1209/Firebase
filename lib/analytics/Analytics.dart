import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Analytics{
  static  FirebaseAnalytics analytics=FirebaseAnalytics();
  static  FirebaseAnalyticsObserver observer=FirebaseAnalyticsObserver(analytics: analytics);

}