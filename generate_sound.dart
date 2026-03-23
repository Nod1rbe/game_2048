import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() async {
  await generateWav('assets/audio/click.wav', isClick: true);
  await generateWav('assets/audio/new_drop.wav', isClick: false);
  print('Done.');
}

Future<void> generateWav(String path, {required bool isClick}) async {
  final sampleRate = 44100;
  final duration = isClick ? 0.08 : 0.12; 
  final numSamples = (sampleRate * duration).toInt();
  
  final dataSize = numSamples * 2; // 16-bit mono
  final fileSize = 36 + dataSize;
  
  var builder = BytesBuilder();
  
  // RIFF header
  builder.add('RIFF'.codeUnits);
  builder.add(_int32ToBytes(fileSize));
  builder.add('WAVE'.codeUnits);
  
  // fmt chunk
  builder.add('fmt '.codeUnits);
  builder.add(_int32ToBytes(16)); // Subchunk1Size
  builder.add(_int16ToBytes(1)); // PCM format
  builder.add(_int16ToBytes(1)); // Channels (mono)
  builder.add(_int32ToBytes(sampleRate)); // Sample rate
  builder.add(_int32ToBytes(sampleRate * 2)); // ByteRate
  builder.add(_int16ToBytes(2)); // BlockAlign
  builder.add(_int16ToBytes(16)); // BitsPerSample
  
  // data chunk
  builder.add('data'.codeUnits);
  builder.add(_int32ToBytes(dataSize));
  
  // Audio data
  for (int i = 0; i < numSamples; i++) {
    double t = i / sampleRate;
    double freq;
    double env;
    double amplitude;
    
    if (isClick) {
      // Soft, low click
      // frequency drops rapidly from 400 to 200
      freq = 400.0 * exp(-t * 20.0);
      env = exp(-t * 40.0);
      amplitude = 12000.0 * sin(2.0 * pi * freq * t) * env;
    } else {
      // Pleasant, soft drop
      // frequency drops from 300 to 150
      freq = 300.0 * exp(-t * 15.0);
      env = exp(-t * 30.0);
      amplitude = 15000.0 * sin(2.0 * pi * freq * t) * env;
    }
    
    int val = amplitude.toInt();
    if (val > 32767) val = 32767;
    if (val < -32768) val = -32768;
    
    builder.add(_int16ToBytes(val));
  }
  
  final file = File(path);
  await file.writeAsBytes(builder.toBytes(), flush: true);
  print('Generated $path');
}

List<int> _int32ToBytes(int value) {
  var bdata = ByteData(4);
  bdata.setInt32(0, value, Endian.little);
  return bdata.buffer.asUint8List();
}

List<int> _int16ToBytes(int value) {
  var bdata = ByteData(2);
  bdata.setInt16(0, value, Endian.little);
  return bdata.buffer.asUint8List();
}
