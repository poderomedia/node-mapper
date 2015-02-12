angular = require('angular')
d3 = require('d3')
d3plus = require('d3plus')
tabletop = require('tabletop')

# Top-level
require('./routes')
require('./data_services')

angular.module('app', [ 'app.routes', 'app.services' ])
    .constant('API_URL', 'http://localhost:9000')


angular.module('app').controller('embedCtrl', ($scope, $stateParams, DataService) ->
    $scope.key = $stateParams.key
    $scope.config = {}
    params = {}
    DataService.promise($scope.key, 'get', params, (result) ->
        console.log("DataService result", result)
    )
)



angular.module('app').controller('projectCtrl', ($scope, $location, DataService) ->
    # $scope.url = 'https://docs.google.com/spreadsheets/d/13VWRA1Vjcn9bu55SCBIFCUoC0kXhlhNrclK67O7ItcM/pubhtml'
    # $scope.url = 'https://docs.google.com/spreadsheets/d/1ozfvHPGlDLIE2idxnj2iDg2H_ZLJYxtgwSgjCKGfnUw/pubhtml'
    $scope.url = 'https://docs.google.com/spreadsheets/d/1nNgKW8EZ98SKOTMEj9wujsJIJfmlRuFUowwRtSbduuQ/pubhtml'
    $scope.key = ''

    getSpreadsheetData = (key) ->
        $scope.loading = true
        console.log("Key:", key)
        Tabletop.init(
            key: key
            callback: (data, tabletop) ->
                console.log(data)
                $scope.loading = false
                $scope.data = data
                $scope.nodeAttributes = data.Data.column_names.slice(1, data.Data.column_names.length)
                $scope.connectionAttributes = data.Connections.column_names.slice(2, data.Connections.column_names.length)

                $scope.config.sNodeLabel = $scope.nodeAttributes[0]
                $scope.config.sNodeColor = $scope.nodeAttributes[1]

                $scope.config.sEdgeLabel = $scope.connectionAttributes[0]

                $scope.stage = $scope.stage + 1

                $scope.$apply()

                params = 
                    data: $scope.data.Data
                    nodes: $scope.data.Nodes
                    connections: $scope.data.Connections

                DataService.promise(key, 'post', params, (result) ->
                    console.log("DataService result", result)
                )
        )

    $scope.getData = (url) ->
        console.log('Getting data for', url)
        key = url.split('/')[5]
        $scope.key = key
        getSpreadsheetData(key)

    $scope.fontSizes = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    $scope.config = 
        width: 600
        height: 300
        sNodeLabel: ''
        sNodeColor: ''
        sNodeSize: ''
        sEdgeLabel: ''
        sEdgeThickness: ''
        sEdgeOpacity: ''
        sFontSize: 12

    $scope.stage = 0

    $scope.embedURL = $location.absUrl().split('//')[1].split('/')[0] + '/#' + '/embed/' + $scope.key # $state.href('embed', {pID: $rootScope.pID, sID: sID})
    $scope.embedHTML = '<iframe width="560" height="315" src="' + $scope.embedURL + '" frameborder="0" allowfullscreen></iframe>'
)




angular.module('app').directive("network", ["$window", "$timeout",
    ($window, $timeout) ->
        return (
            restrict: "EA"
            scope:
                data: "="
                config: "="
            link: (scope, ele, attrs) ->
                scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render(scope.data, scope.config)))

                scope.$watch('data', (data) ->
                    scope.render(data, scope.config)
                , false)

                # http://tech.small-improvements.com/2014/06/11/deep-watching-circular-data-structures-in-angular/
                # watchData = -> scope.data.value
                # watchConfig = -> scope.config.value

                scope.$watch('config', (config) ->
                    scope.render(scope.data, config)
                , true)

                scope.render = (data, config) ->
                    unless data then return
                    console.log("Config:", config)
                    nodeData = data.Data.elements
                    nodes = data.Nodes.elements
                    edges = data.Connections.elements

                    # TODO Make this into a global object and don't rerender everytime
                    network = d3plus.viz()
                        .height(config.height)
                        .width(config.width)
                        .type("network")
                        .color(config.sNodeColor)
                        .container("#viz")
                        .text(config.sNodeLabel)
                        .font(
                            size: config.sFontSize
                        )
                        .data(nodeData)
                        .nodes(nodes)
                        .edges(edges)
                        .edges(
                            label: config.sEdgeLabel
                        )
                        .id("id")
                        .tooltip(["type of entity"])
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