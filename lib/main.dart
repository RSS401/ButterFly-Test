import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
/*import 'package:flutter_svg/flutter_svg.dart';*/
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Moderation')
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
  File? selectedImage;
  Map<String, dynamic>? safeSearchResults;

  /*Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedImage!.path);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Moderation'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              color: Colors.purpleAccent,
              child: const Text(
                "Pick Image from Gallery",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
              onPressed: () {
                _pickImageFromGallery();
              },
            ),
            MaterialButton(
              color: Colors.blueAccent,
              child: const Text(
                "Pick Image from Camera",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
              onPressed: () {
                _pickImageFromCamera();
              },
            ),

            const SizedBox(height: 20,),

            // Container to make sure all selected images are a constant height, otherwise some images may overflow the screens size.

            Container(
              width: 500,  // Set the desired width
              height: 500, // Set the desired height
              child: selectedImage != null
                  ? Image.file(selectedImage!, fit: BoxFit.cover)
                  : const Text("Please select an image"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (selectedImage != null) {
                  await moderateImage(selectedImage!);
                } else {
                  // Handle case where no image is selected
                }
              },
              child: const Text("Moderate Image"),
            ),
            if (safeSearchResults != null) ..._buildSafeSearchResults(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/butterfly.jpg',
                width: double.infinity,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickImageFromGallery() async{
    final imageReturned = await ImagePicker().pickImage(source: ImageSource.gallery); 

    /* Prevents error occuring if no image is selected from gallery*/ 

    if(imageReturned == null){
      return;
    } 

    setState(() {
      selectedImage = File(imageReturned!.path);
    });
  }

  Future<void> _pickImageFromCamera() async{

    final imageReturned = await ImagePicker().pickImage(source: ImageSource.camera);

    /* Prevents error occuring if no image is selected from gallery */
    
    if(imageReturned == null){
      return;
    }

    setState(() {
      selectedImage = File(imageReturned!.path);
    });

  }

  Future<void> moderateImage(File imageFile) async {

    try{
      final apiKey = 'AIzaSyDIDTyeaDFL4yFn9WFHQOzJT10OzqTS708';
      final authHeaders = {'Authorization': 'Bearer $apiKey'};

      final response = await http.post(
          Uri.parse('https://vision.googleapis.com/v1/images:annotate'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Encode(await imageFile.readAsBytes())},
              'features': [
                {'type': 'SAFE_SEARCH_DETECTION'}
              ],
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final safeSearchAnnotation = data['responses'][0]['safeSearchAnnotation'];

        setState(() {
          safeSearchResults = safeSearchAnnotation;
        });

      } else {
        print('Failed to moderate image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error moderating image: $e');
    }
  }

  List<Widget> _buildSafeSearchResults() {
    return [
      const SizedBox(height: 20),
      Text('Safe Search Results:'),
      _buildSafeSearchResult('Adult', safeSearchResults!['adult']),
      _buildSafeSearchResult('Spoof', safeSearchResults!['spoof']),
      _buildSafeSearchResult('Medical', safeSearchResults!['medical']),
      _buildSafeSearchResult('Violence', safeSearchResults!['violence']),
      _buildSafeSearchResult('Racy', safeSearchResults!['racy']),
    ];
  }
  Widget _buildSafeSearchResult(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}

// Was trying something like adding a bottom tab which switches between different pages when clicked.

/*class BottomTabs extends StatefulWidget {
  const BottomTabs({ Key? key }) : super(key: key);

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}


class _BottomTabs extends StatelessWidget{
  const _BottomTabs({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assests/vectors/home-outline.svg'),
            label: ''
            ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assests/vectors/search-outline.svg'),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assests/vectors/add-square.svg'),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assests/vectors/video-play-outline.svg'),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/profile.png')),
                shape: BoxShape.circle
              ),
            ),
            label: ''
          ),
        ],
      ),
    );
  }
}*/