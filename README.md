# jQuery Scubble

Displays a bubble showing reading time left.

Inspired by [iA's blog](http://ia.net/blog/) (scroll to see it in action).

*Plugin totally not safe for production, not unit tested, not cross-browser tested and definetly not mobile tested... It's not even commented... Please don't hate me.*

* *Source:* https://github.com/TimPetricola/jquery-scubble
* *License:* MIT License
* *Author:* Tim Petricola

## Usage

Just open `index.html` in your browser to see a running example.

**HTML:**
```html
<div class="scubble"></div>
```

**Javascript:**
```javascript
$('.scubble').scubble();
```

**CSS:**
```css
.scubble {
  position: fixed;
}
```

### Basic options
```javascript
{
  content: 'body', // Element containing the text
  speed: 200,      // Reading speed (in words/minute)
  breakpoints: {   // You can use {min} and {sec} placeholders to show time left
    'more': '{min} minutes left',
    '1:59': '1 minute left',
    '0:59': 'Less than 1 minute left',
    '0':    'Thank you'
  }
}
```

### Even more options
* `parser`: a function parsing a breakpoint string and returning a number, in seconds. The default format is `min:sec` 
```javascript
{
  parser: function(breakpoint) {
    var min, parts, sec;
    parts = breakpoint.split(':');
    if (parts.length === 2) {
      min = parts[0];
      sec = parts[1];
    } else {
      min = 0;
      sec = parts[0];
    }
    return (parseInt(min, 10) || 0) * 60 + (parseInt(sec, 10) || 0);
  }
}
```
