window.onerror = (e) ->
  console.log(e.stack)

require 'coffee-react/register'
path = require 'path-extra'
fs = require 'fs-extra'
os = require 'os'
semver = require 'semver'
glob = require 'glob'
aesjs = require 'aes-js'

# Environments
window.remote = require('electron').remote
Object.assign window, require('../paths')
window.POI_VERSION = remote.getGlobal 'POI_VERSION'
window.SERVER_HOSTNAME = remote.getGlobal 'SERVER_HOSTNAME'
window.PLUGIN_PATH = path.join window.APPDATA_PATH, 'plugins'
window.appIcon = remote.getGlobal 'appIcon'
fs.ensureDirSync window.PLUGIN_PATH
fs.ensureDirSync path.join window.PLUGIN_PATH, 'node_modules'
window._portStorageUpdated = true

# Shortcuts and Components
(window.dbg = require path.join(ROOT, 'lib', 'debug')).init()
window._ = require 'underscore'
window.$ = (param) -> document.querySelector(param)
window.$$ = (param) -> document.querySelectorAll(param)
window.jQuery = require 'jquery'
window.React = require 'react'
window.ReactDOM = require 'react-dom'
window.ReactBootstrap = require 'react-bootstrap'
window.FontAwesome = require 'react-fontawesome'
{remoteStringify} = remote.require './lib/utils'

$('#fontawesome-css')?.setAttribute 'href', require.resolve 'font-awesome/css/font-awesome.css'

# Utils
Object.clone = (obj) ->
  JSON.parse JSON.stringify obj
Object.remoteClone = (obj) ->
  JSON.parse remoteStringify obj

pad = (n) ->
  if n < 10 then "0#{n}" else n
window.resolveTime = (seconds) ->
  seconds = parseInt seconds
  if seconds >= 0
    s = seconds % 60
    m = Math.trunc(seconds / 60) % 60
    h = Math.trunc(seconds / 3600)
    "#{pad h}:#{pad m}:#{pad s}"
  else
    ''
window.timeToString = (milliseconds) ->
  date = new Date(milliseconds)
  date.toTimeString().slice(0, 8)  # HH:mm:ss

window.defaultTo = (val, defaultVal) ->
  if val? then val else defaultVal

## window.notify
# msg=null: Sound-only notification.
NOTIFY_DEFAULT_ICON = path.join(ROOT, 'assets', 'icons', 'icon.png')
NOTIFY_NOTIFICATION_API = true
if process.platform == 'win32' and semver.lt(os.release(), '6.2.0')
  NOTIFY_NOTIFICATION_API = false
notify_isPlayingAudio = {}
window.notify = (msg, options) ->
  # Notification config
  enabled = config.get('poi.notify.enabled', true)
  volume = config.get('poi.notify.volume', 0.8)
  title = 'poi'
  icon = NOTIFY_DEFAULT_ICON
  audio = config.get('poi.notify.audio', "file://#{ROOT}/assets/audio/poi.mp3")
  type = options?.type || "others"

  if type in ['construction', 'expedition', 'repair', 'morale']
    enabled = config.get("poi.notify.#{type}.enabled", enabled) if enabled
    audio = config.get("poi.notify.#{type}.audio", audio)
  else
    enabled = config.get("poi.notify.others.enabled", enabled) if enabled
  # Overwrite by options
  if options?
    title = options.title if options.title
    icon = options.icon if options.icon
    audio = options.audio if options.audio

  # Send desktop notification
  #   According to MDN Notification API docs: https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification
  #   Parameter `sound` is not supported in any browser yet, so we play sound manually.
  return unless enabled
  if msg?
    if NOTIFY_NOTIFICATION_API
      new Notification title,
        icon: "file://#{icon}"
        body: msg
        silent: true
    else
      try
        appIcon.displayBalloon
          title: title
          icon: icon
          content: msg
        appIcon.on 'balloon-click', remote.getGlobal('mainWindow').focus

  if volume > 0.0001
    sound = new Audio(audio)
    sound.volume = volume
    sound.oncanplaythrough = ->
      if !notify_isPlayingAudio[type]
        notify_isPlayingAudio[type] = true
        sound.play()
    sound.onended = ->
      notify_isPlayingAudio[type] = false

modals = []
window.modalLocked = false
window.toggleModal = (title, content, footer) ->
  modals.push
    title: title
    content: content
    footer: footer
  window.showModal() if !window.modalLocked
window.showModal = ->
  return if modals.length == 0
  {title, content, footer} = modals.shift()
  event = new CustomEvent 'poi.modal',
    bubbles: true
    cancelable: true
    detail:
      title: title
      content: content
      footer: footer
  window.dispatchEvent event

# Node modules
window.config = require '../lib/config'
window.ipc = remote.require './lib/ipc'
window.proxy = remote.require './lib/proxy'
window.CONST = Object.remoteClone remote.require './lib/constant'

