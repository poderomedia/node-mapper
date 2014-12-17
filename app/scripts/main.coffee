app = angular.module('app', [])

angular.module('app').controller('projectCtrl', ['$scope', ($scope) ->
    # $scope.url = 'https://docs.google.com/spreadsheets/d/13VWRA1Vjcn9bu55SCBIFCUoC0kXhlhNrclK67O7ItcM/pubhtml'
    # $scope.url = 'https://docs.google.com/spreadsheets/d/1ozfvHPGlDLIE2idxnj2iDg2H_ZLJYxtgwSgjCKGfnUw/pubhtml'
    $scope.url = 'https://docs.google.com/spreadsheets/d/1nNgKW8EZ98SKOTMEj9wujsJIJfmlRuFUowwRtSbduuQ/pubhtml'
    getSpreadsheetData = (key) ->
        console.log("Key:", key)
        Tabletop.init(
            key: key
            callback: (data, tabletop) ->
                $scope.data = data
                console.log(data.Connections)
                $scope.nodeAttributes = data.Data.column_names.slice(1, data.Data.column_names.length)
                $scope.connectionAttributes = data.Connections.column_names.slice(2, data.Connections.column_names.length)
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
                    edges = data.Connections.elements
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