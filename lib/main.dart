import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:geolocator/geolocator.dart';

import 'package:geolocator_test/pages/mainPage.dart';

void main()
{
    WidgetsFlutterBinding.ensureInitialized();

    debugPaintSizeEnabled = false;

    runApp(LocationApp());
}

class LocationApp extends StatefulWidget
{
    @override
    _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp>
{
    @override
    void initState()
    {
        super.initState();
    }

    @override
    void dispose()
    {
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MainPage()
        );
    }
}