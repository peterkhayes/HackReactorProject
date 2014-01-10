(function(window){

  var WORKER_PATH = 'lib/recorderWorker.js';

  var Recorder = function(source){
    var bufferLen = 4096;
    this.context = source.context;
    this.node = this.context.createJavaScriptNode(bufferLen, 1, 1);
    var worker = new Worker(WORKER_PATH);
    console.log(worker);
    worker.postMessage({
      command: 'init',
      config: {
        sampleRate: this.context.sampleRate
      }
    });
    var recording = false,
      currCallback;

    this.node.onaudioprocess = function(e){
      if (!recording) return;
      worker.postMessage({
        command: 'record',
        buffer: e.inputBuffer.getChannelData(0)
      });
    };

    this.configure = function(cfg){
      for (var prop in cfg){
        if (cfg.hasOwnProperty(prop)){
          config[prop] = cfg[prop];
        }
      }
    };

    this.record = function(){
      recording = true;
    };

    this.stop = function(){
      recording = false;
    };

    this.clear = function(){
      worker.postMessage({ command: 'clear' });
    };

    this.getBuffer = function(cb) {
      console.log(cb);
      currCallback = cb || config.callback;
      worker.postMessage({ command: 'getBuffer' });
    };

    worker.onmessage = function(e){
      var blob = e.data;
      currCallback(blob);
    }

    source.connect(this.node);
    this.node.connect(this.context.destination);    //this should not be necessary
  };

  window.Recorder = Recorder;

})(window);
