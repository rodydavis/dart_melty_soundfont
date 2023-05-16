import 'synthesizer.dart';

class Lfo {
  final Synthesizer synthesizer;

  bool _active = false;

  double _delay = 0;
  double _period = 0;

  int _processedSampleCount = 0;
  double _value = 0;

  Lfo(this.synthesizer);

  void start(double delay, double frequency) {
    if (frequency > 1.0E-3) {
      _active = true;

      _delay = delay;
      _period = 1 / frequency;

      _processedSampleCount = 0;
      _value = 0;
    } else {
      _active = false;
      _value = 0;
    }
  }

  void process() {
    if (!_active) {
      return;
    }

    _processedSampleCount += synthesizer.blockSize;

    var currentTime = _processedSampleCount / synthesizer.sampleRate;

    if (currentTime < _delay) {
      _value = 0;
    } else {
      var phase = ((currentTime - _delay) % _period) / _period;
      if (phase < .25) {
        _value = 4 * phase;
      } else if (phase < .75) {
        _value = 4 * (.5 - phase);
      } else {
        _value = 4 * (phase - 1);
      }
    }
  }

  double get value => _value;
}
