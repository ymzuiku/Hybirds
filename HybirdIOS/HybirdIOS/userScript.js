try {
    window.webkit.messageHandlers.Native.postMessage('fisrt-connect-from-web');
    isHaveNaitvePostMessage = true;
  } catch (error) {
    isHaveNaitvePostMessage = false;
  }
  function sendNative(str) {
    if (isHaveNaitvePostMessage) {
      window.webkit.messageHandlers.Native.postMessage(str);
    } else {
      console.log('[Error]nativePostMessage:', str);
    }
  }
  window.sendNative = sendNative
