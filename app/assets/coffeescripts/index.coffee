
# Router
class Router extends Backbone.Router
  routes:
    ''                                  : 'home'
    '/pages/:name'                      : 'page'
    '/pages/:name/:number'              : 'page'
    '/writings/:name'                   : 'page'
    '/writings/:name/:number'           : 'page'

    
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
    window.location = "#/pages/#{@getPageNumber() + 1}" unless @isAnimating()
    false
  back: -> 
    window.location = "#/pages/#{@getPageNumber() - 1}" unless @isAnimating()
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
    height = $(".page.active").height() + 24
    height = @options.minHeight + 24 if height < @options.minHeight
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


window.onload = -> 
  Book.updateHeight(animate: false)
  $(".header, .book_wrap").animate opacity: 1, 500

@$(document).ready =>
  $(".header, .book_wrap").css opacity: 0
  @pages =  
    home: new Page
      rank: 0
      title: false
      content: '''  
        \<br/>
        ![](images/avatar4.png) Hello, I'm Chris McCord, a web developer with a 
          passion for science and building things. My current toolkit includes 
          Ruby, Rails, and coffeescript. Here you will find my ramblings and 
          things I find interesting around the internet.

        \<br/>
        # Recent Writings
        - [CoffeeKup Rails: An asset pipleine engine for cofeekup](#/writings/coffeekup-rails)        

        # Places you can find me
        - [twitter](https://twitter.com/#!/chris_mccord)
        - [facebook](https://www.facebook.com/chrisfmccord)
        - [github](https://github.com/chrismccord)
        
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
        - [twitter](https://twitter.com/#!/chris_mccord)
        - [facebook](https://www.facebook.com/chrisfmccord)
        - [github](https://github.com/chrismccord)
      '''
      
    writings: new Page
      rank: 3
      header: "writings"
      title: "Writings"
      content: '''
        - [CoffeeKup Rails: An asset pipleine engine for cofeekup](#/writings/coffeekup-rails)
           
      '''
  
    "more-coffeescript-please": new Page
      rank: 100
      header: "writings"
      title: "More coffee(script) please"
      content: """
      """

    "coffeekup-rails": new Page
      rank: 100
      header: "writings"
      title: "CoffeeKup Rails: An asset pipleine engine for cofeekup"
      content: """
        \<br/>
        I have been in the process of developing _yet another_ client side MVC framework. This one 
        in particular in coffreescript and targeting Rails integration. I will have more on that 
        as things progress. This gem grew out of my need to treat coffeekup template files as first 
        class citizens in the asset pipeline. The coffeekup node command is lacking in regards to 
        directory watching and I wanted an experience identical to asset pipeline compilation for 
        coffee or jst files. Enter [coffeekup_rails](https://github.com/chrismccord/coffeekup_rails).

        ## How it's used
        Say your client side views live in `/app/assets/javascripts/views` (default).
        
        Given `/app/assets/javascripts/views/shared/hello.js.ck`:

            h1 "Hello \#{@name}."

        CoffeeKup will automatically compile the coffeescript source to a coffeekup javascript template under a desired 
        global js object (defaults to `window.templates`). 
        Template names are period delimited by directory structure. From the javascript console:

            templates['shared.hello']({name: 'chris'})
            => "<h1>Hello chris.</h1>"

        This happens upon every page load when your .ck files change thanks to sprockets and the 
        asset pipeline just as you would expect for a .coffee file. For installation instructions, configuration, 
        and more, check the [github project page](https://github.com/chrismccord/coffeekup_rails).
      """

  window.Book = new CoffeeBook
  Book.pages = @pages
  Book.init()
