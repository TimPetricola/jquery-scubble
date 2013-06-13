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

### Options
```javascript
{
  content: 'body', // Element containing the text
  speed: 200, // Reading speed (in words/minute)
  strings: { // You can use {min} and {sec} placeholders to show time left
    main: '{min} minutes left',
    lastMinute: '1 minute left',
    lastSeconds: 'Less than 1 minute left',
    end: 'Thank you'
  }
}
```
