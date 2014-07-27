(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View.Plugins = (function(_super) {
    __extends(Plugins, _super);

    function Plugins() {
      this.render = __bind(this.render, this);
      return Plugins.__super__.constructor.apply(this, arguments);
    }

    Plugins.prototype.el = '.content';

    Plugins.prototype.template = _.template($('#plugins').html());

    Plugins.prototype.render = function() {
      var content;
      if (document.readyState === 'loading') {
        $(window).on('load', this.render);
        return;
      }
      content = this.template({
        list: app.get('plugin').collection.toJSON()
      });
      return this.$el.html(content);
    };

    Plugins.prototype.initialize = function() {
      return app.get('plugin').on('new', this.listplugin);
    };

    Plugins.prototype.listplugin = function(model) {};

    return Plugins;

  })(Backbone.View);

}).call(this);
