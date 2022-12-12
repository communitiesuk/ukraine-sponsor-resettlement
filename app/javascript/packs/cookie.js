
(function(Modules) {
    'use strict'

    function CookieModule ($module) {
        this.$module = $module;

    }
    CookieModule.prototype.init = function($module) {   
        console.log('INIT CALLED')
        console.log(this.$module)
        // this.startModule = this.startModule.bind(this)
        // window.addEventListener('cookie-module', this.startModule)
    }

    Modules.CookieModule = CookieModule

    document.addEventListener('DOMContentLoaded', function () {
        const nodes = document.querySelectorAll('.govuk-cookie-banner')
        console.log(nodes , 'nodesss')
        for (var i = 0, length = nodes.length; i < length; i++) {
          new CookieModule(nodes[i]).init();
        }
      });
  })(window.GOVUK.Modules)