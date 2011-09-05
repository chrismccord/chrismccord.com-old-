(function() {
  var Router;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Router = (function() {
    __extends(Router, Backbone.Router);
    function Router() {
      Router.__super__.constructor.apply(this, arguments);
    }
    Router.prototype.routes = {
      '': 'home',
      '/page/:name': 'page',
      '/page/:name/:number': 'page'
    };
    Router.prototype.home = function() {
      return Book.goTo('home', 0);
    };
    Router.prototype.page = function(name, number) {
      if (number == null) {
        number = 0;
      }
      return Book.goTo(name, number);
    };
    return Router;
  })();
  this.Page = (function() {
    __extends(Page, Backbone.Model);
    function Page() {
      Page.__super__.constructor.apply(this, arguments);
    }
    Page.prototype.initialize = function() {
      return this.set({
        content: (new Showdown.converter()).makeHtml(this.get('content'))
      });
    };
    return Page;
  })();
  this.Pages = (function() {
    __extends(Pages, Backbone.Collection);
    function Pages() {
      Pages.__super__.constructor.apply(this, arguments);
    }
    Pages.prototype.model = Page;
    Pages.prototype.pageIds = function() {
      return this.pluck('id');
    };
    return Pages;
  })();
  this.PageView = (function() {
    __extends(PageView, Backbone.View);
    function PageView() {
      this.render = __bind(this.render, this);
      PageView.__super__.constructor.apply(this, arguments);
    }
    PageView.prototype.initialize = function() {
      this.model.bind('change', this.render);
      return this.render();
    };
    PageView.prototype.render = function() {
      var template;
      template = Handlebars.compile($("#page-template").html());
      return $(this.el).html(template(this.model.toJSON()));
    };
    return PageView;
  })();
  this.CoffeeBook = (function() {
    __extends(CoffeeBook, Backbone.View);
    function CoffeeBook() {
      CoffeeBook.__super__.constructor.apply(this, arguments);
    }
    CoffeeBook.prototype.el = "#book";
    CoffeeBook.prototype.animating = false;
    CoffeeBook.prototype.events = {
      "click #next": "next",
      "click #back": "back"
    };
    CoffeeBook.prototype.defaults = {
      enableKeys: true,
      turnWidthStart: 12,
      foldOffset: 32,
      height: 800,
      minHeight: 550,
      heightDuration: 200,
      speedFactor: 0.30
    };
    CoffeeBook.prototype.options = {};
    CoffeeBook.prototype.pageNumber = null;
    CoffeeBook.prototype.currentPage = null;
    CoffeeBook.prototype.previousPage = null;
    CoffeeBook.prototype.activePageView = null;
    CoffeeBook.prototype.nextPageView = null;
    CoffeeBook.prototype.pages = [];
    CoffeeBook.prototype.initialize = function(options) {
      var key, val, _results;
      if (options == null) {
        options = {};
      }
      _.extend(this.options, this.defaults);
      _results = [];
      for (key in options) {
        val = options[key];
        _results.push(this.options[key] = val);
      }
      return _results;
    };
    CoffeeBook.prototype.bindEvents = function() {
      if (this.options.enableKeys) {
        return $(document).bind('keyup', __bind(function(event) {
          switch (event.keyCode) {
            case 37:
              return this.back();
            case 39:
              return this.next();
          }
        }, this));
      }
    };
    CoffeeBook.prototype.init = function() {
      this.bindEvents();
      new Router();
      return Backbone.history.start();
    };
    CoffeeBook.prototype.next = function() {
      if (!this.isAnimating()) {
        window.location = "#/page/" + (this.getPageNumber() + 1);
      }
      return false;
    };
    CoffeeBook.prototype.back = function() {
      if (!this.isAnimating()) {
        window.location = "#/page/" + (this.getPageNumber() - 1);
      }
      return false;
    };
    CoffeeBook.prototype.isAnimating = function() {
      return this.animating;
    };
    CoffeeBook.prototype.animateForward = function(callback) {
      var $active, $turn, $turn_middle, activeSpeed, turnSpeed, turnWidth, width;
      this.animating = true;
      width = this.$(".page.active").width();
      $turn = this.$("#turn");
      $turn_middle = this.$("#turn .middle");
      $active = this.$(".page.active").parent();
      $turn.css({
        right: 0
      });
      $turn_middle.css({
        width: this.options.turnWidthStart
      });
      turnWidth = width + this.options.foldOffset;
      turnSpeed = 1800 * this.options.speedFactor;
      activeSpeed = 1200 * this.options.speedFactor;
      $turn.stop().show().animate({
        right: turnWidth
      }, turnSpeed, 'linear', __bind(function() {
        return $turn.fadeOut(50, __bind(function() {
          this.afterAnimateForward();
          if (callback) {
            return callback();
          }
        }, this));
      }, this));
      $turn_middle.stop().animate({
        width: width * 1.25
      }, turnSpeed, 'linear');
      return $active.stop().animate({
        width: 0
      }, activeSpeed, 'linear', function() {
        return $active.hide();
      });
    };
    CoffeeBook.prototype.afterAnimateForward = function() {
      this.$(".page.active").parent().remove();
      this.$(".page.next").removeClass("next").addClass("active");
      $(this.el).prepend('\
        <div class="right_page_container">\
          <div class="page next">\
          </div>\
        </div>       \
    ');
      return this.animating = false;
    };
    CoffeeBook.prototype.animateBackward = function(callback) {
      var $active, $next, $turn, $turn_middle, nextDelay, nextSpeed, turnSpeed;
      this.animating = true;
      $turn = this.$("#turn");
      $next = this.$(".page.next").parent();
      $turn_middle = this.$("#turn .middle");
      $active = this.$(".page.active").parent();
      turnSpeed = 1800 * this.options.speedFactor;
      nextSpeed = (2 / 3) * turnSpeed;
      nextDelay = 0.35 * turnSpeed;
      $turn_middle.stop().queue(__bind(function() {
        var width;
        width = this.$(".page.active").width();
        $next.css({
          "z-index": 2
        }).hide();
        $active.css({
          "z-index": 1
        });
        $turn.css({
          right: width + this.options.foldOffset
        });
        $turn_middle.css({
          width: width * 1.25
        });
        return $next.delay(nextDelay).animate({
          width: 'toggle'
        }, nextSpeed, 'linear');
      }, this)).dequeue().animate({
        width: this.options.turnWidthStart
      }, turnSpeed, 'linear');
      return $turn.stop().show().animate({
        right: 0
      }, turnSpeed, 'linear', __bind(function() {
        return $turn.fadeOut(50, __bind(function() {
          this.afterAnimateBack();
          if (callback) {
            return callback();
          }
        }, this));
      }, this));
    };
    CoffeeBook.prototype.afterAnimateBack = function() {
      this.$(".page.active").parent().remove();
      this.$(".page.next").removeClass("next").addClass("active");
      $(this.el).prepend('\
        <div class="right_page_container">\
          <div class="page next">\
          </div>\
        </div>       \
    ');
      return this.animating = false;
    };
    CoffeeBook.prototype.updateHeight = function(options) {
      var height;
      if (options == null) {
        options = {};
      }
      height = $(".page.active").height();
      if (height < this.options.minHeight) {
        height = this.options.minHeight;
      }
      if (options.animate === false) {
        return $(".book_wrap").css({
          height: height
        });
      } else {
        return $(".book_wrap").animate({
          height: height
        }, this.options.heightDuration);
      }
    };
    CoffeeBook.prototype.goTo = function(name, toPageNumber) {
      var _ref, _ref2;
      if (toPageNumber === "next") {
        toPageNumber = this.pageNumber + 1;
      }
      if (toPageNumber === "back") {
        toPageNumber = this.pageNumber - 1;
      }
      toPageNumber = parseInt(toPageNumber);
      this.previousPage = this.currentPage;
      this.currentPage = this.pages[name];
      if (!this.previousPage) {
        this.activePageView = new PageView({
          model: this.pages[name]
        });
        this.$(".page.active").html($(this.activePageView.el).html());
        this.updateHeight({
          animate: false
        });
      } else if (((_ref = this.currentPage) != null ? _ref.get('rank') : void 0) > ((_ref2 = this.previousPage) != null ? _ref2.get('rank') : void 0)) {
        this.nextPageView = new PageView({
          model: this.pages[name]
        });
        this.$(".page.next").html($(this.nextPageView.el).html());
        this.animateForward(__bind(function() {
          return this.updateHeight();
        }, this));
      } else {
        this.nextPageView = new PageView({
          model: this.pages[name]
        });
        this.$(".page.next").html($(this.nextPageView.el).html());
        this.animateBackward(__bind(function() {
          return this.updateHeight();
        }, this));
      }
      this.pageNumber = toPageNumber;
      return this.setHeaderTitle(this.pages[name].get('header'));
    };
    CoffeeBook.prototype.getPageNumber = function() {
      return this.pageNumber;
    };
    CoffeeBook.prototype.nextPage = function() {
      return this.pages.at(this.pageNumber + 1);
    };
    CoffeeBook.prototype.prevPage = function() {
      return this.pages.at(this.pageNumber - 1);
    };
    CoffeeBook.prototype.firstPage = function() {
      return this.pages.first();
    };
    CoffeeBook.prototype.lastPage = function() {
      return this.pages.last();
    };
    CoffeeBook.prototype.setHeaderTitle = function(title) {
      return $(".header .title").text(title || '');
    };
    return CoffeeBook;
  })();
  this.$(document).ready(__bind(function() {
    this.pages = {
      home: new Page({
        rank: 0,
        title: false,
        content: '  \n\<br/>\n![](images/avatar2.jpg) Hello, I\'m Chris McCord, a web developer with a \n  passion for science and building things. My current toolkit includes \n  Ruby, Rails, and coffeescript. Here you will find my ramblings and \n  things I find interesting around the internets.\n\n\<br/>\n# Recent Writings\n- More coffee(script) please\n\n# Twitter\n- @mguterl @joefiorini I recently set up sunspot/solr for one of our projects and have been really impressed so far.\n- Just finished an excellent profile on Elon Musk by @BloombergNews http://bloom.bg/qgkNhp\n- CoffeeScript should have just been named BaconScript… it\'s just that good.\n\n\n\<br/>\n![](images/avatar2.jpg) Hello, I\'m Chris McCord, a web developer with a \n  passion for science and building things. My current toolkit includes \n  Ruby, Rails, and coffeescript. Here you will find my ramblings and \n  things I find interesting around the internets.\n\n\<br/>\n# Recent Writings\n- More coffee(script) please\n\n# Twitter\n- @mguterl @joefiorini I recently set up sunspot/solr for one of our projects and have been really impressed so far.\n- Just finished an excellent profile on Elon Musk by @BloombergNews http://bloom.bg/qgkNhp\n- CoffeeScript should have just been named BaconScript… it\'s just that good.\n'
      }),
      about: new Page({
        rank: 1,
        header: "about",
        title: "About me",
        content: '\<br/>\n## Professional life\n> During the day I am a Ruby on Rails developer at [Littlelines](http://littlelines.com), a distinguished \ndesign and development studio nestled in the midwest with expertise in \ncutting-edge web development.\n\n\<br/>\n## Personal life\n> At home I\'m a husband to my lovely wife Jaclyn. I\'m passionate about \nlearning new things and a bit of a space nerd. I enjoy sci-fi novels, \nintelligent conversation, probably too many chickflicks, and hacking on \nwhatever interests me at the time. '
      }),
      contact: new Page({
        rank: 2,
        header: "contact",
        title: "Contact info and places you can find me",
        content: '- my first name @ this domain\n- [twitter]()\n- [facebook]()\n- [github]()'
      })
    };
    window.Book = new CoffeeBook;
    Book.pages = this.pages;
    return Book.init();
  }, this));
}).call(this);
