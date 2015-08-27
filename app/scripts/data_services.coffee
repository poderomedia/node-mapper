angular = require('angular')

angular.module('app.services', ['ui.router'])

angular.module('app.services').service("ConfigService", ($http, API_URL) ->
    promise: (key, method, params, callback) ->
        ENDPOINT = API_URL + "config"

        if method is 'get'
            $http.get(ENDPOINT,
                params:
                    key: key
            ).success( (data) -> callback(data) )

        else if method is 'post'
            # JSON.stringify(params.config)
            console.log('in post ConfigService', key, method, params)
            $http.post(ENDPOINT,
                key: key
                config: JSON.stringify(params.config)
            ).success( (data) -> callback(data) )
)

angular.module('app.services').service("DataService", ($http, API_URL) ->
    promise: (key, method, params, callback) ->
        ENDPOINT = API_URL + "data"
        console.log( key, method, params, callback )

        if method is 'get'
            $http.get(ENDPOINT,
                params:
                    key: key
            ).success( (data) -> callback(data) )

        else if method is 'post'
            nodes = params.nodes
            connections = params.connections

            $http.post(ENDPOINT,
                key: key
                nodes: JSON.stringify(
                    column_names: nodes.column_names
                    elements: nodes.elements
                    )
                connections: JSON.stringify(
                    column_names: connections.column_names
                    elements: connections.elements
                    )
            ).success( (data) -> callback(data) )
)
