import 'package:flutter/material.dart';
import 'db_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _acresController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dropdown selections
  String _selectedFarmType = "Organic";
  String _selectedState = "Maharashtra";
  String _selectedCity = "Pune";

  final List<String> farmTypes = ["Organic", "Conventional", "Hydroponic"];
  final List<String> states = ["Maharashtra", "Gujarat", "Karnataka", "Madhya Pradesh"];
  final Map<String, List<String>> citiesByState = {
    "Maharashtra": ["Pune", "Mumbai", "Nagpur", "Nashik"],
    "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot"],
    "Karnataka": ["Bangalore", "Mysore", "Mangalore", "Hubli"],
    "Madhya Pradesh": ["Bhopal", "Indore", "Gwalior", "Jabalpur"],
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _acresController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final userData = {
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'location': _locationController.text,
        'totalAcres': _acresController.text,
        'farmType': _selectedFarmType,
        'state': _selectedState,
        'city': _selectedCity,
        'password': _passwordController.text,
      };

      final success = await _dbHelper.registerUser(userData);

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("✅ Registration Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("❌ Registration Failed. Please Try Again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"), backgroundColor: Colors.green[700]),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_fullNameController, "Full Name", Icons.person),
                _buildTextField(_phoneController, "Phone Number", Icons.phone, isNumeric: true),
                _buildTextField(_emailController, "Email", Icons.email, isEmail: true),
                _buildTextField(_locationController, "Location", Icons.location_on),
                _buildDropdownCard("Farm Type", _selectedFarmType, farmTypes, Icons.agriculture, (newValue) {
                  setState(() {
                    _selectedFarmType = newValue!;
                  });
                }),
                _buildDropdownCard("State", _selectedState, states, Icons.location_city, (newValue) {
                  setState(() {
                    _selectedState = newValue!;
                    _selectedCity = citiesByState[_selectedState]![0];
                  });
                }),
                _buildDropdownCard("City", _selectedCity, citiesByState[_selectedState]!, Icons.location_on, (newValue) {
                  setState(() {
                    _selectedCity = newValue!;
                  });
                }),
                _buildTextField(_acresController, "Total Acres of Land", Icons.landscape, isNumeric: true),
                _buildPasswordField(_passwordController, "Password"),
                _buildPasswordField(_confirmPasswordController, "Confirm Password"),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool isNumeric = false, bool isEmail = false}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
          decoration: InputDecoration(
            labelText: hintText,
            border: InputBorder.none,
            icon: Icon(icon, color: Colors.green),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter your $hintText";
            if (isEmail && !value.contains("@")) return "Enter a valid email";
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller,
          obscureText: hintText == "Password" ? _obscurePassword : _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: hintText,
            border: InputBorder.none,
            icon: const Icon(Icons.lock, color: Colors.green),
            suffixIcon: IconButton(
              icon: Icon(
                hintText == "Password"
                    ? (_obscurePassword ? Icons.visibility_off : Icons.visibility)
                    : (_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (hintText == "Password") {
                    _obscurePassword = !_obscurePassword;
                  } else {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  }
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Enter a password";
            if (value.length < 6) return "Password must be at least 6 characters";
            if (hintText == "Confirm Password" && value != _passwordController.text) return "Passwords do not match";
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownCard(String title, String value, List<String> options, IconData icon, Function(String?) onChanged) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: title,
            border: InputBorder.none,
            icon: Icon(icon, color: Colors.green), // Use the passed icon
          ),
          onChanged: onChanged,
          items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        ),
      ),
    );
  }
}