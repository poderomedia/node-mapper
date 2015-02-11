angular = require('angular')

angular.module('app.services', ['ui.router'])

angular.module('app.services').service("DataService", ($http, API_URL) ->
    promise: (key, data, nodes, connections, callback) ->
        console.log(data, nodes, connections)
        $http.post(API_URL + "/api/data",
            key: key
            data:
                column_names: data.column_names
                elements: data.elements
            nodes:
                column_names: nodes.column_names
                elements: nodes.elements
            connections: 
                column_names: connections.column_names
                elements: connections.elements
        ).success((data) ->
            callback(data)
        )
)