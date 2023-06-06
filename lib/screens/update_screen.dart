import 'package:flutter/material.dart';
import '../Database/updategame.dart';

class UpdateGameScreen extends StatefulWidget {
  final Map<String, dynamic> gameData;

  UpdateGameScreen({required this.gameData});

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
    nameController.text = widget.gameData['name'];
    ratingController.text = widget.gameData['rating'].toString();
    releasedController.text = widget.gameData['released'];
    descriptionController.text = widget.gameData['description_raw'];
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
                widget.gameData['name'] = nameController.text;
                widget.gameData['rating'] = double.parse(ratingController.text);
                widget.gameData['released'] = releasedController.text;
                widget.gameData['description_raw'] = descriptionController.text;

                // Perform the update operation
                updateGame(widget.gameData)
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
