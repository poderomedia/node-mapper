app = angular.module('app', [])

angular.module('app').controller('projectCtrl', ['$scope', ($scope) ->
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
                    edges = data.Connections.elements.map (e) ->
                                source: (nodes.findIndex (n) -> n.id == e.source)
                                target: (nodes.findIndex (n) -> n.id == e.target)

                    container = document.getElementById('viz')

                    svg = d3.select("viz").append("svg")
                            .attr("width", container.scrollWidth)
                            .attr("height", container.scrollHeight);

                    d3cola = cola.d3adaptor()
                        .linkDistance(120)
                        .avoidOverlaps(true)
                        .size([container.scrollWidth, container.scrollHeight])

                    d3cola.nodes(nodes)
                          .links(links)
                          .start(10,10,10)

                    link = svg.selectAll(".link")
                              .data(graph.links)
                              .enter().append("line")
                              .attr("class", "link")
        )
])
