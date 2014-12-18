app = angular.module('app', [])

angular.module('app').controller('projectCtrl', ['$scope', ($scope) ->
    #
    #$scope.url = 'https://docs.google.com/spreadsheets/d/1opf9b1lHbAcFpX-G0j8F-b4kYHdzn8n6VPnY5kz2N3w/pubhtml'
    $scope.url = 'https://docs.google.com/spreadsheets/d/1nNgKW8EZ98SKOTMEj9wujsJIJfmlRuFUowwRtSbduuQ/pubhtml'
    getSpreadsheetData = (key) ->
        console.log("Key:", key)
        Tabletop.init(
            key: key
            callback: (data, tabletop) ->
                $scope.data = data
                $scope.nodeAttributes = data.Data.column_names.slice(1, data.Data.column_names.length)
                $scope.connectionAttributes = data.Connections.column_names.slice(2, data.Connections.column_names.length)
                $scope.$apply()
        )

    $scope.getData = (url) ->
        console.log('Getting data for', url)
        key = url.split('/')[5]
        getSpreadsheetData(key)

    $scope.config =
        sNodeLabel: ''
        sNodeColor: ''
        sNodeSize: ''
        sEdgeLabel: ''
        sEdgeThickness: ''
        sEdgeOpacity: ''
])

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
                    cdata = _.clone(data, true);

                    nodeData = data.Data.elements
                    nodes = data.Nodes.elements
                    edges = data.Connections.elements

                    nodes = cdata.Data.elements;
                    nodes.forEach((n) -> n.x = 100; n.y = 50)

                    edges = cdata.Connections.elements.map (e) ->
                                source: (nodes.findIndex (n) -> n.id == e.source)
                                target: (nodes.findIndex (n) -> n.id == e.target)

                    color = d3.scale.category20()
                                    .domain(_.uniq(edges.map((e) -> e['type of entity'])))

                    container = document.getElementById('viz')

                    svg = d3.select("#viz").append("svg")
                            .attr("width", container.scrollWidth)
                            .attr("height", container.scrollHeight)


                    # create vertical alignment constraints for each group
                    # (type of entity)
                    constraints = _.pairs(_.groupBy(nodes,
                                            (n) -> n['type of entity']))
                                  .map((p, i) ->
                                          type: 'alignment'
                                          axis: 'x'
                                          offsets: p[1].map((n) ->
                                                     node: nodes.findIndex (m) -> m.id == n.id
                                                     offset: i
                                                  )
                                        )

                    # create vertical separation constraints between first nodes of
                    # each group (keeps groups separate)
                    sepConstraints = _.initial(_.zip(constraints, constraints.slice(1)))
                                      .map((p) ->
                                         type: 'separation'
                                         axis: 'x'
                                         left: p[0].offsets[0].node,
                                         right: p[1].offsets[1].node,
                                         gap: 130,
                                         equality: true
                                     )

                    # create horizontal separation constraints between nodes
                    # of each group (keeps members of groups evenly distributed)
                    distConstraints = _.flatten(constraints.map((c) ->
                        _.initial(_.zip(c.offsets, c.offsets.slice(1))).map((p) ->
                             type: 'separation'
                             axis: 'y'
                             left: p[0].node
                             right: p[1].node
                             gap: 70
                             equality: true
                        )))

                    constraints = constraints.concat distConstraints
                    constraints = constraints.concat sepConstraints

                    d3cola = cola.d3adaptor()
                           .size([container.scrollWidth,
                                 container.scrollHeight])
                           .nodes(nodes)
                           .links(edges)
#                           .symmetricDiffLinkLengths(25)
#                           .jaccardLinkLengths(100)
                           .constraints(constraints)
                           .start(100)


                    link = svg.selectAll(".link")
                              .data(edges)
                              .enter()
                              .append("line")
                              .attr("class", "link")
                              .attr('stroke-width', 2)

                    node = svg.selectAll(".node")
                              .data(nodes)
                              .enter().append("rect")
                              .attr("class", "node")
                              .attr('width', 50)
                              .attr('height', 50)
                              .attr('rx', 25)
                              .attr('ry', 25)
                              .style("fill", (d) -> color(d['type of entity']) )
#                              .on("click", (d) -> d.fixed = true)
                              .call(d3cola.drag)

                    node.append("title")
                        .text((d) -> d.name + ' (' + d['type of entity'] + ')')

                    d3cola.on('tick', ->
                            link.attr('x1', (d) -> d.source.x)
                                .attr('y1', (d) -> d.source.y)
                                .attr('x2', (d) -> d.target.x)
                                .attr('y2', (d) -> d.target.y)

                            # node.attr('cx', (d) -> d.x)
                            #     .attr('cy', (d) -> d.y)
                            node.attr('x', (d) -> d.x - 50 / 2)
                                .attr('y', (d) -> d.y - 50 / 2)
                            )
        )
])
