# Hybirds

## Todo:

- [x] set window.isHybird = true
- [x] set window.isIOS = true
- [x] set window.sendNative fn
- [x] change statusBar style
- [x] hidden/show statusBar
- [x] change viewController backgroundColor
- [x] change WKWebview URL
- [ ] load app-uuid
- [ ] add ApplePay
- [ ] set WKWebview Keyboard like native
- [ ] push in QRCode and seach callback


## How to use in JS?

Copy hybird.js in your react-project:

```js
// index.js
import hybird from './hybird';
hybird.vconsole(true);
window.onload = hybird.onload(()=>{
  import('./app').then(()=>{
  })
})
```

```js
// app.js
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './Home';
import hybird from './hybird';
ReactDOM.render(<App />, document.getElementById('root'));

hybird.webViewMarge({ full: false, top: 400 });
hybird.statusBarStyle({ style:'light' });
hybird.setBackground({
  hex: 0xff8888,
  alpha: 1,
});
```
