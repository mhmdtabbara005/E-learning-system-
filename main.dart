import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List courses = [];
  List enrolled = [];

  @override
  void initState() {
    super.initState();
    getCourses();
    // getEnrolledCourses();
  }

  Future<void> getCourses() async {
    try {
      final response = await Dio()
          .get("http://192.168.0.107/e-learning-platform/getAllCourses.php");

      final data = response.data;
      final decoded = jsonDecode(data);
      setState(() {
        courses = decoded['courses'];
      });
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  // Future<void> getEnrolledCourses() async {
  //   try {
  //     final response = await Dio()
  //         .get("http://192.168.0.107/e-learning-platform/enrollInCourse.php");

  //     setState(() {
  //       enrolled = json.decode(response.data);
  //     });
  //   } catch (e) {
  //     print("Error fetching courses: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("E Learninig System"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("All Courses"),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(courses[index]['title']),
                    subtitle: Text(courses[index]['description']),
                    trailing: enrolled.contains(courses[index])
                        ? const Text("Already Enrolled")
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                enrolled.add(courses[index]);
                              });
                            },
                            child: const Text("Enroll")),
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              const Text("Enrolled Courses"),
              const SizedBox(
                height: 20,
              ),
              enrolled.isEmpty
                  ? const Center(child: Text("No enrolled courses"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: enrolled.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(enrolled[index]['title']),
                          subtitle: Text(enrolled[index]['description']),
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
