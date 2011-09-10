
# Router
class Router extends Backbone.Router
  routes:
    ''                              : 'home'
    '/page/:name'                   : 'page'
    '/page/:name/:number'           : 'page'

    
  home:                    -> Book.goTo('home', 0)
  page: (name, number = 0) -> Book.goTo(name, number)


# Models
class @Page extends Backbone.Model
  
  initialize: ->
    @set {content: (new Showdown.converter()).makeHtml @get('content') }

  
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
    
class @CoffeeBook extends Backbone.View
  el: "#book"
  animating: false

  events:
    "click #next"         : "next"
    "click #back"         : "back"
    
  defaults:
    enableKeys: true
    # width: 940
    # pageWidth: 743
    turnWidthStart: 12
    foldOffset: 32
    height: 800
    minHeight: 550
    heightDuration: 200
    speedFactor: 0.30
    
  # Defaults automatically loaded when instantiated
  options: {}
  pageNumber: null
  currentPage: null
  previousPage: null
  activePageView: null
  nextPageView: null
  pages: []
  # new Pages([
  #       new Page({ title: 'page 1', content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"})
  #       new Page({ title: 'page 2', content: "jskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs fjskdfj slfkjslkdfjslkdfjlsjdf sldf slkdjfskldjfs flksjdf skdjfs lkdfjs dflksjdf skdlfjkdjlfj slkdfjslkdjfslkdf slkdjfslkdfjs dlfkjsd flksdjf slkdfj sldkfj sldf sdfkjl sldkfjsldkfjs f<img src='images/picture1.jpg'/>"})
  #       new Page({ title: 'page 3', content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"})
  #       new Page({ title: 'page 4', content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.<img src='images/picture2.jpg'/>"})
  # 
  #     ])
  
  initialize: (options = {}) ->
    _.extend(@options, @defaults)
    @options[key] = val for key, val of options

  bindEvents: ->
    if @options.enableKeys
      $(document).bind 'keyup', (event) =>
        switch event.keyCode
          when 37
            @back()
          when 39
            @next()
  init: ->
    @bindEvents()
    new Router()
    Backbone.history.start()
    
  next: -> 
    window.location = "#/page/#{@getPageNumber() + 1}" unless @isAnimating()
    false
  back: -> 
    window.location = "#/page/#{@getPageNumber() - 1}" unless @isAnimating()
    false

  isAnimating: -> @animating
  
  animateForward: (callback) ->
    @animating = true
    width = @$(".page.active").width()
    $turn = @$("#turn")
    $turn_middle = @$("#turn .middle")
    $active = @$(".page.active").parent()
    $turn.css({right: 0})
    $turn_middle.css({width: @options.turnWidthStart})
    turnWidth = width + @options.foldOffset
    turnSpeed = 1800 * @options.speedFactor
    activeSpeed = 1200 * @options.speedFactor
    
    $turn.stop().show().animate {right: turnWidth}, turnSpeed, 'linear', =>
      $turn.fadeOut 50, =>
        @afterAnimateForward()
        callback() if callback

    $turn_middle.stop().animate({width: width * 1.25}, turnSpeed, 'linear')
    $active.stop().animate {width: 0}, activeSpeed, 'linear', ->
      $active.hide()
  
  afterAnimateForward: ->
    @$(".page.active").parent().remove()
    @$(".page.next").removeClass("next").addClass("active")
    $(@el).prepend('
        <div class="right_page_container">
          <div class="page next">
          </div>
        </div>       
    ')
    @animating = false
      
  animateBackward: (callback) ->
    @animating = true
    $turn = @$("#turn")
    $next = @$(".page.next").parent()
    $turn_middle = @$("#turn .middle")
    $active = @$(".page.active").parent()
    
    turnSpeed = 1800 * @options.speedFactor
    nextSpeed = (2/3) * turnSpeed
    nextDelay = 0.35 * turnSpeed
    $turn_middle.stop().queue(=>  
      width = @$(".page.active").width()
      $next.css({"z-index": 2}).hide()
      $active.css({"z-index": 1})
      $turn.css({right: width + @options.foldOffset})
      $turn_middle.css({width: width * 1.25})
      $next.delay(nextDelay)
        .animate {width: 'toggle'}, nextSpeed, 'linear'
    ).dequeue()
     .animate({width: @options.turnWidthStart}, turnSpeed,'linear')
    
    $turn.stop().show().animate {right: 0}, turnSpeed,'linear', =>
      $turn.fadeOut 50, =>
        @afterAnimateBack()
        callback() if callback

  afterAnimateBack: ->
    @$(".page.active").parent().remove()
    @$(".page.next").removeClass("next").addClass("active")
    $(@el).prepend('
        <div class="right_page_container">
          <div class="page next">
          </div>
        </div>       
    ')
    @animating = false
    

  updateHeight: (options = {}) ->
    height = $(".page.active").height()
    height = @options.minHeight if height < @options.minHeight
    if options.animate == false
      $(".book_wrap").css {height: height}
    else
      $(".book_wrap").animate {height: height}, @options.heightDuration
      
  # Seek to page model
  #
  goTo: (name, toPageNumber) ->
    #TODO validate this
    toPageNumber = @pageNumber + 1 if toPageNumber == "next"
    toPageNumber = @pageNumber - 1 if toPageNumber == "back"
    toPageNumber = parseInt(toPageNumber)
    
    @previousPage = @currentPage
    @currentPage = @pages[name]

    if not @previousPage
      @activePageView  = new PageView({ model: @pages[name] })
      @$(".page.active").html($(@activePageView.el).html())
      @updateHeight({animate: false})
    else if @currentPage?.get('rank') > @previousPage?.get('rank')
      @nextPageView = new PageView({ model: @pages[name] })
      @$(".page.next").html($(@nextPageView.el).html())
      @animateForward =>
        @updateHeight()
    else
      @nextPageView = new PageView({ model: @pages[name] })
      @$(".page.next").html($(@nextPageView.el).html())
      @animateBackward =>
        @updateHeight()
    
    @pageNumber = toPageNumber
    @setHeaderTitle(@pages[name].get('header'))


  getPageNumber:  -> @pageNumber
  nextPage:       -> @pages.at(@pageNumber + 1)
  prevPage:       -> @pages.at(@pageNumber - 1)
  firstPage:      -> @pages.first()
  lastPage:       -> @pages.last()
  setHeaderTitle: (title) -> $(".header .title").text(title || '')


@$(document).ready =>
  @pages =  
    home: new Page
      rank: 0
      title: false
      content: '''  
        \<br/>
        ![](images/avatar2.jpg) Hello, I'm Chris McCord, a web developer with a 
          passion for science and building things. My current toolkit includes 
          Ruby, Rails, and coffeescript. Here you will find my ramblings and 
          things I find interesting around the internet.

        \<br/>
        # Recent Writings
        - More coffee(script) please

        # Twitter
        - @mguterl @joefiorini I recently set up sunspot/solr for one of our projects and have been really impressed so far.
        - Just finished an excellent profile on Elon Musk by @BloombergNews http://bloom.bg/qgkNhp
        - CoffeeScript should have just been named BaconScript… it's just that good.
      '''

    about:  new Page
      rank: 1
      header: "about"
      title: "About me"
      content: '''
        \<br/>
        ## Professional life
        > During the day I am a Ruby on Rails developer at [Littlelines](http://littlelines.com), a distinguished 
        design and development studio nestled in the midwest with expertise in 
        cutting-edge web development.

        \<br/>
        ## Personal life
        > At home I'm a husband to my lovely wife Jaclyn. I'm passionate about 
        learning new things and a bit of a space nerd. I enjoy sci-fi novels, 
        intelligent conversation, probably too many chickflicks, and hacking on 
        whatever interests me at the time. 
      '''

    contact: new Page
      rank: 2
      header: "contact"
      title: "Contact info and places you can find me"
      content: '''
        - my first name @ this domain
        - [twitter]()
        - [facebook]()
        - [github]()
      '''
      
    writings: new Page
      rank: 3
      header: "writings"
      title: "Writings"
      content: '''
        - More coffee(script) please
        \<br/><br/><br/><br/><br/><br/><br/><br/>tall<br/><br/><br/><br/><br/><br/><br/>page<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>test<br/>
      '''
  
  window.Book = new CoffeeBook
  Book.pages = @pages
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