checkLayout = (layout) ->
  if layout isnt 'horizontal' and layout isnt 'vertical' and layout isnt 'L'
    layout = 'horizontal'
    config.set 'poi.layout', layout
  layout

# User configs
language = navigator.language
if !(language in ['zh-CN', 'zh-TW', 'ja-JP', 'en-US'])
  switch language.substr(0,1).toLowerCase()
    when 'zh'
      language = 'zh-TW'
    when 'ja'
      language = 'ja-JP'
    else
      language = 'en-US'
window.layout = checkLayout(config.get 'poi.layout', 'horizontal')
window.doubleTabbed = config.get 'poi.tabarea.double', false
window.webviewWidth = config.get 'poi.webview.width', -1
window.webviewFactor = 1
window.language = config.get 'poi.language', language
window.zoomLevel = config.get 'poi.zoomLevel', 1
window.useSVGIcon = config.get 'poi.useSVGIcon', false
d = if process.platform == 'darwin' then path.join(path.homedir(), 'Pictures', 'Poi') else path.join(global.APPDATA_PATH, 'screenshots')
window.screenshotPath = config.get 'poi.screenshotPath', d
window.notify.morale = config.get 'poi.notify.morale.value', 49
window.notify.expedition = config.get 'poi.notify.expedition.value', 60

# i18n config
window.i18n = {}
i18nFiles = glob.sync(path.join(__dirname, '..', 'i18n', '*'))
for i18nFile in i18nFiles
  namespace = path.basename i18nFile
  window.i18n[namespace] = new (require 'i18n-2')
    locales: ['en-US', 'ja-JP', 'zh-CN', 'zh-TW'],
    defaultLocale: 'zh-CN',
    directory: i18nFile,
    updateFiles: false,
    indent: "\t",
    extension: '.json'
    devMode: false
  window.i18n[namespace].setLocale(window.language)
window.i18n.resources = {}
window.i18n.resources.__ = (str) -> return str
window.i18n.resources.translate = (locale, str) -> return str
window.i18n.resources.setLocale = (str) -> return

# Alert helpers.
#   Requires: window.i18n
{newAlert} = require './components/info/alert'
DEFAULT_STICKYFOR = 3*1000  # Milliseconds
window.log = (msg, options) -> newAlert Object.assign
  message: msg
  type: 'default'
  priority: 0
  stickyFor: DEFAULT_STICKYFOR
  , options
window.success = (msg, options) -> newAlert Object.assign
  message: msg
  type: 'success'
  priority: 1
  stickyFor: DEFAULT_STICKYFOR
  , options
window.warn = (msg, options) -> newAlert Object.assign
  message: msg
  type: 'warning'
  priority: 2
  stickyFor: DEFAULT_STICKYFOR
  , options
window.error = (msg, options) -> newAlert Object.assign
  message: msg
  type: 'warning'
  priority: 4
  stickyFor: DEFAULT_STICKYFOR
  , options

#Custom css
window.reloadCustomCss = ->
  $('#custom-css')?.setAttribute 'href', "file://#{EXROOT}/hack/custom.css"

# Custom theme
# You should call window.applyTheme() to apply a theme properly.
window.loadTheme = (th) ->
  window.theme = th
  window.isDarkTheme = /(dark|black|slate|superhero|papercyan)/i.test th
  if theme == '__default__'
    $('#bootstrap-css')?.setAttribute 'href', "file://#{ROOT}/components/bootstrap/dist/css/bootstrap.css"
  else
    $('#bootstrap-css')?.setAttribute 'href', "file://#{ROOT}/../external/themes/#{theme}/css/#{theme}.css"
  window.reloadCustomCss()
window.applyTheme = (th) ->
  config.set 'poi.theme', th
  window.loadTheme th
  event = new CustomEvent 'theme.change',
    bubbles: true
    cancelable: true
    detail:
      theme: th
  window.dispatchEvent event

window.allThemes = ['__default__'].concat(require('glob').sync("#{ROOT}/../external/themes/*/").map (dirPath) -> path.basename(dirPath))
config.setDefault 'poi.theme', 'paperdark'
window.loadTheme(config.get 'poi.theme', 'paperdark')

# Not sure where this function should go, leave it here just for now, for easy access.
window.getCondStyle = (cond) ->
  # Options: 53, 50, 49, 40, 30, 20, 0
  s = 'poi-ship-cond-'
  if cond > 49
    s += '53'
  else if cond == 49
    s += '49'
  else if cond > 20
    s += '40'
  else if cond > 5
    s += '20'
  else
    s += '0'
  s += if isDarkTheme then ' dark' else ' light'

# Global data resolver

isGameApi = (domain) ->
  return domain == "http://static.touken-ranbu.jp"

handleProxyGameOnRequest = (method, [domain, path], body) ->
  return if !isGameApi(domain)
  # Parse the json object
  try
    body = JSON.parse body
    event = new CustomEvent 'game.request',
      bubbles: true
      cancelable: true
      detail:
        method: method
        path: path
        body: body
    window.dispatchEvent event
  catch e
    console.log e

