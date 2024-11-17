import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/providers/user_provider.dart';
import 'package:yalla_negev/ui/screens/admin/notification/notification_manager.dart';
import 'package:yalla_negev/ui/widgets/image.dart';
import 'package:yalla_negev/ui/widgets/image_crop.dart';
import 'package:yalla_negev/utils/validators.dart';
import '../../../../generated/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormFieldState>();
  final _displayNameFormKey = GlobalKey<FormFieldState>();
  late Widget _imageContainer;
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _pictureUrlController = TextEditingController();
  final _nameFocus = FocusNode();
  final _displayNameFocus = FocusNode();
  String? _displayNameError;

  String? profileImage;
  XFile? selectedImage;
  File? newImage;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) {
        _nameFormKey.currentState!.reset();
      } else {
        setState(() {
          _nameFormKey.currentState!.validate();
        });
      }
    });
    _displayNameFocus.addListener(() async {
      if (_displayNameFocus.hasFocus) {
        _displayNameFormKey.currentState!.reset();
      } else {
        bool displayNameExists =
            await checkIfDisplayNameExists(_displayNameController.text);
        if (displayNameExists) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            var l10n = S.of(context);
            setState(() {
              _displayNameError = l10n.displayNameExists!;
            });
          });
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              _displayNameError = null;
            });
          });
        }
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            _displayNameFormKey.currentState!.validate();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _pictureUrlController.dispose();
    _nameFocus.dispose();
    _displayNameFocus.dispose();
    super.dispose();
  }

  Future pickImage() async {
    var l10n = S.of(context);
    try {
      final selectedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selectedImage == null) {
        var snackBar = SnackBar(content: Text(l10n.noImageSelected));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final croppedFile = await myImageCropper(selectedImage.path);

      if (croppedFile != null) {
        setState(() {
          newImage = File(croppedFile.path);
        });
      } else {
        var snackBar = SnackBar(content: Text(l10n.noImageSelected));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on PlatformException catch (_) {
      var snackBar = SnackBar(content: Text(l10n.grantPermissionPhoto));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void saveChanges() {
    var user = Provider.of<AuthRepository>(context, listen: false);

    user.updateUserData(
      newName: _nameController.text,
      newDisplayName: _displayNameController.text,
      newPic: newImage,
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    var l10n = S.of(context);
    final user = Provider.of<AuthRepository>(context, listen: false);
    final TextEditingController emailController = TextEditingController();
    bool isSwitchOn = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap outside to dismiss
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder<String>(
              future: NotificationManager.getDeletionInstructions(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AlertDialog(
                    title: Text(l10n.deleteAccount),
                    content: const SpinKitHourGlass(
                      color: Colors.orange,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: Text(l10n.deleteAccount),
                    content: Text(
                        'Failed to get deletion instructions: ${snapshot.error}'),
                  );
                } else {
                  return AlertDialog(
                    title: Text(l10n.deleteAccount),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snapshot.data!),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            hintText: user.userData!.email,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Text(
                              l10n.confirmDeleteAccount,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                            Switch(
                              value: isSwitchOn,
                              onChanged: (value) {
                                setState(() {
                                  isSwitchOn = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(l10n.cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        onPressed:
                            (emailController.text == user.userData!.email &&
                                    isSwitchOn)
                                ? () {
                                    // Call the delete account method
                                    //user.deleteAccount();
                                    Navigator.of(context).pop();
                                  }
                                : null,
                        child: Text(l10n.delete),
                      ),
                    ],
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEditImage(double height, double width) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        height: height * 0.065,
        width: height * 0.065,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 4, color: Colors.white),
          color: Colors.blue,
        ),
        child: IconButton(
          icon: Icon(
            Icons.edit,
            size: height * 0.035,
            color: Colors.white,
          ),
          onPressed: pickImage,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    var l10n = S.of(context);
    var authRepo = Provider.of<AuthRepository>(context, listen: false);
    return TextFormField(
      key: _nameFormKey,
      controller: _nameController,
      focusNode: _nameFocus,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: l10n.name,
        hintText: authRepo.userData!.name,
        hintStyle: const TextStyle(color: Colors.grey),
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: _nameFocus.hasFocus ||
                _nameController.text.isEmpty ||
                nameValidator(_nameController.text, context) != null
            ? null
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
      validator: (value) => nameValidatorAllowsEmpty(value, context),
    );
  }

  Widget _buildDisplayNameField() {
    var l10n = S.of(context);
    var authRepo = Provider.of<AuthRepository>(context, listen: false);
    return TextFormField(
      key: _displayNameFormKey,
      controller: _displayNameController,
      focusNode: _displayNameFocus,
      maxLength: 20,
      decoration: InputDecoration(
        labelText: l10n.displayName,
        hintText: authRepo.userData!.displayName,
        hintStyle: const TextStyle(color: Colors.grey),
        errorText: _displayNameError,
        errorMaxLines: 3,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: _displayNameFocus.hasFocus
            ? Tooltip(
                message: l10n.uniqueNameInfo,
                child: const Icon(Icons.info_outline),
              )
            : displayNameValidator(_displayNameController.text, context) !=
                        null ||
                    _displayNameError != null
                ? null
                : const Icon(Icons.check_circle, color: Colors.green),
      ),
      validator: (value) => displayNameValidatorAllowsEmpty(value, context),
    );
  }

  Widget _buildSaveProfileButton(BuildContext context) {
    var l10n = S.of(context);
    var user = Provider.of<AuthRepository>(context, listen: false);
    return ElevatedButton(
      onPressed: () {
        _nameController.text = _nameController.text.isEmpty
            ? user.userData!.name
            : _nameController.text;
        _displayNameController.text = _displayNameController.text.isEmpty
            ? user.userData!.displayName
            : _displayNameController.text;
        if (_formKey.currentState!.validate() && _displayNameError == null) {
          // Save profile
          saveChanges();
          Navigator.of(context).pop();
        } else {
          var snackBar = SnackBar(
            content: Text(l10n.fillFieldsCorrectly),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Text(l10n.saveProfile),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    var l10n = S.of(context);
    return TextButton(
      onPressed: () => _showDeleteAccountDialog(context),
      child: Text(
        l10n.deleteAccount,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);
    var user = Provider.of<AuthRepository>(context, listen: false);

    profileImage = user.userData!.pictureUrl;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if (newImage != null) {
      _imageContainer = imageContainer(
        height: height,
        width: width,
        imageFile: newImage,
        percent: 0.25,
      );
    } else {
      _imageContainer = imageContainer(
        height: height,
        width: width,
        imageLink: profileImage,
        percent: 0.25,
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.editProfile,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: EdgeInsets.only(
                        top: 0.25, left: width * 0.05, right: width * 0.05),
                    child: Center(
                      child: Stack(
                        children: [
                          _imageContainer,
                          _buildEditImage(height, width),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Adjust space as needed
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildDisplayNameField(),
                  const SizedBox(height: 20),
                  _buildSaveProfileButton(context),
                  const SizedBox(height: 20),
                  _buildDeleteAccountButton(
                      context), // New delete account button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
