var recLength = 0,
  recBuffers = [],
  sampleRate;

this.onmessage = function(e){
  console.log("Worker got a message:", e.data.command);
  switch(e.data.command){
    case 'init':
      init(e.data.config);
      break;
    case 'record':
      record(e.data.buffer);
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
};

function record(inputBuffer){
  recBuffers.push(inputBuffer);
  recLength += inputBuffer.length;
};

function getBuffer() {
  this.postMessage(mergeBuffers(recBuffers, recLength));
  this.clear()
};

function clear(){
  recLength = 0;
  recBuffers = [];
};

function mergeBuffers(recBuffers, recLength){
  var result = new Float32Array(recLength);
  var offset = 0;
  for (var i = 0; i < recBuffers.length; i++){
    result.set(recBuffers[i], offset);
    offset += recBuffers[i].length;
  }
  return result;
};
