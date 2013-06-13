// Generated by CoffeeScript 1.6.1

/*
jQuery Scubble plugin
Source: http://github.com/TimPetricola/jquery-scubble

Licensed under the MIT License
http://opensource.org/licenses/MIT
*/


(function() {

  (function($, window, document) {
    var Scubble, Time, _defaults;
    _defaults = {
      content: 'body',
      speed: 200,
      strings: {
        main: '{min} minutes left',
        lastMinute: '1 minute left',
        lastSeconds: 'Less than 1 minute left',
        end: 'Thank you'
      }
    };
    Scubble = (function() {

      function Scubble(el, options) {
        var _this = this;
        this.options = $.extend(true, {}, _defaults, options);
        this.$bubble = $(el);
        this.$content = $(this.options.content);
        Time.prototype.strings = this.options.strings;
        this.$bubble.hide();
        $(window).on('scroll', function() {
          return _this.scroll();
        });
      }

      Scubble.prototype.scroll = function() {
        var offsets, position, progress, pxProgress, scrollTop, timeLeft,
          _this = this;
        offsets = this.offsets();
        scrollTop = $(document).scrollTop();
        position = offsets.bubble.current;
        if (offsets.content.top > scrollTop && offsets.bubble.first > position) {
          position = offsets.bubble.first;
        }
        if (position > offsets.bubble.last) {
          position = offsets.bubble.last;
        }
        position = Math.round(position);
        pxProgress = scrollTop - offsets.content.top;
        if (pxProgress < 0) {
          pxProgress = 0;
        }
        progress = pxProgress / offsets.content.height;
        timeLeft = new Time((1 - progress) * this.timeToRead());
        this.$bubble.text(timeLeft.readingString()).css('top', position).fadeIn(200);
        if (this.timer != null) {
          clearTimeout(this.timer);
        }
        return this.timer = setTimeout(function() {
          return _this.$bubble.fadeOut(200);
        }, 1000);
      };

      Scubble.prototype.timeToRead = function() {
        var text, timeLeft, total, words;
        total = 0;
        text = this.getText(this.$content);
        words = text.split(/\s+/);
        words = $.grep(words, function(n) {
          return n;
        });
        timeLeft = 60 * words.length / this.options.speed;
        return Math.round(timeLeft);
      };

      Scubble.prototype.getText = function($el) {
        return $el.text();
      };

      Scubble.prototype.offsets = function() {
        var bubbleHeight, documentHeight, offsets, progress, scrollbarHeight, viewportHeight;
        viewportHeight = $(window).height();
        documentHeight = $(document).height();
        progress = $(window).scrollTop() / (documentHeight - viewportHeight);
        scrollbarHeight = viewportHeight / documentHeight * viewportHeight;
        bubbleHeight = this.$bubble.height();
        offsets = {
          content: {
            top: this.$content.offset().top,
            height: this.$content.height()
          },
          bubble: {
            first: this.$content[0].getBoundingClientRect().top,
            current: null,
            last: null
          }
        };
        offsets.bubble.last = offsets.bubble.first + offsets.content.height - bubbleHeight;
        offsets.bubble.current = progress * (viewportHeight - scrollbarHeight) + (scrollbarHeight - bubbleHeight) / 2;
        return offsets;
      };

      return Scubble;

    })();
    Time = (function() {

      function Time(seconds) {
        this.m = Math.floor(seconds / 60);
        this.s = seconds % 60;
      }

      Time.prototype.readingString = function() {
        if (this.m < 1 && this.s < 20) {
          return this.format(this.strings.end);
        } else if (this.m < 1) {
          return this.format(this.strings.lastSeconds);
        } else if (this.m === 1) {
          return this.format(this.strings.lastMinute);
        } else {
          return this.format(this.strings.main);
        }
      };

      Time.prototype.format = function(string) {
        return string.replace('{min}', this.m).replace('{s}', this.s);
      };

      return Time;

    })();
    return $.fn.scubble = function(options) {
      this.each(function() {
        var $el, bubble;
        $el = $(this);
        if (!$el.data('scubble')) {
          bubble = new Scubble(this, options);
          return $el.data('scubble', bubble);
        }
      });
      return this;
    };
  })(jQuery, window, document);

}).call(this);
