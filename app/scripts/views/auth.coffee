'use strict';

class Tunesmith.Views.LoginView extends Backbone.View

  className: 'popup'

  initialize: ->
    @listenTo(@model, 'authError', @error)
    @listenTo(@model, 'authSuccess', @close)

  events: {
    'click button.close': 'close'
    'click button.submit': 'submit'
    'click .swap': 'swap'
  }

  render: (type) ->
    @type = type
    if type == 'login'
      templateData = {
        header: "Log in to Tunesmith!"
        button: "Log In"
        swap: "Not registered?  Sign up now to save your songs!"
      }
    else
      templateData = {
        header: "Sign up for Tunesmith!"
        button: "Sign Up"
        swap: "Already registered?  Log in to access your songs!"
      }
    $('#greyout').show()
    @$el.html(Templates['auth'](templateData))
    @$el.appendTo('body')

  close: ->
    @$el.detach()
    $('#greyout').hide()

  submit: ->
    @$el.find('.submit').text("Submitting...")
    email = @$el.find('.email').val()
    pass = @$el.find('.password').val()
    console.log('submitting #{email} -- #{pass}')
    if @type == 'login'
      @model.login(email, pass)
    else if @type == 'signup'
      @model.signup(email, pass)

  error: (err) ->
    @render(@type)
    @$el.find('.error').text(err)

  swap: ->
    if @type == 'login' then @type = 'signup' else @type = 'login'
    @render(@type)
