###
jQuery Scubble plugin
Source: http://github.com/TimPetricola/jquery-scubble

Licensed under the MIT License
http://opensource.org/licenses/MIT
###

(($, window, document) ->
 
  _defaults = 
    content: 'body'
    speed: 200
    strings:
      main: '{min} minutes left'
      lastMinute: '1 minute left'
      lastSeconds: 'Less than 1 minute left'
      end: 'Thank you'
 
  class Scubble
    constructor: (el, options) ->
      @options  = $.extend(true, {}, _defaults, options)

      @$bubble   = $(el)
      @$content  = $(@options.content)
      
      Time.prototype.strings = @options.strings
      
      @$bubble.hide()
      
      $(window).on 'scroll', => @scroll()

    scroll: ->
      offsets = @offsets()

      scrollTop = $(document).scrollTop()
      position = offsets.bubble.current

      if offsets.content.top > scrollTop and offsets.bubble.first > position
        position = offsets.bubble.first

      if position > offsets.bubble.last
        position = offsets.bubble.last 
      
      position = Math.round(position)
      
      pxProgress = scrollTop - offsets.content.top
      pxProgress = 0 if pxProgress < 0
      progress   = pxProgress / offsets.content.height
      timeLeft   = new Time((1-progress) * @timeToRead())
      
      @$bubble
        .text(timeLeft.readingString())
        .css('top', position)
        .fadeIn(200)
      
      clearTimeout(@timer) if @timer?
      @timer = setTimeout =>
        @$bubble.fadeOut(200)
      , 1000
    
    timeToRead: ->
      total = 0
      text  = @getText(@$content)
      words = text.split(/\s+/)
      words = $.grep words, (n) -> n
      
      timeLeft = 60 * words.length / @options.speed
      Math.round(timeLeft)

    getText: ($el) ->
      $el.text()
    
    offsets: ->
      viewportHeight  = $(window).height()
      documentHeight  = $(document).height()
      progress        = $(window).scrollTop() / (documentHeight - viewportHeight)
      scrollbarHeight = viewportHeight / documentHeight * viewportHeight
      bubbleHeight    = @$bubble.height()

      offsets =
        content:
          top: @$content.offset().top
          height: @$content.height()
        bubble:
          first: @$content[0].getBoundingClientRect().top
          current: null
          last: null

      offsets.bubble.last    = offsets.bubble.first + offsets.content.height - bubbleHeight
      offsets.bubble.current = progress * (viewportHeight - scrollbarHeight) + (scrollbarHeight - bubbleHeight) / 2

      offsets

  class Time
    constructor: (seconds) ->
      @m = Math.floor(seconds/60)
      @s = seconds % 60
  
    readingString: ->
      if @m < 1 and @s < 20
        @format @strings.end
      else if @m < 1
        @format @strings.lastSeconds
      else if @m == 1
        @format @strings.lastMinute
      else
        @format @strings.main
    
    format: (string) ->
      string
        .replace('{min}', @m)
        .replace('{s}', @s)
  
  $.fn.scubble = (options) ->
    @each ->
      $el = $(this)
      unless $el.data('scubble')
        bubble = new Scubble(this, options) 
        $el.data('scubble', bubble)
    @

) jQuery, window, document
