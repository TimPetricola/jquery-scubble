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
    breakpoints:
      'more': '{min} minutes left'
      '1:59': '1 minute left'
      '59': 'Less than 1 minute left'
      '0': 'Thank you'
    parser: (breakpoint) ->
      match = breakpoint.match /^(?:(\d*):)?(\d*)$/
      throw new SyntaxError("Invalid 'min:sec' format: '#{breakpoint}'") unless match
      (parseInt(match[1],10) || 0)*60 + parseInt(match[2], 10)

  class Scubble
    constructor: (el, options) ->
      @options  = $.extend({}, _defaults, options)
      
      @$bubble   = $(el).hide()
      @$content  = $(@options.content)
      
      Time.prototype.strings = @options.strings
      Time.prototype.breakpoints = @setBreakpoints()

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

    setBreakpoints: ->
      rawBreakpoints = $.extend({}, @options.breakpoints)
      @breakpoints = {}

      @breakpoints[Infinity] = rawBreakpoints['more'] || _defaults.breakpoints['more']
      delete rawBreakpoints['more']
      for breakpoint, value of rawBreakpoints
        seconds = @options.parser(breakpoint)
        @breakpoints[seconds] = value
        
      @breakpoints


  class Time
    constructor: (seconds) ->
      @seconds = seconds

    m: ->
      Math.floor(@seconds / 60)

    s: ->
      @seconds % 60

    readingString: ->
      keys = (k for k of @breakpoints)
      keys = keys.sort (a, b) ->
        a - b

      for k in keys
        return @format(@breakpoints[k]) if @seconds <= k
      
    format: (string) ->
      string
        .replace('{min}', @m())
        .replace('{s}', @s())
  
  $.fn.scubble = (options) ->
    @each ->
      $el = $(this)
      unless $el.data('scubble')
        bubble = new Scubble(this, options) 
        $el.data('scubble', bubble)
    @

) jQuery, window, document
