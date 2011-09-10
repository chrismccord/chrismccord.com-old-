

guard 'sass', :input => 'app/assets/stylesheets', :output => 'public/stylesheets'
guard 'coffeescript', :input => 'app/assets/coffeescripts', :output => 'public/javascripts'

guard 'coffeescript', :output => '.' do 
  watch(%r{^(\w+\.coffee)$})
end

guard 'livereload', :apply_js_live => false, :apply_css_live => true  do
 watch(%r{app/.+\.(erb|haml)})
 watch(%r{app/helpers/.+\.rb})
 watch(%r{app/assets/stylesheets/.+\.(sass|scss)})
 watch(%r{app/assets/javascripts/.+\.(coffee|js)})
 watch(%r{vendor/assets/javascripts/.+\.(coffee|js)})
 watch(%r{public/images/.+\.(png|gif|jpg)})
 watch(%r{config/locales/.+\.yml})

 # Jasmine specs
 watch(%r{^spec/coffeescripts/.*\.coffee$})
end