# Router
class Router extends Backbone.Router
  routes:
    ''                : 'home'
    '/page/:page'     : 'page'

    
  home: ->
    Book.goTo(0)
  page: (page) ->
    Book.goTo(page)


# Models
class @Page extends Backbone.Model
  
  
  
# Collections
class @Pages extends Backbone.Collection
  model: Page
  pageIds: -> @pluck('id')
  

# Views

class @PageView extends Backbone.View
  
  initialize: ->
    @model.bind('change', @render)
    @render()
    
  render: =>
    template = Handlebars.compile($("#page-template").html())
    $(@el).html(template(@model.toJSON()))
    
class CoffeeBook extends Backbone.View
  el: "#book"
  
  events:
    "click #next"         : "next"
    "click #back"         : "back"
    
  defaults:
    width: 940
    height: 800
    speedFactor: 0.60
  pageNumber: 0
  activePageView: null
  nextPageView: null
  pages: new Pages([
      new Page({ title: 'page 1', content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"})
      new Page({ title: 'page 2', content: "jskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs f<img src='images/picture1.jpg'/>"})
      new Page({ title: 'page 3', content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"})
      new Page({ title: 'page 4', content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"})

    ])
  

  init: ->
    new Router()
    Backbone.history.start()
    
  next: -> 
    window.location = "#/page/#{@getPageNumber() + 1}"
    false
  back: -> 
    window.location = "#/page/#{@getPageNumber() - 1}"
    false

  animateForward: (callback) ->
    width = @$(".page.active").width()
    $turn = @$("#turn")
    $turn_middle = @$("#turn .middle")
    $active = @$(".page.active").parent()
 
    $turn.css({"right": '0px'})
    $turn_middle.css({"width": '34px'})
    $turn.stop().show().animate {right: width + 20}, 1800 * @defaults.speedFactor,'linear', ->
      $turn.fadeOut 50, ->
        callback() if callback

    $turn_middle.stop().animate({width: width * 1.25}, 1800 * @defaults.speedFactor,'linear')

    $active.stop().animate {width: 0}, 1200 * @defaults.speedFactor, 'linear', ->
      $active.hide()
    
  animateBackward: (callback) ->
    $turn = @$("#turn")
    $next = @$(".page.next").parent()
    $turn_middle = @$("#turn .middle")
    $active = @$(".page.active").parent()
    
    $turn_middle.stop().queue(=>  
      width = @$(".page.active").width()
      $next.css({"z-index": 2}).hide()
      $active.css({"z-index": 1})
      $turn.css({"right": '763px'})
      $turn_middle.css({"width": '928px'})
      $next.delay(0.35 * 1800 * @defaults.speedFactor)
        .animate {width: 'toggle'}, 1200 * @defaults.speedFactor, 'linear', ->
          console.log 'next page done animating'
    ).dequeue().animate({width: 34}, 1800 * @defaults.speedFactor,'linear')
    
    $turn.stop().show().animate {right: 0}, 1800 * @defaults.speedFactor,'linear', ->
      $turn.fadeOut 50, ->
        callback() if callback



  # Seek to page model
  #
  goTo: (toPageNumber) ->
    #TODO validate this
    toPageNumber = @pageNumber + 1 if toPageNumber == "next"
    toPageNumber = @pageNumber - 1 if toPageNumber == "back"
    toPageNumber = parseInt(toPageNumber)
    if toPageNumber > @pageNumber
      @nextPageView = new PageView({ model: @pages.at(toPageNumber) })
      @$(".page.next").html($(@nextPageView.el).html())
      @animateForward =>
        @$(".page.active").parent().remove()
        @$(".page.next").removeClass("next").addClass("active")
        $(@el).prepend('
            <div class="right_page_container">
              <div class="page next">
              </div>
            </div>       
        ')
      
    else if toPageNumber < @pageNumber
      console.log "page = #{toPageNumber}"
      @nextPageView = new PageView({ model: @pages.at(toPageNumber) })
      @$(".page.next").html($(@nextPageView.el).html())
      @animateBackward =>
        # @$("#turn").remove()
        @$(".page.active").parent().remove()
        @$(".page.next").removeClass("next").addClass("active")
        $(@el).prepend('
            <div class="right_page_container">
              <div class="page next">
              </div>
            </div>       
        ')
    else
      @activePageView  = new PageView({ model: @currentPage() })
      @$(".page.active").html($(@activePageView.el).html())
    
    @pageNumber = toPageNumber

  getPageNumber: -> @pageNumber
  currentPage: -> @pages.at(@pageNumber) 
  nextPage:    -> @pages.at(@pageNumber + 1)
  prevPage:    -> @pages.at(@pageNumber - 1)
  firstPage:   -> @pages.first()
  lastPage:    -> @pages.last()

@$(document).ready ->
  window.Book = new CoffeeBook
  Book.init()

  
  # setTimeout((->
  #     speedFactor = CoffeeBook.defaults.speedFactor
  #     width = $(".page .active").width()
  #     $("#turn").animate {right: width + 20}, 1800 * speedFactor,'linear', ->
  #       $(@).fadeOut(50)
  #     $("#turn .middle").animate({width: width * 1.25}, 1800 * speedFactor,'linear')
  #     
  #     $(".page .active").parent().animate {width: 0}, 1200 * speedFactor, 'linear', ->
  #           $(".page .active").parent().hide()
  #   ), 1000)