window.SC = SC.Helper.merge SC || {},
  _soundmanagerPath: "/soundmanager2/"
  _soundmanagerScriptPath: "soundmanager2.js"
  whenStreamingReady: (callback) ->
    if window.soundManager
      callback()
    else
      soundManagerURL = @.options.baseUrl + @._soundmanagerPath
      window.SM2_DEFER = true;
      SC.Helper.loadJavascript soundManagerURL + @_soundmanagerScriptPath, ->
        window.soundManager = new SoundManager()
        soundManager.url = soundManagerURL;
        soundManager.flashVersion = 9;
        soundManager.useFlashBlock = false;
        soundManager.useHTML5Audio = false;
        soundManager.beginDelayedInit()
        soundManager.onready ->
          callback()

  _prepareStreamUrl: (idOrUrl) ->
    if idOrUrl.toString().match /^\d.*$/ # legacy rewrite from id to path
      url = "/tracks/" + idOrUrl
    else
      url = idOrUrl
    preparedUrl = SC.prepareRequestURI(url)
    preparedUrl.path += "/stream" if !preparedUrl.path.match(/\/stream/)
    preparedUrl.toString()

  stream: (track, options={}) ->
    trackId = track
    # track can be id, relative, absolute
    SC.whenStreamingReady ->
      options.id = "T" + trackId + "-" + Math.random()
      options.url = "http://" + SC.hostname("api") + "/tracks/" + trackId + "/stream?client_id=" + SC.options.client_id
      sound = soundManager.createSound(options)
      sound

  streamStopAll: ->
    if window.soundManager?
      window.soundManager.stopAll()