const hybird = {
  vconsole: function(isShow = true, callback) {
    if (isShow === undefined) {
      isShow = process.env.NODE_ENV === 'development';
    }
    if (isShow) {
      import('vconsole').then(v => {
        if (v && v.default) {
          const vc = new v.default();
          if (callback) {
            callback(vc);
          }
        }
      });
    }
  },
  onload: function(promiseFn) {
    if (!window.sendNative) {
      window.sendNative = function(str) {
        console.log('[Error]nativePostMessage:', str);
      };
    }
    if (!window.hybird) {
      window.hybird = {};
    }
    promiseFn();
  },
  statusBarStyle: function(params = { style: 'black' }) {
    window.sendNative({
      ...params,
      fn: 'statusBarStyle',
    });
  },
  statusBarHidden: function(params = { isHidden: false }) {
    window.sendNative({
      ...params,
      fn: 'statusBarHidden',
    });
  },
  webViewMarge: function(
    params = {
      full: true,
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      callback: 'window.hybird.webViewMarge',
    },
  ) {
    window.sendNative({
      ...params,
      fn: 'webViewMarge',
    });
  },
  webViewLoadUrl: function(
    params = {
      url: 'http://www.baidu.com',
      isSaveLocal: false,
    },
  ) {
    window.sendNative({
      ...params,
      fn: 'webViewLoadUrl',
    });
  },
  setBackground: function(
    params = {
      hex: undefined,
      red: undefined,
      green: undefined,
      blue: undefined,
      alpha: 1.0,
    },
  ) {
    window.sendNative({
      ...params,
      fn: 'setBackground',
    });
  },
  goBack: function() {
    window.sendNative({
      fn: 'goBack',
    });
  },
};

export default hybird;
