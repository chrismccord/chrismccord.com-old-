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
      '/page/:page': 'page'
    };
    Router.prototype.home = function() {
      return Book.goTo(0);
    };
    Router.prototype.page = function(page) {
      return Book.goTo(page);
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
      speedFactor: 0.30
    };
    CoffeeBook.prototype.options = {};
    CoffeeBook.prototype.pageNumber = 0;
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
    CoffeeBook.prototype.goTo = function(toPageNumber) {
      if (toPageNumber === "next") {
        toPageNumber = this.pageNumber + 1;
      }
      if (toPageNumber === "back") {
        toPageNumber = this.pageNumber - 1;
      }
      toPageNumber = parseInt(toPageNumber);
      if (toPageNumber > this.pageNumber) {
        this.nextPageView = new PageView({
          model: this.pages.at(toPageNumber)
        });
        this.$(".page.next").html($(this.nextPageView.el).html());
        this.animateForward();
      } else if (toPageNumber < this.pageNumber) {
        this.nextPageView = new PageView({
          model: this.pages.at(toPageNumber)
        });
        this.$(".page.next").html($(this.nextPageView.el).html());
        this.animateBackward();
      } else {
        this.activePageView = new PageView({
          model: this.currentPage()
        });
        this.$(".page.active").html($(this.activePageView.el).html());
      }
      return this.pageNumber = toPageNumber;
    };
    CoffeeBook.prototype.getPageNumber = function() {
      return this.pageNumber;
    };
    CoffeeBook.prototype.currentPage = function() {
      return this.pages.at(this.pageNumber);
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
    return CoffeeBook;
  })();
  this.$(document).ready(__bind(function() {
    this.Posts = new Pages;
    this.Posts.add([
      new Page({
        title: "Backbone extensions best practices",
        content: 'Sub Heading\n---------------\n1. Lets see if this works\n2. It\'s working\n3. Profit!\n> This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,\nconsectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.\nVestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.\n\nSome code:\n    \n    mood = greatlyImproved if singing\n\n    if happy and knowsIt\n      clapsHands()\n      chaChaCha()\n    else\n      showIt()\n\n    date = if friday then sue else jill\n\n    options or= defaults'
      }), new Page({
        title: "Backbone extensions best practices",
        content: 'Sub Heading\n---------------\n1. Lets see if this works\n2. It\'s working\n3. Profit!'
      })
    ]);
    window.Book = new CoffeeBook;
    Book.pages = this.Posts;
    return Book.init();
  }, this));
}).call(this);
