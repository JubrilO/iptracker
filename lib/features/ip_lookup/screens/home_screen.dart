import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iptracker/features/ip_lookup/view_models/home_view_model.dart';
import 'package:iptracker/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    
    _viewModel.errorStream.listen((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade800,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('IPTracker'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Service selector dropdown
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.dns, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'IP Service Provider:',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _viewModel.currentServiceName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                isDense: true,
                              ),
                              items: _viewModel.availableServiceNames
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(name),
                                      ))
                                  .toList(),
                              onChanged: _viewModel.isLoading
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        _viewModel.changeService(value);
                                        // Reset any entered IP when changing services
                                        _viewModel.clearIPAddress();
                                      }
                                    },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Different providers may return slightly different location data',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic, 
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // IP Input Field
                    TextFormField(
                      enabled: !_viewModel.isLoading,
                      controller: _viewModel.ipAddressController,
                      decoration: InputDecoration(
                        labelText: 'IP Address',
                        hintText: 'Enter an IPv4 address (e.g., 8.8.8.8)',
                        helperText: 'Enter a valid IPv4 address to locate it on the map',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: _buildSuffixIcon(),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitIPAddress(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _viewModel.isLoading 
                                ? null 
                                : _viewModel.getIPAddress,
                            icon: _viewModel.isLoading 
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.wifi_find),
                            label: const Text('Get My IP'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _viewModel.isLoading 
                                ? null 
                                : _submitIPAddress,
                            icon: _viewModel.isLoading 
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.map),
                            label: const Text('Locate IP'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSuffixIcon() {
    if (_viewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    } else if (_viewModel.ipAddressController.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: _viewModel.clearIPAddress,
      );
    } else {
      return const Icon(Icons.language);
    }
  }
  
  Future<void> _submitIPAddress() async {
    if (_viewModel.isLoading) return;
    
    final ipData = await _viewModel.submitIPAddress();
    if (ipData != null && mounted) {
      Navigator.pushNamed(
        context, 
        Routes.map, 
        arguments: ipData
      );
      FocusScope.of(context).unfocus();
    }
  }
}