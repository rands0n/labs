class Todo extends Backbone.Model
  defaults:
    title: ''
    completed: false

  toggle: ->
    this.save
      completed: !this.get 'completed'
