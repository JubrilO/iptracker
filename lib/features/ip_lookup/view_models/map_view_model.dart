import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  
  double _currentZoom = 13.0;
  double get currentZoom => _currentZoom;
  
  LatLng? _currentCenter;
  LatLng? get currentCenter => _currentCenter;
  
  bool _showInfoPanel = true;
  bool get showInfoPanel => _showInfoPanel;
  
  void setLocation(IPData ipData) {
    _currentCenter = LatLng(ipData.latitude, ipData.longitude);
    _currentZoom = 13.0;
    
    // If mapController is ready, animate to the new position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(_currentCenter!, _currentZoom);
    });
    
    notifyListeners();
  }
  
  void zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(2.0, 18.0);
    mapController.move(_currentCenter!, _currentZoom);
    notifyListeners();
  }
  
  void zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(2.0, 18.0);
    mapController.move(_currentCenter!, _currentZoom);
    notifyListeners();
  }
  
  void toggleInfoPanel() {
    _showInfoPanel = !_showInfoPanel;
    notifyListeners();
  }
  
  String formatCoordinates(double lat, double lon) {
    String latDir = lat >= 0 ? 'N' : 'S';
    String lonDir = lon >= 0 ? 'E' : 'W';
    
    return '${lat.abs().toStringAsFixed(4)}° $latDir, ${lon.abs().toStringAsFixed(4)}° $lonDir';
  }
  
  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}