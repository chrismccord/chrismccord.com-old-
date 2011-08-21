# Models
class @Page extends Backbone.Model
  
  
  
# Collections
class @Pages extends Backbone.Collection
  model: Page
  pageIds: -> @pluck('id')
  
  
  
# Views

class @PageView extends Backbone.View
  
  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

class @BookView extends Backbone.View
  
  initialize: ->
    _.bindAll(@, 'render')
    @model.bind('change', @render)
    @render()
    
    
  render: ->
    template = Handlebars.compile($("#page-template").html())
    $(@el).html(template(@model.toJSON()))
    
@CoffeeBook =
  defaults:
    width: 940
    height: 800

  pageNumber: 0
  pages: new Pages([
      new Page({ title: 'page 1', content: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"}),
      new Page({ title: 'page 2', content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."}),
    ])

  init: ->
    @goTo(0)


  # Seek to page model
  #
  goTo: (pageNumber) ->
    #TODO validate this
    @pageNumber = pageNumber
    activePageView  = new BookView({el: '#active_page', model: @currentPage() })
    nextPageView = new BookView({el: '#next_page', model: @nextPage() })


  currentPage: -> @pages.at(@pageNumber) 
  nextPage:    -> @pages.at(@pageNumber + 1)
  prevPage:    -> @pages.at(@pageNumber - 1)
  firstPage:   -> @pages.first()
  lastPage:    -> @pages.last()

@$(document).ready ->
  CoffeeBook.init()
  speedFactor = 0.50
  setTimeout((->
      $("#turn").animate {right: $("#active_page").width() + 20}, 1800 * speedFactor,'linear', ->
        $(@).fadeOut(50)
      $("#turn .middle").animate({width: $("#active_page").width() * 1.25}, 1800 * speedFactor,'linear')
      
      $("#active_page").parent().animate {width: 0}, 1200 * speedFactor, 'linear', ->
            $("#active_page").parent().hide()
    ), 1000)