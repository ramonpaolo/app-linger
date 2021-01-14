import 'package:sigepweb/sigepweb.dart';
import 'package:geolocator/geolocator.dart';

class CalcularFrete {
  var sigep = Sigepweb(contrato: SigepContrato.semContrato());
  double diference = 0.0;
  String cidadeDestino = "";

  Future diferenceBeetwen(
      double latitudeVendedor, double longitudeVendedor) async {
    final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);

    print(
        "Lat e Lon cliente: ${currentPosition.latitude}, ${currentPosition.longitude}");
    print("Lat e Lon vendedor: ${latitudeVendedor}, ${longitudeVendedor}");
    diference = await Geolocator.distanceBetween(currentPosition.latitude,
        currentPosition.longitude, latitudeVendedor, longitudeVendedor);
  }

  Future consultaCEP(String cepDestino, String cepOrigem,
      double latitudeVendedor, double longitudeVendedor) async {
    await _hasPermission(
      latitudeVendedor,
      longitudeVendedor,
    );
  }

  Future _hasPermission(
    double latitudeVendedor,
    double longitudeVendedor,
  ) async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (await Geolocator.checkPermission() ==
        LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      await diferenceBeetwen(
        latitudeVendedor,
        longitudeVendedor,
      );
    }
  }
}