envKeyList = ['_teitokuLv', '_nickName', '_nickNameId', '_teitokuExp', '_teitokuId', '_slotitems', '_ships', '_decks', '_ndocks']
start2Version = 0
initStart2Value = ->
  if localStorage.start2Version?
    start2Version = parseInt localStorage.start2Version
    # We need a hack to deal with Infinity for historical reasons.
    if start2Version > 0xFFFFFFFF
      start2Version = 0
      localStorage.start2Version = 0
  if localStorage.start2Body?
    body = JSON.parse localStorage.start2Body
    window.$ships = []
    $ships[ship.api_id] = ship for ship in body.api_mst_ship
    window.$shipTypes = []
    $shipTypes[stype.api_id] = stype for stype in body.api_mst_stype
    window.$slotitems = []
    $slotitems[slotitem.api_id] = slotitem for slotitem in body.api_mst_slotitem
    window.$slotitemTypes = []
    $slotitemTypes[slotitemtype.api_id] = slotitemtype for slotitemtype in body.api_mst_slotitem_equiptype
    window.$mapareas = []
    $mapareas[maparea.api_id] = maparea for maparea in body.api_mst_maparea
    window.$maps = []
    $maps[map.api_id] = map for map in body.api_mst_mapinfo
    window.$missions = []
    $missions[mission.api_id] = mission for mission in body.api_mst_mission
    window.$useitems = []
    $useitems[useitem.api_id] = useitem for useitem in body.api_mst_useitem
  for key in envKeyList
    if localStorage[key]? then window[key] = JSON.parse localStorage[key]
initStart2Value()

responses = []
locked = false
resolveResponses = ->
  locked = true
  while responses.length > 0
    [method, path, body, postBody] = responses.shift()
    event = new CustomEvent 'game.response',
      bubbles: true
      cancelable: true
      detail:
        method: method
        path: path
        body: body
        postBody: postBody
    window.dispatchEvent event
  locked = false

handleProxyGameOnResponse = (method, [domain, path], body, postBody) ->
  return if !isGameApi(domain)
  # Parse the json object
  try
    body = JSON.parse(body)
    return if body.status isnt 0
    responses.push [method, path, body, JSON.parse(postBody)]
    resolveResponses() if !locked
  catch e
    console.log e

handleProxyGameStart = ->
  window.dispatchEvent new Event 'game.start'

handleProxyGamePayitem = ->
  window.dispatchEvent new Event 'game.payitem'

handleProxyNetworkErrorRetry = (counter) ->
  event = new CustomEvent 'network.error.retry',
    bubbles: true
    cancelable: true
    detail:
      counter: counter
  window.dispatchEvent event

handleProxyNetworkInvalidCode = (code) ->
  event = new CustomEvent 'network.invalid.code',
    bubbles: true
    cancelable: true
    detail:
      code: code
  window.dispatchEvent event

handleProxyNetworkError = ->
  window.dispatchEvent new Event 'network.error'

proxyListener =
  'network.on.request': handleProxyGameOnRequest
  'network.on.response': handleProxyGameOnResponse
  'game.start': handleProxyGameStart
  'game.payitem': handleProxyGamePayitem
  'network.error.retry': handleProxyNetworkErrorRetry
  'network.invalid.code': handleProxyNetworkInvalidCode
  'network.error': handleProxyNetworkError

window.listenerStatusFlag = false

addProxyListener = ()->
  if not window.listenerStatusFlag
    window.listenerStatusFlag = true
    for eventName, handler of proxyListener
      proxy.addListener eventName, handler

addProxyListener()

window.addEventListener 'load', ->
  addProxyListener()

window.addEventListener 'unload', ->
  if window.listenerStatusFlag
    window.listenerStatusFlag = false
    for eventName, handler of proxyListener
      proxy.removeListener eventName, handler

window.decipherAes = (packet) ->
  hexStr2Buffer = (src, pad16) ->
    srcByteNum = Math.ceil(src.length/2)
    realLength = if pad16
        Math.ceil(srcByteNum/16) * 16
      else
        srcByteNum
    buf = Buffer realLength
    for i in [0...srcByteNum]
      buf.writeUInt8 parseInt(src.substr(i*2, 2), 16), i
    buf.fill 0, srcByteNum
    buf

  ascii2Buffer = (src) ->
    buf = Buffer src.length
    for i in [0...src.length]
      buf.writeUInt8 src.charCodeAt(i), i
    buf

  key="9ij8pNKv7qVJnpj4";
  datastream = hexStr2Buffer packet.data
  ivbuffer = hexStr2Buffer packet.iv
  keybuffer = ascii2Buffer key

  aesCbc = new aesjs.ModeOfOperation.cbc(keybuffer, ivbuffer);
  i = 0;
  result = ""
  while i < datastream.length
    result += aesjs.util.convertBytesToString aesCbc.decrypt datastream.slice(i, i+16)
    i += 16
  result.replace(/[\x00-\x1f]/g, '')
