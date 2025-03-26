import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:iptracker/features/ip_lookup/view_models/map_view_model.dart';

class MapScreen extends StatefulWidget {
  final MapViewModel viewModel;
  final IPData ipData;

  const MapScreen({
    super.key,
    required this.viewModel,
    required this.ipData,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    // Set the location when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.setLocation(widget.ipData);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('IP Location Map'),
            actions: [
              IconButton(
                icon: Icon(
                  widget.viewModel.showInfoPanel 
                      ? Icons.info 
                      : Icons.info_outline,
                ),
                onPressed: widget.viewModel.toggleInfoPanel,
                tooltip: 'Toggle info panel',
              ),
            ],
          ),
          body: Stack(
            children: [
              // Map Layer
              FlutterMap(
                mapController: widget.viewModel.mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    widget.ipData.latitude,
                    widget.ipData.longitude,
                  ),
                  initialZoom: widget.viewModel.currentZoom,
                  maxZoom: 18.0,
                  minZoom: 2.0,
                ),
                children: [
                  // Base map layer
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.iptracker',
                    // Remove the problematic TileUpdateTransformer
                  ),
                  
                  // Marker layer
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(widget.ipData.latitude, widget.ipData.longitude),
                        width: 120,
                        height: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.ipData.ipAddress,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Info Panel
              if (widget.viewModel.showInfoPanel)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.computer, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'IP: ${widget.ipData.ipAddress}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.viewModel.formatCoordinates(
                                    widget.ipData.latitude,
                                    widget.ipData.longitude,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (widget.ipData.city != null || widget.ipData.country != null)
                            Row(
                              children: [
                                const Icon(Icons.place, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    [
                                      widget.ipData.city,
                                      widget.ipData.country,
                                    ].where((e) => e != null).join(', '),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Zoom controls
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoomIn',
                      onPressed: widget.viewModel.zoomIn,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'zoomOut',
                      onPressed: widget.viewModel.zoomOut,
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}