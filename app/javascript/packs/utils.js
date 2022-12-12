

(function () {
    "use strict";
  
    Utils = window.Utils = {};
  
    Utils.ALL_COOKIES = {
      "analytics": true,
    };
  
    Utils.ESSENTIAL_COOKIES = {
      "essential": true,
      "usage": false,
      "campaigns": false,
      "settings": false
    };
  
    Utils.acceptedAdditionalCookies = function (status) {
      var responded = false, acceptedAdditionalCookies = false;
      for (var key in status) {
        if (status.hasOwnProperty(key)) {
          responded = true;
          if (key !== "essential") {
            acceptedAdditionalCookies ||= status[key];
          }
        }
      }
      return {responded: responded, acceptedAdditionalCookies: acceptedAdditionalCookies};
    };
  
  
    Utils.getCookie = function (name, defaultValue) {
      name += "=";
      const cookies = document.cookie.split(";");
      for (var index = 0; cookies.length > index; index++) {
        if (cookies[index].trim().slice(0, name.length) === name) {
          return decodeURIComponent(cookies[index].trim().slice(name.length));
        }
      }
      return defaultValue ? defaultValue : null;
    };
  
    Utils.setCookie = function (name, value, options) {
      options = (options || {});
      var cookieString = name.concat("=", value, "; path=/");
      if (options.days) {
        const expiryDate = new Date()
        expiryDate.setTime(expiryDate.getTime() + (options.days * 24 * 60 * 60 * 1000));
        cookieString += "; expires=".concat(expiryDate.toGMTString());
      }
      if (document.location.protocol === "https:") {
        cookieString += "; Secure";
      }
      document.cookie = cookieString;
    };
  


  })();