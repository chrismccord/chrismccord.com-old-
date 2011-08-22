(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
      PageView.__super__.constructor.apply(this, arguments);
    }
    PageView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    };
    return PageView;
  })();
  this.BookView = (function() {
    __extends(BookView, Backbone.View);
    function BookView() {
      BookView.__super__.constructor.apply(this, arguments);
    }
    BookView.prototype.initialize = function() {
      _.bindAll(this, 'render');
      this.model.bind('change', this.render);
      return this.render();
    };
    BookView.prototype.render = function() {
      var template;
      template = Handlebars.compile($("#page-template").html());
      return $(this.el).html(template(this.model.toJSON()));
    };
    return BookView;
  })();
  this.CoffeeBook = {
    defaults: {
      width: 940,
      height: 800,
      speedFactor: 0.30
    },
    pageNumber: 0,
    activePageView: null,
    nextPageView: null,
    pages: new Pages([
      new Page({
        title: 'page 1',
        content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
      }), new Page({
        title: 'page 2',
        content: "jskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs f<img src='images/picture1.jpg'/>"
      }), new Page({
        title: 'page 3',
        content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"
      })
    ]),
    init: function() {
      return this.goTo(0);
    },
    animateForward: function(callback) {
      var $active, $turn, $turn_middle, width;
      width = $(".page.active").width();
      $turn = $("#turn");
      $turn_middle = $("#turn .middle");
      $active = $(".page.active").parent();
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
      $turn_middle.animate({
        width: width * 1.25
      }, 1800 * this.defaults.speedFactor, 'linear');
      return $active.animate({
        width: 0
      }, 1200 * this.defaults.speedFactor, 'linear', function() {
        return $active.hide();
      });
    },
    animateBackward: function(callback) {
      var $next, $turn, $turn_middle;
      $turn = $("#turn");
      $next = $(".page.next").parent();
      $turn_middle = $("#turn .middle");
      $turn_middle.stop().queue(__bind(function() {
        var width;
        width = $(".page.active").width();
        $next.css({
          "z-index": 2
        }).hide();
        $turn.css({
          "right": '763px'
        });
        $turn_middle.css({
          "width": '928px'
        });
        return $next.delay(0.35 * 1800 * this.defaults.speedFactor).animate({
          width: 'toggle'
        }, 1200 * this.defaults.speedFactor, 'linear');
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
    },
    goTo: function(toPageNumber) {
      if (toPageNumber > this.pageNumber) {
        this.nextPageView = new BookView({
          model: this.pages.at(toPageNumber)
        });
        $(".page.next").html($(this.nextPageView.el).html());
        this.animateForward(__bind(function() {
          $(".page.active").parent().remove();
          $(".page.next").removeClass("next").addClass("active");
          return $("#book").prepend('\
            <div class="right_page_container">\
              <div class="page next">\
              </div>\
            </div>       \
        ');
        }, this));
      } else if (toPageNumber < this.pageNumber) {
        this.nextPageView = new BookView({
          model: this.pages.at(toPageNumber)
        });
        $(".page.next").html($(this.nextPageView.el).html());
        this.animateBackward(__bind(function() {
          $("#turn").remove();
          $(".page.active").parent().remove();
          $(".page.next").removeClass("next").addClass("active");
          return $("#book").prepend('\
            <div id="turn">\
              <div class="middle">\
              </div>\
              <div class="shadow_left">\
              </div>\
            </div>\
            <div class="right_page_container">\
              <div class="page next">\
              </div>\
            </div>       \
        ');
        }, this));
      } else {
        this.activePageView = new BookView({
          model: this.currentPage()
        });
        $(".page.active").html($(this.activePageView.el).html());
      }
      return this.pageNumber = toPageNumber;
    },
    currentPage: function() {
      return this.pages.at(this.pageNumber);
    },
    nextPage: function() {
      return this.pages.at(this.pageNumber + 1);
    },
    prevPage: function() {
      return this.pages.at(this.pageNumber - 1);
    },
    firstPage: function() {
      return this.pages.first();
    },
    lastPage: function() {
      return this.pages.last();
    }
  };
  this.$(document).ready(function() {
    return CoffeeBook.init();
  });
}).call(this);
