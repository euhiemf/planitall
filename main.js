// Generated by CoffeeScript 1.7.1
(function() {
  var App, AppView, Clearer, Navigation, Plugin, PluginBluepint, PluginScriptImport, Plugins, PluginsSetting, Router, Views, fs, gui, path,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if (__indexOf.call(this, 'global') >= 0 && __indexOf.call(this, 'require') >= 0) {
    gui = require('nw.gui');
    path = './';
    fs = require('fs');
    fs.watch(path, function() {
      return typeof location !== "undefined" && location !== null ? location.reload() : void 0;
    });
  }

  PluginScriptImport = (function(_super) {
    __extends(PluginScriptImport, _super);

    function PluginScriptImport() {
      return PluginScriptImport.__super__.constructor.apply(this, arguments);
    }

    PluginScriptImport.prototype.initialize = function(model) {
      this.model = model;
      return this.on('change', (function(_this) {
        return function() {
          var attrs, key, val, _results;
          attrs = _this.changedAttributes();
          console.log(attrs);
          if (attrs) {
            _results = [];
            for (key in attrs) {
              val = attrs[key];
              _results.push(_this.trigger('loaded:' + key, val, _this.model, key));
            }
            return _results;
          }
        };
      })(this));
    };

    return PluginScriptImport;

  })(Backbone.Model);

  PluginsSetting = (function(_super) {
    __extends(PluginsSetting, _super);

    function PluginsSetting() {
      return PluginsSetting.__super__.constructor.apply(this, arguments);
    }

    PluginsSetting.prototype.initialize = function() {
      this.on('change', (function(_this) {
        return function() {
          return _this.save();
        };
      })(this));
      return this.on('change:active', (function(_this) {
        return function() {
          return _this.collection.trigger('toggle-active', _this);
        };
      })(this));
    };

    return PluginsSetting;

  })(Backbone.Model);

  Plugins = (function(_super) {
    __extends(Plugins, _super);

    function Plugins() {
      return Plugins.__super__.constructor.apply(this, arguments);
    }

    Plugins.prototype.localStorage = new Store('plugins-settings');

    Plugins.prototype.model = PluginsSetting;

    Plugins.prototype.initialize = function() {
      return this.fetch();
    };

    Plugins.prototype.add = function(model, options) {
      var filter;
      filter = {
        id: model.get('id'),
        title: model.get('title'),
        active: true
      };
      return Backbone.Collection.prototype.add.call(this, filter, options);
    };

    return Plugins;

  })(Backbone.Collection);

  PluginBluepint = (function(_super) {
    __extends(PluginBluepint, _super);

    function PluginBluepint() {
      return PluginBluepint.__super__.constructor.apply(this, arguments);
    }

    PluginBluepint.prototype.initialize = function() {
      this.set('model', this.bpm);
      this.set('view', this.bpv);
      return this.set('router', this.bpr);
    };

    PluginBluepint.prototype.render = function(context) {
      return (function(context) {
        return function() {
          var args, func;
          func = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          app.clearer.clear();
          func.apply(context, args);
          return app.clearer.add('unset', 'html', '.plugin');
        };
      })(context);
    };

    PluginBluepint.prototype.bpm = (function(_super1) {
      __extends(_Class, _super1);

      _Class.prototype['default-blueprint-properties'] = {
        navigatable: false,
        submenus: []
      };

      function _Class() {
        var dbp, id, number_of_plugins;
        number_of_plugins = app.get('plugin').collection.length;
        id = "" + (Math.random().toString(36).substr(2, 6)) + "-" + number_of_plugins;
        dbp = this['default-blueprint-properties'];
        dbp.title = "Plugin#" + id;
        dbp.id = id;
        dbp.imports = new PluginScriptImport(this);
        _.defaults(this.defaults, dbp);
        delete this['default-blueprint-properties'];
        Backbone.Model.apply(this, arguments);
      }

      return _Class;

    })(Backbone.Model);

    PluginBluepint.prototype.bpv = (function(_super1) {
      __extends(_Class, _super1);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.el = '.plugin';

      return _Class;

    })(Backbone.View);

    PluginBluepint.prototype.bpr = (function(_super1) {
      __extends(_Class, _super1);

      function _Class() {
        var baseurl, fullurlroute, key, model, val, _ref;
        model = this.model;
        this.model = model;
        fullurlroute = {};
        baseurl = 'plugin/view/' + this.model.get('id') + '/';
        _ref = this.routes;
        for (key in _ref) {
          val = _ref[key];
          fullurlroute[baseurl + key.replace(/(^(\.\/))|(^(\/))/, '')] = val;
        }
        this.routes = _.clone(fullurlroute);
        this.on('route', function() {});
        this.on('route', app.get('navigation').select);
        Backbone.Router.apply(this, arguments);
      }

      return _Class;

    })(Backbone.Router);

    return PluginBluepint;

  })(Backbone.Model);

  Plugin = (function(_super) {
    __extends(Plugin, _super);

    function Plugin() {
      this.getSettings = __bind(this.getSettings, this);
      return Plugin.__super__.constructor.apply(this, arguments);
    }

    Plugin.prototype.local = {};

    Plugin.prototype.global = {};

    Plugin.prototype.localAssets = {
      js: {},
      image: {},
      stylesheet: {},
      template: {}
    };

    Plugin.prototype.getAsset = function(type, path) {
      return this.localAssets[type][path];
    };

    Plugin.prototype.Blueprint = new PluginBluepint;

    Plugin.prototype.cachedFilesWithGlobals = [];

    Plugin.prototype.inCache = function(path) {
      return this.cachedFilesWithGlobals.indexOf(path) > -1;
    };

    Plugin.prototype.cache = function(path) {
      return this.cachedFilesWithGlobals.push(path);
    };

    Plugin.prototype.isAllGlobal = function(data) {
      var arrdata, global, _i, _len;
      global = true;
      if (Array.isArray(data)) {
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          arrdata = data[_i];
          if (this.isLocal(arrdata)) {
            global = false;
          }
        }
      } else {
        global = this.isGlobal(data);
      }
      return global;
    };

    Plugin.prototype.isGlobal = function(data) {
      return !data.local && data.global;
    };

    Plugin.prototype.isLocal = function(data) {
      return (!data.local && !data.global) || (data.local && !data.global);
    };

    Plugin.prototype["import"] = function(data) {
      var clear;
      if (!data.local && !data.global) {
        data.local = true;
      }
      if (data.local) {
        this.local[data["import"].name] = data["import"];
        clear = {};
        clear[data["import"].name] = this.local;
        return app.clearer.add('remove', 'object', clear);
      } else if (data.global) {
        if (this.global.hasOwnProperty(data["import"].name)) {
          return console.log('A key with the name of ' + data["import"].name + ' does already exist in global, will not import it!');
        } else {
          return this.global[data["import"].name] = data["import"];
        }
      }
    };

    Plugin.prototype.initialize = function() {
      this.collection = new Plugins;
      this.on('pre-render', this.preRender, this);
      this.on('post-render', this.postRender, this);
      return this.collection.on('toggle-active', (function(_this) {
        return function(model) {
          return _this.triggerNav(_this.get(model.get('id')));
        };
      })(this));
    };

    Plugin.prototype.getSettings = function(model) {
      return this.collection.findWhere({
        id: model.get('id')
      });
    };

    Plugin.prototype["new"] = function(model) {
      var instance;
      instance = new model;
      this.collection.add(instance);
      this.memorize(instance);
      return {
        view: this.view,
        router: this.router,
        model: instance
      };
    };

    Plugin.prototype.view = function(view) {
      var instance, model, ref;
      model = this.model;
      instance = new view({
        model: model
      });
      ref = instance.render || null;
      instance.render = (function(ref, instance, model) {
        return function() {
          var retu;
          app.get('plugin').trigger('pre-render', model);
          retu = ref != null ? ref.apply(instance, arguments) : void 0;
          app.get('plugin').trigger('post-render', model);
          return retu;
        };
      })(ref, instance, model);
      model.view = instance;
      model.view.model = model;
      return {
        view: this.view,
        router: this.router,
        model: model
      };
    };

    Plugin.prototype.router = function(router) {
      var rinstance;
      router.prototype.model = this.model;
      rinstance = new router;
      delete router.prototype.model;
      this.model.router = rinstance;
      return {
        view: this.view,
        router: this.router,
        model: this.model
      };
    };

    Plugin.prototype.memorize = function(model) {
      var id;
      this.preload(model);
      id = model.get('id');
      this.set(id, model);
      return this.triggerNav(model);
    };

    Plugin.prototype.preload = function(model) {
      var js, _i, _len, _ref, _results;
      js = (_ref = model.get('assets')) != null ? _ref.js : void 0;
      if (Array.isArray(js)) {
        _results = [];
        for (_i = 0, _len = js.length; _i < _len; _i++) {
          path = js[_i];
          if (typeof path !== 'string') {
            if (js.preload) {
              _results.push(this.preloadPath(path.path, model));
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      } else if (typeof js !== 'undefined') {
        if (typeof js !== 'string') {
          if (js.preload) {
            return this.preloadPath(js.path, model);
          }
        }
      }
    };

    Plugin.prototype.preloadPath = function(path, model) {
      if (path) {
        return this.load(path, 'js', model);
      }
    };

    Plugin.prototype.triggerNav = function(model) {
      var ev;
      ev = 'new';
      if (model.get('navigatable')) {
        ev += ':navigatable';
      }
      if (this.getSettings(model).get('active') === false) {
        ev += ':inactive';
      }
      return this.trigger(ev, model);
    };

    Plugin.prototype.preRender = function(model) {
      app.clearer.clear();
      $('.plugin').loading().hide();
      return this.loadAssets(model);
    };

    Plugin.prototype.postRender = function(model) {
      return app.clearer.add('unset', 'html', '.plugin');
    };

    Plugin.prototype.loadAssets = function(model) {
      var args, assets, fname, type, value, _i, _len;
      assets = model.get('assets');
      model.set('assetsLength', 0);
      model.set('loadedAssetsCount', 0);
      for (type in assets) {
        value = assets[type];
        args = [type, model];
        if (Array.isArray(value)) {
          for (_i = 0, _len = value.length; _i < _len; _i++) {
            fname = value[_i];
            this.load.apply(this, [fname].concat(__slice.call(args)));
          }
        } else {
          this.load.apply(this, [value].concat(__slice.call(args)));
        }
      }
      model.on('change:loadedAssetsCount', (function(_this) {
        return function(m, value) {
          if (value === m.get('assetsLength')) {
            return _this.assetsLoaded(m);
          }
        };
      })(this));
      if (model.get('assetsLength') === 0) {
        return this.assetsLoaded(model);
      }
    };

    Plugin.prototype.parseImport = function(properties, model, path) {
      var arrdata, _i, _len;
      if (Array.isArray(properties)) {
        for (_i = 0, _len = properties.length; _i < _len; _i++) {
          arrdata = properties[_i];
          this["import"](arrdata);
        }
      } else {
        this["import"](properties);
      }
      if (this.isAllGlobal(properties)) {
        this.cache(path);
      }
      return model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1);
    };

    Plugin.prototype.assetsLoaded = function(model) {
      model.trigger('assetsLoaded');
      return $('.plugin').loading(false).show();
    };

    Plugin.prototype.loadfuncs = {
      js: function(data, id, type, path, model) {
        var blob, element, url;
        blob = new Blob([data], {
          type: 'text/javascript'
        });
        url = URL.createObjectURL(blob);
        element = $("<script type='text/javascript' src='" + url + "' id='plugin-script#" + id + "'></script>");
        $.ajaxSetup({
          cache: true
        });
        $('head').append(element);
        $.ajaxSetup({
          cache: false
        });
        app.clearer.add('remove', 'html', element);
        model.get('imports').once('loaded:' + path, this.parseImport, this);
        this.localAssets[type][path] = element;
        return app.clearer.add('remove', 'object', {
          base: this.localAssets[type],
          key: path
        }, true);
      },
      stylesheet: function(data, id, type, path, model) {
        var blob, element, url;
        blob = new Blob([data], {
          type: 'text/css'
        });
        url = URL.createObjectURL(blob);
        element = $("<link rel='stylesheet' href='" + url + "' id='plugin-stylesheet#" + id + "'>");
        $.ajaxSetup({
          cache: true
        });
        $('head').append(element);
        $.ajaxSetup({
          cache: false
        });
        app.clearer.add('remove', 'html', element);
        this.localAssets[type][path] = element;
        app.clearer.add('remove', 'object', {
          base: this.localAssets[type],
          key: path
        }, true);
        return model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1);
      },
      image: function(data, id, type, path, model) {
        var blob, ext, url;
        ext = path.split('.');
        ext = ext[ext.length - 1].toLowerCase();
        blob = new Blob([data], {
          type: 'image/' + ext
        });
        url = URL.createObjectURL(blob);
        this.localAssets[type][path] = url;
        app.clearer.add('remove', 'object', {
          base: this.localAssets[type],
          key: path
        }, true);
        return model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1);
      },
      template: function(data, id, type, path, model) {
        this.localAssets[type][path] = _.template(data);
        app.clearer.add('remove', 'object', {
          base: this.localAssets[type],
          key: path
        }, true);
        return model.set('loadedAssetsCount', model.get('loadedAssetsCount') + 1);
      }
    };

    Plugin.prototype.load = function(path, type, model) {
      var id, xhr;
      if (typeof path !== 'string') {
        path = path.path;
      }
      if (this.inCache(path)) {
        return console.log('path didnt import, cause cached');
      }
      model.set('assetsLength', model.get('assetsLength') + 1);
      id = model.get('id');
      return xhr = $.ajax({
        success: (function(_this) {
          return function(path, id, model, type) {
            return function(data, status, jqXHR) {
              return _this.loadfuncs[type].call(_this, data, id, type, path, model);
            };
          };
        })(this)(path, id, model, type),
        error: (function(model) {
          return function(jqXHR, status, error) {
            $('.plugin').loading(false).show();
            throw new Error("./plugins/" + id + "/" + path);
          };
        })(model),
        url: "./plugins/" + id + "/" + path,
        context: this,
        dataType: 'text',
        isLocal: true,
        cache: false,
        crossDomain: true
      });
    };

    return Plugin;

  })(Backbone.Model);

  Navigation = (function(_super) {
    __extends(Navigation, _super);

    function Navigation() {
      this.select = __bind(this.select, this);
      return Navigation.__super__.constructor.apply(this, arguments);
    }

    Navigation.prototype.el = '.navigation';

    Navigation.prototype.initialize = function() {
      app.get('plugin').on('new:navigatable', this.addPluginItem, this);
      return app.get('plugin').on('new:navigatable:inactive', this.removePluginItem, this);
    };

    Navigation.prototype.events = {
      'click .submenual': 'liclick',
      'click .nosubmenu': 'liclick'
    };

    Navigation.prototype.liclick = function(ev) {
      if (ev.target.tagName === 'LI') {
        return window.location.hash = $(ev.target).children('a').eq(0).attr('href').substr(1);
      }
    };

    Navigation.prototype.select = function(page, params) {
      var el, url;
      params = _.without(params, null);
      this.$('ul li.selectable').each(function() {
        return $(this).removeClass('selected');
      });
      url = location.hash.slice(1);
      el = this.$("li.selectable[data-selectable-id='" + url + "']");
      return el.addClass('selected');
    };

    Navigation.prototype.menutemplate = _.template($('#menu-item.navigational').html());

    Navigation.prototype.addItem = function(attrs) {
      if (attrs.link == null) {
        attrs.link = attrs.id;
      }
      if (attrs.index == null) {
        attrs.index = $('.selectable.nosubmenu, .selectable.submenual').last().data('index') + 1;
      }
      attrs.stripLink = function(st) {
        return st.replace(/(^(\.\/))|(^(\/))/, '').replace(/(\/)$/, '');
      };
      attrs.haveSubMenu = attrs.hasOwnProperty('submenus') && attrs.submenus.length > 0;
      return this.$('ul.main-navigation').append(this.menutemplate(attrs));
    };

    Navigation.prototype.removePluginItem = function(model) {
      return this.$("#nav-plugin-" + (model.get('id'))).remove();
    };

    Navigation.prototype.addPluginItem = function(model) {
      return this.addItem({
        id: 'nav-plugin-' + model.get('id'),
        title: model.get('title'),
        link: 'plugin/view/' + model.get('id'),
        submenus: model.get('submenus')
      });
    };

    return Navigation;

  })(Backbone.View);

  Views = (function(_super) {
    __extends(Views, _super);

    function Views() {
      return Views.__super__.constructor.apply(this, arguments);
    }

    Views.prototype.initialize = function() {
      var name, ref, view, _ref, _results;
      this.set('home', new View.Home);
      this.set('plugins', new View.Plugins);
      _ref = this.attributes;
      _results = [];
      for (name in _ref) {
        view = _ref[name];
        ref = view.render || null;
        _results.push(view.render = (function(ref, view) {
          return function() {
            app.get('views').trigger('will-render', view);
            app.clearer.add('unset', 'html', '.content');
            return ref != null ? ref.apply(view, arguments) : void 0;
          };
        })(ref, view));
      }
      return _results;
    };

    return Views;

  })(Backbone.Model);

  Clearer = (function() {
    function Clearer() {
      this.clear = __bind(this.clear, this);
      this.add = __bind(this.add, this);
    }

    Clearer.prototype.toclear = [];

    Clearer.prototype.add = function() {
      var action, additional, value, what;
      action = arguments[0], what = arguments[1], value = arguments[2], additional = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
      return this.toclear.push({
        what: what,
        value: value,
        action: action,
        additional: additional
      });
    };

    Clearer.prototype.clear = function() {
      var ob, whachado, _i, _len, _ref;
      whachado = {
        html: this.removeHTML,
        object: this.removeObject
      };
      _ref = this.toclear;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ob = _ref[_i];
        whachado[ob.what].apply(whachado, [ob.value, ob.action].concat(__slice.call(ob.additional)));
      }
      return this.toclear = [];
    };

    Clearer.prototype.removeHTML = function(element, action) {
      switch (action) {
        case 'remove':
          return $(element).remove();
        case 'unset':
          return $(element).html('');
        case 'show':
          return $(element).show();
      }
    };

    Clearer.prototype.removeObject = function(value, action, keys) {
      var key, val, _results;
      if (keys == null) {
        keys = false;
      }
      if (keys) {
        switch (action) {
          case 'remove':
            return delete value.base[value.key];
          case 'unset':
            return value.base[value.key] = null;
        }
      } else {
        _results = [];
        for (key in value) {
          val = value[key];
          switch (action) {
            case 'remove':
              _results.push(delete val[key]);
              break;
            case 'unset':
              _results.push(val[key] = null);
              break;
            default:
              _results.push(void 0);
          }
        }
        return _results;
      }
    };

    return Clearer;

  })();

  App = (function(_super) {
    __extends(App, _super);

    function App() {
      return App.__super__.constructor.apply(this, arguments);
    }

    App.prototype.initialize = function() {};

    App.prototype.start = function() {
      this.set('plugin', new Plugin);
      this.set('navigation', new Navigation);
      return this.set('views', new Views);
    };

    App.prototype['clearer'] = new Clearer;

    return App;

  })(Backbone.Model);

  Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.initialize = function() {
      return this.on('route', function(page, params) {
        return app.get('navigation').select(page, params);
      });
    };

    Router.prototype.routes = {
      'plugins': 'plugins',
      'plugin/:action/:id': 'plugins',
      'home': 'home',
      '*anything': 'gohome'
    };

    Router.prototype['plugins'] = function(action, id) {
      if (action == null) {
        action = false;
      }
      if (action === false) {
        return app.get('views').get('plugins').render();
      } else if (action === 'view') {
        return app.get('plugin').get(id).view.render();
      }
    };

    Router.prototype['gohome'] = function() {
      return this.navigate('home');
    };

    Router.prototype['home'] = function() {
      return app.get('views').get('home').render();
    };

    return Router;

  })(Backbone.Router);

  AppView = (function(_super) {
    __extends(AppView, _super);

    function AppView() {
      this.setupnav = __bind(this.setupnav, this);
      return AppView.__super__.constructor.apply(this, arguments);
    }

    AppView.prototype.el = '.app';

    AppView.prototype.initialize = function() {
      window.router = new Router;
      window.app = new App({});
      app.view = this;
      app.start();
      this.$('.side[type="text/template"]').each(this.setupnav);
      return app.get('views').on('will-render', app.clearer.clear, this);
    };

    AppView.prototype.setupnav = function(index, elm) {
      var id;
      id = elm.id;
      return app.get('navigation').addItem({
        id: id,
        title: elm.dataset.hasOwnProperty('title') ? elm.dataset.title : id.substr(0, 1).toUpperCase() + id.substr(1),
        index: index
      });
    };

    return AppView;

  })(Backbone.View);

  new AppView();

  $(window).on('load', function() {
    return Backbone.history.start();
  });

}).call(this);
