# How to use?

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
