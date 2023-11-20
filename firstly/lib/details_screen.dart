import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_bottom_navigation_bar.dart';

class Announcement {
  final String title;
  final String location;
  final DateTime? date;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;  

  Announcement(this.title, this.location, this.date, this.startTime, this.endTime, this.description);
}

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message(this.sender, this.content, this.timestamp);
}

class MyApp extends StatelessWidget {
  final List<Announcement> announcements = [
  Announcement(
    "Annonce 1",
    "Lieu 1",
    DateTime(2023, 11, 1),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 13, minute: 30),
    "Description de l'annonce 1",
  ),
  Announcement(
    "Annonce 2",
    "Lieu 2",
    DateTime(2023, 11, 2),
    TimeOfDay(hour: 14, minute: 15),
    TimeOfDay(hour: 17, minute: 45),
    "Description de l'annonce 2",
  ),
];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anzeigen'),
          backgroundColor: Colors.blue,
        ),
        body: CustomListingsScreen(announcements: announcements),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: announcements),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}   


class CustomAnnouncementDetailsScreen extends StatelessWidget {
  final Announcement announcement;
  final List<Message> messages = [
    Message("John", "Hallo, ich bin interessiert!", DateTime(2023, 11, 1)),
    Message("Anna", "Kannst du mehr Details teilen?", DateTime(2023, 11, 3)),
  ];

  CustomAnnouncementDetailsScreen({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titel: ${announcement.title.toString()}"),
            Text("Titel: ${announcement.title.toString()}"),
            Text("Ort: ${announcement.location.toString()}"),
            Text("Beschreibung: ${announcement.description.toString()}"),
            Text("Datum: ${announcement.date.toString()}"),
            Text("Anfangszeit: ${announcement.startTime.format(context)}"),
            Text("Endzeit: ${announcement.endTime.format(context)}"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomMessagingScreen(announcement: announcement, messages: []),
                  ),
                );
              },
              child: Text("Chatten"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomCreateListingScreen(announcements: []),
              ),
            );
          }
          
        },
      ),
    );
  }
}



class CustomCreateListingScreen extends StatefulWidget {
  final List<Announcement> announcements;

  CustomCreateListingScreen({required this.announcements});

  @override
  _CustomCreateListingScreenState createState() => _CustomCreateListingScreenState();
}

class _CustomCreateListingScreenState extends State<CustomCreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String location = '';
  DateTime? selectedDate; 
  TimeOfDay? startTime; 
  TimeOfDay? endTime;  


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

 void _submitForm() {
  if (_formKey.currentState != null) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      if (title.isEmpty || description.isEmpty || location.isEmpty || selectedDate == null || startTime == null || endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Veuillez remplir toutes les informations.'),
          backgroundColor: Colors.red,
        ));
        return; 
      }

      final newAnnouncement = Announcement(
        title,
        location,
        selectedDate,
        startTime ?? TimeOfDay(hour: 0, minute: 0),
        endTime ?? TimeOfDay(hour: 0, minute: 0),
        description,
      );

      // Ajouter la nouvelle annonce à la liste
      setState(() {
        widget.announcements.add(newAnnouncement);
      });

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Anzeige erstellt!'),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomListingsScreen(announcements: widget.announcements),
        ),
      );
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anzeige erstellen'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titel der Anzeige',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Titel eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Beschreibung der Aufgabe',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Beschreibung eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ort',
                  fillColor: Colors.blue,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ort eingeben';
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(
                    "Datum der Aufgabe: ${selectedDate?.toLocal()?.toString().split(' ')[0] ?? 'Nicht ausgewählt'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today), 
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    "Anfangszeit: ${startTime?.format(context) ?? 'Nicht eingegeben'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectStartTime(context), 
                    icon: Icon(Icons.access_time),
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ], 
              ),

              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    "Endezeit: ${endTime?.format(context) ?? 'Nicht eingegeben'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  TextButton.icon(
                    onPressed: () => _selectEndTime(context), 
                    icon: Icon(Icons.access_time),
                    label: Text(""),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ], 
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomListingsScreen(announcements: widget.announcements),
                    ),
                  );
                },
                child: Text(
                  'Anzeige erstellen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomListingsScreen(announcements: widget.announcements),
                      ),
                    );
                  },
                  child: Text(
                    'Anzeige sehen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, 
        onTap: (index) {
          if (index == 0) {
            print("Accueil");
          } else if (index == 1) {
            print("Messages");
          } else if (index == 2) {
            print("Compte");
          } else if (index == 3) {
            print("Calendrier");
          }
        },
      ),

    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: startTime ?? TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      startTime = picked;
    });
  }
}

Future<void> _selectEndTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: endTime ?? TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      endTime = picked;
    });
  }
}

}



class CustomListingsScreen extends StatefulWidget {
  final List<Announcement> announcements;

  CustomListingsScreen({required this.announcements});

  @override
  _CustomListingsScreenState createState() => _CustomListingsScreenState();

}

class _CustomListingsScreenState extends State<CustomListingsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 80.0,
            // floating: false,
            // pinned: true,
            // flexibleSpace: FlexibleSpaceBar(
              title: Text("Annonces d'aide",
              style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
              ),
          //     background: Image.asset(
          //       "assets/images/ema_logo.jpeg",
          //       height: 50,
          //       width: 50,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
           ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final announcement = widget.announcements[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(10.0), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), 
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2), 
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(announcement.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Titre: ${announcement.title}"),
                          Text("Lieu: ${announcement.location}"),
                          Text("Description: ${announcement.description}"),
                          Text("Date: ${announcement.date != null ? announcement.date!.toString() : 'Non spécifié'}"),
                          Text("Heure de début: ${announcement.startTime.format(context)}"),
                          Text("Heure de fin: ${announcement.endTime.format(context)}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomAnnouncementDetailsScreen(announcement: widget.announcements[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: widget.announcements.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            print("Accueil");
          } else if (index == 1) {
            print("Messages");
          } else if (index == 2) {
            print("Compte");
          } else if (index == 3) {
            print("Calendrier");
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


class CustomMessagingScreen extends StatefulWidget {
  final Announcement announcement;
  final List<Message> messages;

  CustomMessagingScreen({required this.announcement, required this.messages});

  @override
  _CustomMessagingScreenState createState() => _CustomMessagingScreenState();
}

class _CustomMessagingScreenState extends State<CustomMessagingScreen> {
  final _textController = TextEditingController();

  void _sendMessage() {
    final message = _textController.text;
    if (message.isNotEmpty) {
      final newMessage = Message("Me", message, DateTime.now());
      setState(() {
        widget.messages.add(newMessage);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.announcement.title),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[index];
                final isMe = message.sender == "Me";

                return ListTile(
                  title: Text(
                    isMe ? "Ich" : message.sender,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(message.content),
                  tileColor: isMe ? Colors.blue[200] : Colors.blue[100],
                  contentPadding: EdgeInsets.all(10),
                  visualDensity: VisualDensity.standard,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Nachricht eingeben...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
