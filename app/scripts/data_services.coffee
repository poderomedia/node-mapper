angular = require('angular')

angular.module('app.services', ['ui.router'])

angular.module('app.services').service("DataService", ($http, API_URL) ->
    promise: (key, method, params, callback) ->
        ENDPOINT = API_URL + "/api/data"
        console.log( key, method, params, callback )

        if method is 'get'
            $http.get(ENDPOINT,
                params:
                    key: key
            ).success( (data) -> 
                callback(data) 
            )

        else if method is 'post'
            data = params.data
            nodes = params.nodes
            connections = params.connections

            $http.post(ENDPOINT,
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
            ).success( (data) -> callback(data) )

)