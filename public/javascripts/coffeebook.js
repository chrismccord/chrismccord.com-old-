(function() {
  var CoffeeBook, Router;
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
  CoffeeBook = (function() {
    __extends(CoffeeBook, Backbone.View);
    function CoffeeBook() {
      CoffeeBook.__super__.constructor.apply(this, arguments);
    }
    CoffeeBook.prototype.el = "#book";
    CoffeeBook.prototype.events = {
      "click #next": "next",
      "click #back": "back"
    };
    CoffeeBook.prototype.defaults = {
      width: 940,
      height: 800,
      speedFactor: 0.60
    };
    CoffeeBook.prototype.pageNumber = 0;
    CoffeeBook.prototype.activePageView = null;
    CoffeeBook.prototype.nextPageView = null;
    CoffeeBook.prototype.pages = new Pages([
      new Page({
        title: 'page 1',
        content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
      }), new Page({
        title: 'page 2',
        content: "jskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs f<img src='images/picture1.jpg'/>"
      }), new Page({
        title: 'page 3',
        content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"
      }), new Page({
        title: 'page 4',
        content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"
      })
    ]);
    CoffeeBook.prototype.init = function() {
      new Router();
      return Backbone.history.start();
    };
    CoffeeBook.prototype.next = function() {
      window.location = "#/page/" + (this.getPageNumber() + 1);
      return false;
    };
    CoffeeBook.prototype.back = function() {
      window.location = "#/page/" + (this.getPageNumber() - 1);
      return false;
    };
    CoffeeBook.prototype.animateForward = function(callback) {
      var $active, $turn, $turn_middle, width;
      width = this.$(".page.active").width();
      $turn = this.$("#turn");
      $turn_middle = this.$("#turn .middle");
      $active = this.$(".page.active").parent();
      $turn.css({
        "right": '0px'
      });
      $turn_middle.css({
        "width": '34px'
      });
      $turn.stop().show().animate({
        right: width + 20
      }, 1800 * this.defaults.speedFactor, 'linear', function() {
        return $turn.fadeOut(50, function() {
          if (callback) {
            return callback();
          }
        });
      });
      $turn_middle.stop().animate({
        width: width * 1.25
      }, 1800 * this.defaults.speedFactor, 'linear');
      return $active.stop().animate({
        width: 0
      }, 1200 * this.defaults.speedFactor, 'linear', function() {
        return $active.hide();
      });
    };
    CoffeeBook.prototype.animateBackward = function(callback) {
      var $active, $next, $turn, $turn_middle;
      $turn = this.$("#turn");
      $next = this.$(".page.next").parent();
      $turn_middle = this.$("#turn .middle");
      $active = this.$(".page.active").parent();
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
          "right": '763px'
        });
        $turn_middle.css({
          "width": '928px'
        });
        return $next.delay(0.35 * 1800 * this.defaults.speedFactor).animate({
          width: 'toggle'
        }, 1200 * this.defaults.speedFactor, 'linear', function() {
          return console.log('next page done animating');
        });
      }, this)).dequeue().animate({
        width: 34
      }, 1800 * this.defaults.speedFactor, 'linear');
      return $turn.stop().show().animate({
        right: 0
      }, 1800 * this.defaults.speedFactor, 'linear', function() {
        return $turn.fadeOut(50, function() {
          if (callback) {
            return callback();
          }
        });
      });
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
        this.animateForward(__bind(function() {
          this.$(".page.active").parent().remove();
          this.$(".page.next").removeClass("next").addClass("active");
          return $(this.el).prepend('\
            <div class="right_page_container">\
              <div class="page next">\
              </div>\
            </div>       \
        ');
        }, this));
      } else if (toPageNumber < this.pageNumber) {
        console.log("page = " + toPageNumber);
        this.nextPageView = new PageView({
          model: this.pages.at(toPageNumber)
        });
        this.$(".page.next").html($(this.nextPageView.el).html());
        this.animateBackward(__bind(function() {
          this.$(".page.active").parent().remove();
          this.$(".page.next").removeClass("next").addClass("active");
          return $(this.el).prepend('\
            <div class="right_page_container">\
              <div class="page next">\
              </div>\
            </div>       \
        ');
        }, this));
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
  this.$(document).ready(function() {
    window.Book = new CoffeeBook;
    return Book.init();
  });
}).call(this);
