
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
