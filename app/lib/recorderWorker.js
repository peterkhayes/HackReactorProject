var recLength = 0,
  recBuffers = [],
  sampleRate;

this.onmessage = function(e){
  switch(e.data.command){
    case 'init':
      init(e.data.config);
      break;
    case 'record':
      record(e.data.buffer);
      break;
    case 'breakIntoMidiChunks':
      breakIntoMidiChunks(e.data.tempo);
      break;
    case 'getBuffer':
      getBuffer();
      break;
    case 'clear':
      clear();
      break;
  }
};

function init(config){
  sampleRate = config.sampleRate;
}

function record(inputBuffer){
  recBuffers.push(inputBuffer);
  recLength += inputBuffer.length;
}

// function breakIntoMidiChunks(tempo) {
//   // Get a single buffer of all the audio we recorded.
//   var buffer = mergeBuffers(recBuffers, recLength);

//   // Divided this buffer into chunks, each with one 16th note of audio.
//   var chunks = [];
//   var chunkLength = Math.round(165375/tempo);
//   var end = recLength - chunkLength;
//   for (var i = 0; i < end; i += chunkLength) {
//     chunks.push(buffer.subarray(i, i+chunkLength));
//   }
  
//   this.postMessage(chunks);
// }

function getBuffer() {
  this.postMessage(mergeBuffers(recBuffersL, recLength));
  this.clear()
}

function clear(){
  recLength = 0;
  recBuffers = [];
}

function mergeBuffers(recBuffers, recLength){
  var result = new Float32Array(recLength);
  var offset = 0;
  for (var i = 0; i < recBuffers.length; i++){
    result.set(recBuffers[i], offset);
    offset += recBuffers[i].length;
  }
  return result;
}
