import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../providers/activity_provider.dart';

class CreateActivityScreen extends ConsumerStatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  ConsumerState<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedType = 'social';
  LatLng? _pickedLocation;
  String? _pickedLocationName;
  
  final List<String> _types = ['hike', 'surf', 'yoga', 'meal', 'social', 'cowork', 'other'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a location')),
      );
      return;
    }
    
    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final activityData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'activity_type': _selectedType,
      'location': {
        'lat': _pickedLocation!.latitude,
        'lng': _pickedLocation!.longitude,
      },
      'event_time': startTime.toUtc().toIso8601String(),
      'max_participants': int.tryParse(_maxParticipantsController.text) ?? 10,
    };

    await ref.read(activityProvider.notifier).createActivity(activityData);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Beacon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: 'Activity Type'),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(labelText: 'Max Participants (0 for unlimited)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat('EEEE, MMM d').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: const Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              ListTile(
                title: Text(_pickedLocation == null ? 'Pick Location on Map' : 'Location Selected'),
                subtitle: _pickedLocation == null
                    ? const Text('Tap to choose')
                    : Text(_pickedLocationName ?? '${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}'),
                leading: const Icon(Icons.map, color: Colors.blue),
                onTap: () async {
                  final result = await context.push<Map<String, dynamic>>('/location-picker');
                  if (result != null) {
                    setState(() {
                      _pickedLocation = LatLng(result['lat'], result['lng']);
                      _pickedLocationName = result['name'];
                    });
                  }
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
