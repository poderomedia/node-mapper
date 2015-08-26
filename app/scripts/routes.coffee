require('angular-ui-router')

angular.module('app.routes', ['ui.router']).config(($stateProvider, $urlRouterProvider, $locationProvider) ->

  $urlRouterProvider.otherwise("/")
  $stateProvider
    .state('landing',
      url: '/'
      controller: 'projectCtrl'
      templateUrl: 'templates/landing.html'
    )
    .state('embed',
      url: '/embed/:key'
      controller: 'embedCtrl'
      templateUrl: 'templates/embed.html'
    )

  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode(true)
)
