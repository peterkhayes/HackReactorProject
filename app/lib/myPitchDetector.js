/* An Javascript port of Tarsos's JAVA implementation
 * of the YIN pitch detection algorithm, created by
 * Joren Six of University College Ghent.
 *
 * Find the original project at
 * http://tarsos.0110.be/tag/TarsosDSP
 * or on Github at
 * https://github.com/JorenSix/TarsosDSP
 */

// Constructor function for the a YIN pitch dectector.
var makeYIN = function(config) {

  config = config || {};

  var YIN = {};

  var DEFAULT_THRESHOLD = 0.20,
      DEFAULT_BUFFER_SIZE = 2048,
      DEFAULT_OVERLAP = 1536,
      DEFAULT_SAMPLE_RATE = 44100,
      threshold = config.threshold || DEFAULT_THRESHOLD,
      sampleRate = config.sampleRate || DEFAULT_SAMPLE_RATE,
      bufferSize = config.bufferSize || DEFAULT_BUFFER_SIZE,
      yinBuffer = new Float32Array(bufferSize / 2),
      bufferLength = bufferSize / 2,
      result = {};

  // Implements the difference function as described in step 2 of the YIN paper.
  var difference = function(float32AudioBuffer) {
    var index, delta;
    for (var tau = 0; tau < bufferLength; tau++) {
      yinBuffer[tau] = 0;
    }
    for (tau = 1; tau < bufferLength; tau++) {
      for (index = 0; index < bufferLength; index++) {
        delta = float32AudioBuffer[index] - float32AudioBuffer[index + tau];
        yinBuffer[tau] += delta * delta;
      }
    }
  };

  // Implements the cumulative mean normalized difference as described in step 3 of the paper.
  var cumulativeMeanNormalizedDifference = function() {
    yinBuffer[0] = 1;
    yinBuffer[1] = 1;
    var runningSum = 0;
    for (var tau = 1; tau < bufferLength; tau++) {
      runningSum += yinBuffer[tau];
      yinBuffer[tau] *= tau / runningSum;
    }
  };

  var absoluteThreshold = function() {
    // Since the first two positions in the array are 1,
    // we can start at the third position.
    for (var tau = 2; tau < bufferLength; tau++) {
      if (yinBuffer[tau] < threshold) {
        while (tau + 1 < bufferLength && yinBuffer[tau + 1] < yinBuffer[tau]) {
          tau++;
        }
        // found tau, exit loop and return
        // store the probability
        // From the YIN paper: The threshold determines the list of
        // candidates admitted to the set, and can be interpreted as the
        // proportion of aperiodic power tolerated
        // within a periodic signal.
        //
        // Since we want the periodicity and and not aperiodicity:
        // periodicity = 1 - aperiodicity
        result.probability = 1 - yinBuffer[tau];
        break;
      }
    }

    // if no pitch found, set tau to -1
    if (tau == bufferLength || yinBuffer[tau] >= threshold) {
      tau = -1;
      result.probability = 0;
      result.foundPitch = false;
    } else {
      result.foundPitch = true;
    }

    return tau;
  };

  /**
   * Implements step 5 of the AUBIO_YIN paper. It refines the estimated tau
   * value using parabolic interpolation. This is needed to detect higher
   * frequencies more precisely. See http://fizyka.umk.pl/nrbook/c10-2.pdf and
   * for more background
   * http://fedc.wiwi.hu-berlin.de/xplore/tutorials/xegbohtmlnode62.html
   */

  var parabolicInterpolation = function(tauEstimate) {
    var betterTau,
        x0,
        x2;

    if (tauEstimate < 1) {
      x0 = tauEstimate;
    } else {
      x0 = tauEstimate - 1;
    }
    if (tauEstimate + 1 < bufferLength) {
      x2 = tauEstimate + 1;
    } else {
      x2 = tauEstimate;
    }
    if (x0 == tauEstimate) {
      if (yinBuffer[tauEstimate] <= yinBuffer[x2]) {
        betterTau = tauEstimate;
      } else {
        betterTau = x2;
      }
    } else if (x2 == tauEstimate) {
      if (yinBuffer[tauEstimate] <= yinBuffer[x0]) {
        betterTau = tauEstimate;
      } else {
        betterTau = x0;
      }
    } else {
      var s0, s1, s2;
      s0 = yinBuffer[x0];
      s1 = yinBuffer[tauEstimate];
      s2 = yinBuffer[x2];
      // fixed AUBIO implementation, thanks to Karl Helgason:
      // (2.0f * s1 - s2 - s0) was incorrectly multiplied with -1
      betterTau = tauEstimate + (s2 - s0) / (2 * (2 * s1 - s2 - s0));
    }
    return betterTau;
  };


  // Return the pitch of a given signal, or -1 if none is detected.
  YIN.getPitch = function(float32AudioBuffer) {

    // Step 2
    difference(float32AudioBuffer);

    // Step 3
    cumulativeMeanNormalizedDifference();

    // Step 4
    var tauEstimate = absoluteThreshold();

    // Step 5
    if (tauEstimate != -1) {

      var betterTau = parabolicInterpolation(tauEstimate);

      // TODO: optimization!

      result.freq = sampleRate / betterTau;

    } else {

      result.freq = -1;

    }

    // Good luck!
    return result;
  };

  return YIN;

};