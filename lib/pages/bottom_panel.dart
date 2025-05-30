/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safe_app/pages/success_alert_page.dart';
import '../components/collapsed_view.dart';
import '../components/expanded_view.dart';
import '../styles/constants.dart';
import '../model/alert_data.dart';
import '../utils/size_config.dart';
import 'package:safe_app/services/alert_service.dart';

class BottomPanel extends StatefulWidget {
  final String selectedAddress;
  final LatLng selectedLocation;

  BottomPanel(this.selectedAddress, this.selectedLocation);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _isExpanded = false;
  int _selectedElephantCount = 1;
  String _selectedCasualtyOption = 'No';
  String _specialNote = '';
  String _selectedTimeButtonValue = 'Now';
  File? _selectedImage;
  final List<AlertData> _alertDataList = [];
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  DistanceRange _selectedDistanceRange = DistanceRange.m0; // Default selection

  final AlertService _alertService = AlertService();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _elephantCountController = TextEditingController();
  final TextEditingController _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = '${widget.selectedLocation.longitude} , ${widget.selectedLocation.latitude}';
    _elephantCountController.text = _selectedElephantCount.toString();

    _elephantCountController.addListener(() {
      final count = int.tryParse(_elephantCountController.text);
      if (count != null) {
        setState(() {
          _selectedElephantCount = count;
        });
      }
    });
    _dateController.text = DateFormat('d MMMM').format(DateTime.now());
    _timeController.text = DateFormat('h:mm a').format(DateTime.now());
    _elephantCountController.text = _selectedElephantCount.toString();
  }

  void _showToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _elephantCountController.dispose();
    _specialNotesController.dispose();
    _draggableController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_selectedElephantCount <= 0) {
      _showError('Please select a valid number of elephants.');
      return false;
    }
    if (_selectedCasualtyOption.isEmpty) {
      _showError('Please specify if there are casualties.');
      return false;
    }
    if (_specialNote.isEmpty) {
      _specialNote = 'No special note provided.';
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final pickedOption = await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF032221),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF00FF9D)),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF00FF9D)),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );


    if (pickedOption != null) {
      try {
        final image = await _picker.pickImage(
          source: pickedOption,
          imageQuality: 80,
        );
        if (image?.path != null) {
          setState(() {
            _selectedImage = File(image!.path);
          });
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error picking image: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _storeAlertData() async {
    try {
      final AlertService alertService = AlertService();

      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final DateFormat timeFormat = DateFormat('HH:mm:ss');
      final String formattedDate = dateFormat.format(DateTime.now());
      final String formattedTime = timeFormat.format(DateTime.now());

      // Create an AlertData object
      final alertData = AlertData(
        location: '${widget.selectedLocation.longitude}, ${widget.selectedLocation.latitude}',
        date: formattedDate,
        time: formattedTime,
        elephantCount: _selectedElephantCount,
        casualtyOption: _selectedCasualtyOption,
        specialNote: _specialNotesController.text.isEmpty ? "" : _specialNotesController.text,
        timeButtonValue: _selectedTimeButtonValue,
        distanceRange: _selectedDistanceRange,
        image: _selectedImage != null ? File(_selectedImage!.path) : null, // Assuming _selectedImage is a File
      );

      await alertService.postAlert(alertData);

      _showToast(
        message: 'Alert data stored successfully!',
        backgroundColor: const Color(0xFF00DF81),
        textColor: Colors.white,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessAlertPage(
            alertId: '12345', // Pass actual alert ID here
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ),
      );

    } catch (e) {
      _showToast(
        message: 'Failed to send alert: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        setState(() {
          _isExpanded = notification.extent > 0.7;
        });
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _draggableController,
        initialChildSize: SizeConfig.screenHeight < 600
            ? (SizeConfig.screenHeight < 500 ? 0.5 : 0.4)
            : 0.4,
        minChildSize: SizeConfig.screenHeight < 500 ? 0.5 : 0.4,
        maxChildSize: 0.88,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: _isExpanded ? _buidExpandedView() : _buildCollapsedView(),
            ),
          );
        },
      ),
    );
  }

  void _sendAlert() {
    if (_validateForm()) {
      _storeAlertData();
      _resetBottomSheetValues();

    }
  }

  void _updateDistanceRange(DistanceRange value) {
    setState(() {
      _selectedDistanceRange = value;
    });
  }

  void _updateTimeButton(String value) {
    setState(() {
      _selectedTimeButtonValue = value;
    });
  }

  void _updateCasualtyOption(String value) {
    setState(() {
      _selectedCasualtyOption = value;
    });
  }

  void _resetBottomSheetValues() {
    setState(() {
      _selectedElephantCount = 1;
      _selectedCasualtyOption = 'No';
      _specialNote = '';
      _selectedTimeButtonValue = 'Now';
      _selectedImage = null;
      _selectedDistanceRange = DistanceRange.m0;

      _locationController.text =
      '${widget.selectedLocation.longitude}, ${widget.selectedLocation.latitude}';
      _dateController.text = DateFormat('d MMMM').format(DateTime.now());
      _timeController.text = DateFormat('h:mm a').format(DateTime.now());
      _elephantCountController.text = _selectedElephantCount.toString();
      _specialNotesController.clear();
    });
  }

  Widget _buidExpandedView() {
    return ExpandedView(
      locationController: _locationController,
      dateController: _dateController,
      timeController: _timeController,
      elephantCountController: _elephantCountController,
      specialNotesController: _specialNotesController,
      specialNote: _specialNote,
      selectedCasualtyOption: _selectedCasualtyOption,
      selectedTimeButtonValue: _selectedTimeButtonValue,
      selectedImage: _selectedImage,
      onPickImage: _pickImage,
      onSendButtonPressed: _sendAlert,
      onDistanceRangeChanged: _updateDistanceRange,
      onTimeButtonChanged: _updateTimeButton,
      onCasualtyOptionChanged: _updateCasualtyOption,
      selectedDistanceRange: _selectedDistanceRange,
    );

  }

  Widget _buildCollapsedView() {
    return CollapsedView(
      locationController: _locationController,
      selectedLocationText:
      '${widget.selectedLocation.longitude}  ${widget.selectedLocation.latitude}',
      selectedElephantCount: _selectedElephantCount,
      onElephantCountChanged: (selectedCount) {
        setState(() {
          _selectedElephantCount = selectedCount;
          _elephantCountController.text = _selectedElephantCount.toString();
        });
      },
      selectedDistanceRange: _selectedDistanceRange,
      onDistanceSelected: (DistanceRange selectedDistance) {
        _updateDistanceRange(selectedDistance);
      },
      selectedTimeButtonValue: _selectedTimeButtonValue,
      onTimeButtonSelected: _updateTimeButton,
      onSendPressed: _sendAlert,
    );
  }
}