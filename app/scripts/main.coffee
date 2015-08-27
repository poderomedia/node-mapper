angular = require('angular')
$ = require('jquery')
d3 = require('d3')
d3plus = require('d3plus')
tabletop = require('tabletop')


# Top-level
require('./routes')
require('./data_services')


angular.module('app', [ 'app.routes', 'app.services' ])
    .constant('API_URL', 'http://localhost:9000/api/')


angular.module('app').controller('embedCtrl', ($scope, $stateParams, DataService, ConfigService) ->
    $scope.key = $stateParams.key
    $scope.config = {}
    params = {}
    DataService.promise($scope.key, 'get', params, (result) ->
        $scope.data = result
    )

    ConfigService.promise($scope.key, 'get', params, (result) ->
        $scope.config = result.Config
    )
)


angular.module('app').controller('projectCtrl', ($scope, $location, DataService, ConfigService) ->
    # Old Test Dataset
    # $scope.url = 'https://docs.google.com/spreadsheets/d/1nNgKW8EZ98SKOTMEj9wujsJIJfmlRuFUowwRtSbduuQ/pubhtml'
    $scope.url = 'https://docs.google.com/spreadsheets/d/10I6n-zWn2ieE3_qIjOveK-5owUJ5Em59Sxed5NejQp8/pubhtml'
    $scope.key = 'test'

    getSpreadsheetData = (key) ->
        $scope.loading = true
        $scope.embedURL = $location.absUrl().split('//')[1].split('/')[0] + '/embed/' + key # $state.href('embed', {pID: $rootScope.pID, sID: sID})
        $scope.embedHTML = '<iframe width="560" height="315" src="' + $scope.embedURL + '" frameborder="0" allowfullscreen></iframe>'

        Tabletop.init(
            key: key
            callback: (data, tabletop) ->
                $scope.loading = false
                $scope.data = data
                nodes = data.Nodes
                connections = data.Connections

                # TODO Provide more flexibility for the data input structure
                $scope.nodeAttributes = nodes.column_names.slice(1, nodes.column_names.length)
                $scope.connectionAttributes = connections.column_names.slice(2, connections.column_names.length)

                $scope.config.sNodeColor = $scope.nodeAttributes[0]
                $scope.config.sEdgeLabel = $scope.connectionAttributes[0]

                $scope.stage = $scope.stage + 1

                $scope.$apply()

                params =
                    nodes: nodes
                    connections: connections

                # Getting rid of this functionality for now
                # DataService.promise(key, 'post', params, (result) -> )
        )

    $scope.getData = (url) ->
        key = url.split('/')[5]
        $scope.key = key
        getSpreadsheetData(key)

    $scope.saving = false
    $scope.saveConfig = ->
        $scope.saving = true
        config = $scope.config
        params =
            config: config

        ConfigService.promise($scope.key, 'post', params, (result) ->
            $scope.saving = false
        )

    $scope.fontSizes = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    $scope.config =
        width: ''
        height: ''
        sNodeLabel: ''
        sNodeColor: ''
        sNodeSize: ''
        sEdgeLabel: ''
        sEdgeThickness: ''
        sEdgeOpacity: ''
        sFontSize: 12

    $scope.stage = 0
)


angular.module('app').directive("network", ["$window", "$timeout",
    ($window, $timeout) ->
        return (
            restrict: "EA"
            scope:
                data: "="
                config: "="
            link: (scope, ele, attrs) ->
                network = d3plus.viz()


                # Resizing watch
                scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render(scope.data, scope.config)))

                scope.$watch('data', ((data) -> scope.render(data, scope.config)), false)

                # Deep watching config data structure
                # http://tech.small-improvements.com/2014/06/11/deep-watching-circular-data-structures-in-angular/
                scope.$watch('config', ((config) -> scope.render(scope.data, config)), true)

                scope.render = (data, config) ->
                    unless data then return

                    nodes = data.Nodes.elements
                    edges = data.Connections.elements
                    console.log("Config", config)
                    console.log("Nodes and edges", nodes, edges)
                    console.log("Viz Object", network)

                    # TODO Make this into a global object and don't rerender everytime
                    network.container("#viz")
                      .type("network")
                      .width(config.width)
                      .height(config.height)
                      .data(nodes)
                      .nodes(nodes)
                      .edges(edges)
                      .size(config.sNodeSize)
                      .edges(
                        label: config.sEdgeLabel
                      )
                      .font(
                        size: config.sFontSize
                      )
                      .id("name")
                      .draw()
        )
])

angular.module('app').directive('selectOnClick', ->
    return {
        restrict: 'A'
        link: (scope, element, attrs) ->
            element.on('click', -> this.select())
        }
)
