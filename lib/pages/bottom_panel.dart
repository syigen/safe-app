import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../components/casualties_section.dart';
import '../components/date_time_fields.dart';
import '../components/elephant_count_field.dart';
import '../components/image_section.dart';
import '../components/location_field.dart';
import '../components/send_button.dart';
import '../components/special_notes_section.dart';
import '../styles/constants.dart';
import '../model/alert_data.dart';
import '../widgets/image_picker_button.dart';
import '../widgets/time_button.dart';

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

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _elephantCountController = TextEditingController();
  final TextEditingController _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = '${widget.selectedLocation.latitude}, ${widget.selectedLocation.longitude}';
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
      location: _locationController.text,
      date: _dateController.text,
      time: _timeController.text,
      elephantCount: int.parse(_elephantCountController.text),
      casualtyOption: _selectedCasualtyOption,
      specialNote: _specialNotesController.text,
      image: _selectedImage,
      timeButtonValue: _selectedTimeButtonValue,
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
        initialChildSize: 0.35,
        minChildSize: 0.35,
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
          SizedBox(height: 20),
          _buildElephantCountSelector(),
          SizedBox(height: 30),
          _buildTimeButtons(),
        ],
      ),
    );
  }

  Widget _buildElephantCountSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(20, (index) {
          final number = index == 19 ? '20+' : '${index + 1}';
          final isSelected = _selectedElephantCount == (index == 19 ? 20 : index + 1);
          return Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedElephantCount = index == 19 ? 20 : index + 1;
                  _elephantCountController.text = _selectedElephantCount.toString();
                });
              },
              child: Container(
                width: 50,
                height: 50,
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
    );
  }

  Widget _buildTimeButtons() {
    return Row(
      children: [
        TimeButton(
          text: 'Now',
          isSelected: _selectedTimeButtonValue == 'Now',
          onPressed: () => setState(() => _selectedTimeButtonValue = 'Now'),
        ),
        SizedBox(width: 30),
        TimeButton(
          text: '10 min.',
          isSelected: _selectedTimeButtonValue == '10 min.',
          onPressed: () => setState(() => _selectedTimeButtonValue = '10 min.'),
        ),
        SizedBox(width: 30),
        TimeButton(
          text: '30+ min.',
          isSelected: _selectedTimeButtonValue == '30+ min.',
          onPressed: () => setState(() => _selectedTimeButtonValue = '30+ min.'),
        ),
      ],
    );
  }

  Widget _buildExpandedView() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24),
          LocationField(
            locationController: _locationController,
            primaryColor: primaryColor, // Pass primaryColor to LocationField
          ),
          SizedBox(height: 16),
          DateTimeFields(
            dateController: _dateController,
            timeController: _timeController,
            primaryColor: primaryColor,
          ),
          SizedBox(height: 16),
          ElephantCountField(
            elephantCountController: _elephantCountController,
            primaryColor: primaryColor,
          ),
          SizedBox(height: 24),
          CasualtiesSection(
            selectedCasualtyOption: _selectedCasualtyOption,
            onCasualtyOptionChanged: (value) {
              setState(() {
                _selectedCasualtyOption = value!;
              });
            },
            primaryColor: primaryColor,
          ),
          SizedBox(height: 24),
          SpecialNotesSection(
            specialNotesController: _specialNotesController,
            onChanged: (value) => setState(() => _specialNote = value),
          ),
          SizedBox(height: 24),
          ImageSection(
            onPressed: _pickImage,
            selectedImage: _selectedImage,
          ),
          SizedBox(height: 24),
          SendButton(
            onPressed: () {
              print('Elephant Count before validation: $_selectedElephantCount'); // Debug print
              if (_validateForm()) {
                _storeAlertData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Alert data stored successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                print('Validation failed'); // Debug print to show validation failure
              }
            },
          ),
          SizedBox(height: 24),
        ],
      ),
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