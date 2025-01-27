/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safe_app/pages/success_alert_page.dart';
import '../components/collapsed_view.dart';
import '../components/expanded_view.dart';
import '../styles/constants.dart';
import '../model/alert_data.dart';
import '../utils/size_config.dart';

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
  DistanceRange _selectedDistanceRange = DistanceRange.m100; // Default selection

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
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _storeAlertData() {
    final alertData = AlertData(
      location:'${widget.selectedLocation.longitude}  ${widget.selectedLocation.latitude}',
      date: _dateController.text,
      time: _timeController.text,
      elephantCount: int.parse(_elephantCountController.text),
      casualtyOption: _selectedCasualtyOption,
      specialNote: _specialNotesController.text,
      image: _selectedImage,
      timeButtonValue: _selectedTimeButtonValue,
      distanceRange: _selectedDistanceRange,
    );

    setState(() {
      _alertDataList.add(alertData);
    });
    print(alertData);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig
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
            ? 0.3
            : 0.4,
        minChildSize: SizeConfig.screenHeight < 600 ? 0.4 : 0.4,
        maxChildSize: 0.96,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessAlertPage(
            alertId: '12345',
            onClose: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alert data stored successfully!'),
          backgroundColor: Colors.green,
        ),
      );
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
      _selectedDistanceRange = DistanceRange.m100;

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
      header: _buildHeader(),
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
      onDistanceSelected: _updateDistanceRange,
      selectedTimeButtonValue: _selectedTimeButtonValue,
      onTimeButtonSelected: _updateTimeButton,
      onSendPressed: _sendAlert,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _draggableController.animateTo(
              0.3,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            setState(() {
              _isExpanded = false;
            });
          },
        ),
        Text(
          'Send alert',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
