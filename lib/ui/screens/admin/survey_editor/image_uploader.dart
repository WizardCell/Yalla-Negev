import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:yalla_negev/generated/l10n.dart';

import '../../../../utils/globals.dart';  // Assuming you're using localization

class ImageUploader extends StatefulWidget {
  final String surveyId;
  final String? initialImageUrl;
  final ValueSetter<String> onImageUploaded;

  const ImageUploader({
    super.key,
    required this.surveyId,
    required this.initialImageUrl,
    required this.onImageUploaded,
  });

  @override
  ImageUploaderState createState() => ImageUploaderState();
}

class ImageUploaderState extends State<ImageUploader> {
  String? _imageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final file = File(image.path);
      final extension = path.extension(image.path); // Get the file extension
      final filename = '${widget.surveyId}$extension'; // Append the extension to surveyId
      final storageRef = storage.ref("surveyImages").child(filename);
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        });
      });

      final snapshot = await uploadTask.whenComplete(() => {});
      final url = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = url;
        _isUploading = false;
      });

      widget.onImageUploaded(url);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).uploadFailed)),
      );
    }
  }

  void _deleteImage() {
    setState(() {
      _imageUrl = null;
    });
    widget.onImageUploaded('');
  }

  void _openFullImage() {
    if (_imageUrl != null && _imageUrl!.startsWith("https://")) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Image.network(_imageUrl!),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,  // Stretches the content horizontally
          children: [
            Text(l10n.pickSurveyImage, style: Theme.of(context).textTheme.titleMedium),  // Dynamic hint text
            const SizedBox(height: 8),
            if (_imageUrl != null && _imageUrl!.startsWith("https://"))
              GestureDetector(
                onTap: _openFullImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _imageUrl!,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            _isUploading
                ? Column(
              children: [
                LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 8),
              ],
            )
                : _imageUrl != null && _imageUrl!.startsWith("https://")
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _deleteImage,
                  icon: const Icon(Icons.delete),
                  label: Text(l10n.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _uploadImage,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(l10n.change),
                ),
              ],
            )
                : ElevatedButton.icon(
              onPressed: _uploadImage,
              icon: const Icon(Icons.cloud_upload),
              label: Text(l10n.uploadImage),
            ),
          ],
        ),
      ),
    );
  }
}
