import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(StudentNameApp());

class StudentNameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Full Name Generator',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.deepPurple.withOpacity(0.3),
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18, letterSpacing: 0.5),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.1,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.7),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18, letterSpacing: 0.5),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.1,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: NameGeneratorPage(),
    );
  }
}

class NameGeneratorPage extends StatefulWidget {
  @override
  _NameGeneratorPageState createState() => _NameGeneratorPageState();
}

class _NameGeneratorPageState extends State<NameGeneratorPage> {
  List<String> masterList = [
    "AISHWARYA A", "ARCHANA C H", "ARUN KUMAR V", "BHARATH KUMAR M R", "BHAVANI M V",
    "BHRAMARA H R", "CHAITRA N", "CHANDANA C N", "CHETHAN S", "DHADHAVALI",
    "GANESH S", "HARSHITHA H B", "KAVYA G L", "KHUSHUBU M", "LAKSHMI K",
    "YASEENPASHA", "MAHESH SUTHAR", "MANOJ B S", "MANOJ K B", "MANOJ S B",
    "MEGHANA G", "MUNNELLI CHANDANA", "NAGESH N", "NAYANA D", "NAYANA P",
    "NIKITHA M", "P G SHREYA", "PAVAN C P", "PONNAPPA B B RANISH", "PREMA M",
    "PREMCHANDRA S G", "PRIYANKA B M", "PRIYANKA N S", "SAI VARAPRASAD REDDY N R",
    "SHASHANK R", "SHRAVANI G R", "SHRAVANTHI G", "SHRIDHARA D", "SHRUTHI H S",
    "SHWETHA G", "SINDHU A", "SNEHA S", "SURAJ N", "TEJAS S C",
    "UJWALA B", "ULLAS K", "VAISHNAVI R", "VARSHA C", "VARUN KUMAR G",
    "VIJAY N", "VINAYAK HOSUR"
  ];

  List<String> availableNames = [];
  List<String> usedNames = [];
  String currentName = "";

  @override
  void initState() {
    super.initState();
    loadNames();
  }

  Future<void> loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsedNames = prefs.getString('usedNames');
    final savedCurrentName = prefs.getString('currentName');

    setState(() {
      usedNames = savedUsedNames != null
          ? List<String>.from(jsonDecode(savedUsedNames))
          : [];

      currentName = savedCurrentName ?? '';
      availableNames = [...masterList]
        ..removeWhere((name) => usedNames.contains(name))
        ..shuffle();
    });
  }

  Future<void> saveNames() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('usedNames', jsonEncode(usedNames));
    prefs.setString('currentName', currentName);
  }

  void generateOneName() {
    if (availableNames.isNotEmpty) {
      setState(() {
        currentName = availableNames.removeLast();
        usedNames.add(currentName);
      });
      saveNames();
    } else {
      setState(() {
        currentName = "🎉 All names are used!";
      });
    }
  }

  void resetNames() {
    setState(() {
      availableNames = [...masterList]..shuffle();
      usedNames.clear();
      currentName = "";
    });
    saveNames();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Name Generator",
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        elevation: 8,
        shadowColor: theme.primaryColor.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      currentName.isEmpty ? "Press Generate" : currentName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "${availableNames.length} names remaining",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: generateOneName,
                  icon: Icon(Icons.person_add, size: 22),
                  label: Text("Generate", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton.icon(
                  onPressed: resetNames,
                  icon: Icon(Icons.refresh, size: 22),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shadowColor: Colors.redAccent.withOpacity(0.6),
                  ),
                  label: Text("Reset", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            SizedBox(height: 24),
            Divider(thickness: 1.2),
            Expanded(
              child: usedNames.isEmpty
                  ? Center(
                      child: Text(
                        "No names used yet",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: usedNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            usedNames[index],
                            style: TextStyle(fontSize: 18),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
