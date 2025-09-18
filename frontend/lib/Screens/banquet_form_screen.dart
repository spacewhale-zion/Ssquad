import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/Services/api_Services.dart';

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({Key? key}) : super(key: key);

  @override
  _BanquetFormScreenState createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  
  String _eventType = 'Wedding';
  String _country = 'India';
  String _state = 'Maharashtra';
  final _cityController = TextEditingController(text: 'Powai');
  final _adultsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _offerTimeframeController = TextEditingController(text: '24 hours');

  DateTime? _selectedDate;

  
  final Map<String, bool> _cateringOptions = {
    'Veg': false,
    'Non-veg': false,
    'Vegan': false, 
  };

  
  final Map<String, bool> _cuisines = {
    'Indian': false,
    'Italian': false,
    'Asian': false,
    'Mexican': false,
  };

  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date')),
      );
      return;
    }

    
    final selectedCatering = _cateringOptions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final selectedCuisines = _cuisines.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    
    final data = {
      'eventType': _eventType,
      'country': _country,
      'state': _state,
      'city': _cityController.text,
      'eventDates': [_selectedDate!.toIso8601String()],
      'numberOfAdults': int.parse(_adultsController.text),
      'cateringPreference': selectedCatering, 
      'cuisines': selectedCuisines,
      'budget': int.parse(_budgetController.text),
      'offerTimeframe': _offerTimeframeController.text,
    };

    try {
      final success = await _apiService.submitBanquetRequest(data);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request Submitted Successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Submission Failed. Please try again.')),
          );
        }
      }
    } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('An error occurred: $e')),
         );
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banquets & Venues'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
                'Tell Us Your Venue Requirements',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildDropdown('Event Type', _eventType, ['Wedding', 'Anniversary', 'Corporate event', 'Other Party'], (val) {
                setState(() => _eventType = val!);
              }),
              const SizedBox(height: 16),
              _buildDropdown('Country', _country, ['India', 'China', 'Japan', 'Russia'], (val) {
                setState(() => _country = val!);
              }),
              const SizedBox(height: 16),
              _buildDropdown('State', _state, ['Maharashtra', 'Delhi', 'Karnataka'], (val) {
                setState(() => _state = val!);
              }),
              const SizedBox(height: 16),
              _buildTextField('City', _cityController),
              const SizedBox(height: 16),
              _buildDateField('Event Dates'),
              const SizedBox(height: 16),
              _buildTextField('Number of Adults', _adultsController, keyboardType: TextInputType.number),
              const SizedBox(height: 24),

              
              _buildCateringPreference(),

              const SizedBox(height: 24),
              _buildCuisinesSelector(),
              const SizedBox(height: 24),
              _buildTextField('Budget', _budgetController, keyboardType: TextInputType.number, isAmount: true),
               const SizedBox(height: 16),
              _buildTextField('Get offer within (optional)', _offerTimeframeController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Submit Request', style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  

  
  Widget _buildCateringPreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Catering Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ..._cateringOptions.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _cateringOptions[key],
            onChanged: (bool? value) {
              setState(() {
                _cateringOptions[key] = value!;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCuisinesSelector() {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Please select your Cuisines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ..._cuisines.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _cuisines[key],
            onChanged: (bool? value) {
              setState(() {
                _cuisines[key] = value!;
              });
            },
          );
        }).toList(),
      ],
    );
  }
  
  

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool isAmount = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: isAmount ? const Padding(padding: EdgeInsets.all(14.0), child: Text('INR')) : null,
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
              _selectedDate == null ? 'Select a date' : DateFormat.yMMMd().format(_selectedDate!),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}