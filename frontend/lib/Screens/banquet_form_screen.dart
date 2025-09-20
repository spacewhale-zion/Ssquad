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

  // --- Form State Variables ---
  String _eventType = 'Wedding';
  String _country = 'India';
  String _state = 'Maharashtra';
  final _cityController = TextEditingController(text: 'Powai');
  final _adultsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _offerTimeframeController = TextEditingController();

  // State for multiple date selections
  final List<DateTime> _selectedDates = [];

  // State for Catering Preference (Single Choice)
  String _cateringPreference = 'Non-veg';

  // State for Cuisines (Multiple Choice)
  final Map<String, bool> _cuisines = {
    'Indian': false,
    'Italian': false,
    'Asian': false,
    'Mexican': false,
  };

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDates.isNotEmpty ? _selectedDates.last : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && !_selectedDates.contains(picked)) {
      setState(() {
        _selectedDates.add(picked);
        _selectedDates.sort();
      });
    }
  }

  // --- Form Submission Logic ---
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one event date')),
      );
      return;
    }

    final selectedCuisines = _cuisines.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final data = {
      'eventType': _eventType,
      'country': _country,
      'state': _state,
      'city': _cityController.text,
      'eventDates': _selectedDates.map((date) => date.toIso8601String()).toList(),
      'numberOfAdults': int.parse(_adultsController.text),
      'cateringPreference': [_cateringPreference],
      'cuisines': selectedCuisines,
      'budget': int.parse(_budgetController.text),
      'offerTimeframe': _offerTimeframeController.text.isNotEmpty
          ? _offerTimeframeController.text
          : '24 hours',
    };

    try {
      final success = await _apiService.submitBanquetRequest(data);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Request Submitted Successfully!' : 'Submission Failed. Please try again.',
          ),
        ),
      );

      if (success) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
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
              _buildDropdown(
                'Event Type',
                _eventType,
                ['Wedding', 'Anniversary', 'Corporate event', 'Other Party'],
                (val) => setState(() => _eventType = val!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Country',
                _country,
                ['India', 'China', 'Japan', 'Russia'],
                (val) => setState(() => _country = val!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'State',
                _state,
                ['Maharashtra', 'Delhi', 'Karnataka'],
                (val) => setState(() => _state = val!),
              ),
              const SizedBox(height: 16),
              _buildTextField('City', _cityController),
              const SizedBox(height: 16),
              _buildDateSelector(),
              const SizedBox(height: 16),
              _buildTextField('Number of Adults', _adultsController, keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              _buildCateringPreference(),
              const SizedBox(height: 24),
              _buildCuisinesSelector(),
              const SizedBox(height: 24),
              _buildTextField('Budget', _budgetController, keyboardType: TextInputType.number, isAmount: true),
              const SizedBox(height: 16),
              _buildTextField('Get offer within', _offerTimeframeController, isOptional: true),
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

  // --- Reusable Widgets ---
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isAmount = false,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: isAmount ? const Padding(padding: EdgeInsets.all(14.0), child: Text('INR')) : null,
      ),
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Event Dates', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              for (var date in _selectedDates)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat.yMMMMd().format(date)),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _selectedDates.remove(date)),
                      ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.add),
                label: const Text('Add more dates'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCateringPreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Catering Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio<String>(
              value: 'Veg',
              groupValue: _cateringPreference,
              onChanged: (value) => setState(() => _cateringPreference = value!),
            ),
            const Text('Veg'),
            const SizedBox(width: 20),
            Radio<String>(
              value: 'Non-veg',
              groupValue: _cateringPreference,
              onChanged: (value) => setState(() => _cateringPreference = value!),
            ),
            const Text('Non-veg'),
          ],
        ),
      ],
    );
  }

  Widget _buildCuisinesSelector() {
    final Map<String, String> cuisineImages = {
      'Indian':
          'https://t3.ftcdn.net/jpg/02/49/13/44/360_F_249134444_4LtDWMXa3iEmTvZu7Ua9g3B9TeZRqfak.jpg',
      'Italian':
          'https://t4.ftcdn.net/jpg/05/13/64/69/360_F_513646998_waqkONTda7Nato7jR9Aw1gdHkG83Qsqp.jpg',
      'Asian':
          'https://t3.ftcdn.net/jpg/15/23/41/94/360_F_1523419455_42Bu7c29pItqoU7JPuDHoQgAKQdD5kus.jpg',
      'Mexican':
          'https://media.istockphoto.com/id/913649914/photo/green-and-red-enchiladas-with-mexican-sauces.jpg?s=612x612&w=0&k=20&c=EJs574lSamslooUwZDeWHchJbVhiaYGachdKovTByXs=',
    };

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
            controlAffinity: ListTileControlAffinity.trailing, // checkbox on right
            contentPadding: EdgeInsets.zero,
            secondary: Image.network(
              cuisineImages[key]!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ],
    );
  }
}
