import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../styles/constants.dart';
import '../model/alert_data.dart';
import '../widgets/form_field.dart';
import '../widgets/image_picker_button.dart';
import '../widgets/time_button.dart';


class BottomPanel extends StatefulWidget {
  final String selectedAddress;
  final LatLng selectedLocation;

  final DateTime now = DateTime.now();
  final String date = DateFormat('d MMMM').format(DateTime.now());
  final String time = DateFormat('h:mm a').format(DateTime.now());

  BottomPanel(this.selectedAddress, this.selectedLocation);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _isExpanded = false;
  int _selectedElephantCount = 1;
  String _selectedCasualtyOption = 'No';
  String _specialNote = '';
  String _selectedTimeButtonValue = 'Now'; // Initialize with default value
  File? _selectedImage;
  final List<AlertData> _alertDataList = [];
  final DraggableScrollableController _draggableController = DraggableScrollableController();

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
      location: '${widget.selectedLocation.latitude}, ${widget.selectedLocation.longitude}',
      date: widget.date,
      time: widget.time,
      elephantCount: _selectedElephantCount,
      casualtyOption: _selectedCasualtyOption,
      specialNote: _specialNote,
      image: _selectedImage,
      timeButtonValue: _selectedTimeButtonValue, // Pass the time button value
    );

    setState(() {
      _alertDataList.add(alertData);
    });

    print('Stored Alert Data: ${_alertDataList.last}');
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        setState(() {
          _isExpanded = notification.extent > 0.6;
        });
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _draggableController,
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollapsedView() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            widget.selectedAddress,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Sighting marker: ${widget.selectedLocation.longitude}   ${widget.selectedLocation.latitude}',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            'No. of elephants',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                children: List.generate(5, (index) {
                  final number = index == 4 ? '5+' : '${index + 1}';
                  final isSelected = _selectedElephantCount == (index == 5 ? 5 : index + 1);
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedElephantCount = index == 5 ? 5 : index + 1;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? primaryColor : Colors.transparent,
                          border: Border.all(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            number,
                            style: TextStyle(
                              color: isSelected ? Colors.black : primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              TimeButton(
                text: 'Now',
                isSelected: _selectedTimeButtonValue == 'Now',
                onPressed: () {
                  setState(() {
                    _selectedTimeButtonValue = 'Now'; // Store the selected time button value
                  });
                },
              ),
              SizedBox(width: 8),
              TimeButton(
                text: '10 min.',
                isSelected: _selectedTimeButtonValue == '10 min.',
                onPressed: () {
                  setState(() {
                    _selectedTimeButtonValue = '10 min.'; // Store the selected time button value
                  });
                },
              ),
              SizedBox(width: 8),
              TimeButton(
                text: '30+ min.',
                isSelected: _selectedTimeButtonValue == '30+ min.',
                onPressed: () {
                  setState(() {
                    _selectedTimeButtonValue = '30+ min.'; // Store the selected time button value
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedView() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const Text(
                'Send alert',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          FormFieldWidget(label: 'Location', value: '${widget.selectedLocation.latitude}, ${widget.selectedLocation.longitude}'),
          FormFieldWidget(label: 'Date & time', value: widget.date, secondValue: widget.time),
          FormFieldWidget(label: 'No. of elephants', value: '$_selectedElephantCount'),
          SizedBox(height: 24),
          const Text('Casualties', style: TextStyle(color: Colors.white, fontSize: 16)),
          Row(
            children: [
              Radio<String>(
                value: 'Yes',
                groupValue: _selectedCasualtyOption,
                onChanged: (value) {
                  setState(() {
                    _selectedCasualtyOption = value!;
                  });
                },
                activeColor: primaryColor,
              ),
              Text('Yes', style: TextStyle(color: Colors.white)),
              SizedBox(width: 32),
              Radio<String>(
                value: 'No',
                groupValue: _selectedCasualtyOption,
                onChanged: (value) {
                  setState(() {
                    _selectedCasualtyOption = value!;
                  });
                },
                activeColor: primaryColor,
              ),
              Text('No', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 24),
          const Text('Special notes (Optional)', style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              _specialNote = value;
            },
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: TextStyle(color: Colors.white),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerButton(onPressed: _pickImage),
              SizedBox(height: 16),
              if (_selectedImage != null)
                Column(
                  children: [
                    Image.file(_selectedImage!, height: 50, width: double.infinity, fit: BoxFit.cover),
                    SizedBox(height: 8),
                  ],
                ),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _storeAlertData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text('Send Alert', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
