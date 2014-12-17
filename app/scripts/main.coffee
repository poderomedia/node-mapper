app = angular.module('app', [])

angular.module('app').controller('projectCtrl', ['$scope', ($scope) ->
    $scope.url = 'https://docs.google.com/spreadsheets/d/1ozfvHPGlDLIE2idxnj2iDg2H_ZLJYxtgwSgjCKGfnUw/pubhtml'
    # $scope.url = 'https://docs.google.com/spreadsheets/d/1nNgKW8EZ98SKOTMEj9wujsJIJfmlRuFUowwRtSbduuQ/pubhtml'
    getSpreadsheetData = (key) ->
        Tabletop.init(
            key: key
            callback: (data, tabletop) ->
                $scope.data = data
                console.log(data)
                $scope.$apply()
        )

    $scope.getData = (url) ->
        console.log('Getting data for', url)
        key = url.split('/')[5]
        getSpreadsheetData(key)
])

angular.module('app').directive("network", ["$window", "$timeout",
    ($window, $timeout) ->
        return (
            restrict: "EA"
            scope:
                data: "="
            link: (scope, ele, attrs) ->
                x = 'test'

                scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render(scope.data)))

                scope.$watchCollection("[data]", ((newData) ->
                  scope.render(newData[0])
                  ), true)

                scope.render = (data) ->
                    unless data then return
                    nodeData = data.Data.elements
                    nodes = data.Nodes.elements
                    edges = data.Edges.elements
                    console.log(nodeData, nodes, edges)

                    network = d3plus.viz()
                        .type("network")
                        .color("type of entity")
                        .container("#viz")
                        .text("name")
                        .font(
                            size: 10
                        )
                        .data(nodeData)
                        .nodes(nodes)
                        .edges(edges)
                        .edges(
                            label: "type"
                        )
                        .id("id")
                        .tooltip(["type of entity"])
                        .draw()

        )
])