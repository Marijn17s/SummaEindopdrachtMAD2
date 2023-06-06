import 'package:flutter/material.dart';
import '../Database/updategame.dart';

class UpdateGameScreen extends StatefulWidget {
  final Map<String, dynamic> game;

  UpdateGameScreen({required this.game});

  @override
  _UpdateGameScreenState createState() => _UpdateGameScreenState();
}

class _UpdateGameScreenState extends State<UpdateGameScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController releasedController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.game['name'];
    ratingController.text = widget.game['rating'].toString();
    releasedController.text = widget.game['released'];
    descriptionController.text = widget.game['description_raw'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: 'Rating',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: releasedController,
              decoration: InputDecoration(
                labelText: 'Released',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Update the game data with the new values
                widget.game['name'] = nameController.text;
                widget.game['rating'] = double.parse(ratingController.text);
                widget.game['released'] = releasedController.text;
                widget.game['description_raw'] = descriptionController.text;

                // Perform the update operation
                updateGame(widget.game)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Game updated successfully.'),
                    ),
                  );
                  Navigator.pop(context); // Go back to the previous screen
                })
                    .catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update game: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
