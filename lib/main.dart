import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spontaneous',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: Column(children: [
          ElevatedButton(
            onPressed: requestContactPermission,
            child: const Text('Get Contacts'),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(contact.phones.first.toString()));
                  }))
        ]));
  }

  Future<void> requestContactPermission() async {
    if (await FlutterContacts.requestPermission()) {
      retrieveContacts();
    } else {
      debugPrint('Contact permission denied');
    }
  }

  Future<void> retrieveContacts() async {
    final retrieveContacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );
    setState(() {
      contacts = retrieveContacts.take(10).toList();
    });
  }
}
