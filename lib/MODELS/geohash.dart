class Geohash {
  static const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  static String encode(double latitude, double longitude,
      {int precision = 10}) {
    final totalBits = precision * 5; // Total bits for given precision
    final latBits = _encode(latitude, -90.0, 90.0, totalBits ~/ 2);
    final lonBits = _encode(longitude, -180.0, 180.0, totalBits ~/ 2);

    List<int> bitStream = [];
    for (int i = 0; i < totalBits ~/ 2; i++) {
      bitStream.add(lonBits[i]); // Add longitude bit
      bitStream.add(latBits[i]); // Add latitude bit
    }

    // Convert bitstream to base32 geohash
    String geohash = '';
    for (int i = 0; i < bitStream.length; i += 5) {
      int hash = 0;
      for (int j = 0; j < 5; j++) {
        hash = (hash << 1) | (i + j < bitStream.length ? bitStream[i + j] : 0);
      }
      geohash += _base32[hash];
    }

    // Return the geohash with the required precision
    return geohash.substring(0, precision);
  }

  // This method encodes a value (latitude or longitude) into a list of bits
  static List<int> _encode(double value, double min, double max, int bits) {
    List<int> bitArray = [];
    for (int i = 0; i < bits; i++) {
      double mid = (min + max) / 2;
      if (value > mid) {
        bitArray.add(1);
        min = mid;
      } else {
        bitArray.add(0);
        max = mid;
      }
    }
    return bitArray;
  }

  // Decoding method remains unchanged
  static Map<String, double> decode(String geohash) {
    double latMin = -90.0, latMax = 90.0;
    double lonMin = -180.0, lonMax = 180.0;

    bool isLon = true;
    for (int i = 0; i < geohash.length; i++) {
      int index = _base32.indexOf(geohash[i]);
      for (int bit = 4; bit >= 0; bit--) {
        int bitValue = (index >> bit) & 1;
        if (isLon) {
          double mid = (lonMin + lonMax) / 2;
          if (bitValue == 1) {
            lonMin = mid;
          } else {
            lonMax = mid;
          }
        } else {
          double mid = (latMin + latMax) / 2;
          if (bitValue == 1) {
            latMin = mid;
          } else {
            latMax = mid;
          }
        }
        isLon = !isLon;
      }
    }

    double latitude = (latMin + latMax) / 2;
    double longitude = (lonMin + lonMax) / 2;

    return {'latitude': latitude, 'longitude': longitude};
  }
}
