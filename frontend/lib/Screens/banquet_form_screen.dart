import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/api_Services.dart';

class BanquetFormScreen extends StatefulWidget {
  @override
  _BanquetFormScreenState createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Form Controllers & State
  String _eventType = 'Wedding';
  String _country = 'India';
  String _state = 'Maharashtra';
  TextEditingController _cityController = TextEditingController(text: 'Powai');
  TextEditingController _adultsController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'eventType': _eventType,
        'country': _country,
        'state': _state,
        'city': _cityController.text,
        'eventDates': [_selectedDate.toString()],
        'numberOfAdults': int.parse(_adultsController.text),
        'budget': int.parse(_budgetController.text),
      };

      bool success = await _apiService.submitBanquetRequest(data);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Submitted!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submission Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banquets & Venues'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell Us Your Venue Requirements',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildDropdown('Event Type', _eventType, ['Wedding', 'Anniversary', 'Corporate event', 'Other Party'], (val) {
                setState(() => _eventType = val!);
              }),
              SizedBox(height: 16),
              _buildDropdown('Country', _country, ['India', 'China', 'Japan', 'Russia'], (val) {
                setState(() => _country = val!);
              }),
               SizedBox(height: 16),
              _buildDropdown('State', _state, ['Maharashtra', 'Delhi', 'Karnataka'], (val) {
                setState(() => _state = val!);
              }),
               SizedBox(height: 16),
              _buildTextField('City', _cityController),
              SizedBox(height: 16),
              _buildDateField('Event Dates'),
              SizedBox(height: 16),
              _buildTextField('Number of Adults', _adultsController, keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildTextField('Budget', _budgetController, keyboardType: TextInputType.number, isAmount: true),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFF1A237E),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool isAmount = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: isAmount ? Padding(padding: const EdgeInsets.all(14.0), child: Text('INR')) : null,
      ),
       validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(String label) {
  return InkWell(
    onTap: () => _selectDate(context),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _selectedDate == null
                ? 'Select a date'
                : DateFormat.yMMMd().format(_selectedDate!),
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    ),
  );
}
}