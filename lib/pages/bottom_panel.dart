import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _isExpanded = false;
  int _selectedElephantCount = 1;
  String _selectedTimeOption = 'Now';

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
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF021B1A),
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
            'Kapugala resort',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Sighting marker: 7.8731 80.7718',
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
            child: Row(
              children: List.generate(6, (index) {
                final number = index == 5 ? '5+' : '${index + 1}';
                final isSelected = _selectedElephantCount == (index == 5 ? 5 : index + 1);
                return Padding(
                  padding: EdgeInsets.only(right: 10),
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
                        color: isSelected ? Color(0xFF00FF9D) : Colors.transparent,
                        border: Border.all(
                          color: Color(0xFF00FF9D),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Color(0xFF00FF9D),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildTimeButton('Now'),
              SizedBox(width: 8),
              _buildTimeButton('10 min.'),
              SizedBox(width: 8),
              _buildTimeButton('30+ min.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String text) {
    final isSelected = _selectedTimeOption == text;
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedTimeOption = text;
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? Color(0xFF00FF9D) : Colors.transparent,
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: Color(0xFF00FF9D)),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Color(0xFF00FF9D),
          ),
        ),
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
          ),
          SizedBox(height: 24),
          _buildFormField('Location', '7.8731 80.7718'),
          _buildFormField('Date & time', '24 September', secondValue: '8:44 PM'),
          _buildFormField('No. of elephants', '$_selectedElephantCount'),
          SizedBox(height: 24),
          Text(
            'Casualties',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            children: [
              Radio(
                value: 'Yes',
                groupValue: 'No',
                onChanged: (_) {},
                activeColor: Color(0xFF00FF9D),
              ),
              Text('Yes', style: TextStyle(color: Colors.white)),
              SizedBox(width: 32),
              Radio(
                value: 'No',
                groupValue: 'No',
                onChanged: (_) {},
                activeColor: Color(0xFF00FF9D),
              ),
              Text('No', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Special notes (Optional)',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00FF9D)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: TextStyle(color: Colors.white),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFF00FF9D)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF00FF9D)),
                  SizedBox(width: 8),
                  Text(
                    'Add images',
                    style: TextStyle(color: Color(0xFF00FF9D)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00FF9D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text(
              'Send Alert',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String value, {String? secondValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (secondValue != null) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  secondValue,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
            Icon(Icons.edit, color: Color(0xFF00FF9D), size: 20),
          ],
        ),
        Divider(color: Colors.grey[600]),
        SizedBox(height: 24),
      ],
    );
  }
}
