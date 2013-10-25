'use strict';

class Tunesmith.Collections.ClipCollection extends Backbone.Collection
  
  model: Tunesmith.Models.ClipModel

  initialize: =>
    @add({type:'addnew'})
    @on('addnew', @addNew, @)
    @on('cancel', (model) =>
      console.log model
      @remove(model, {silent:true})
    ,@)

  addNew: =>
    @add({type:'choose'}, {at: @length - 1})
