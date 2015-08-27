from flask import Flask, render_template, redirect, url_for, request, make_response, json, send_file
from flask.ext.restful import Resource, Api, reqparse
from bson.objectid import ObjectId

from db import MongoInstance as MI


PORT = 9000

app = Flask(__name__, static_path='/static')
api = Api(app)


@app.before_request
def option_autoreply():
    """ Always reply 200 on OPTIONS request """

    if request.method == 'OPTIONS':
        resp = app.make_default_options_response()

        headers = None
        if 'ACCESS_CONTROL_REQUEST_HEADERS' in request.headers:
            headers = request.headers['ACCESS_CONTROL_REQUEST_HEADERS']

        h = resp.headers

        # Allow the origin which made the XHR
        h['Access-Control-Allow-Origin'] = request.headers['Origin']
        # Allow the actual method
        h['Access-Control-Allow-Methods'] = request.headers['Access-Control-Request-Method']
        # Allow for 10 seconds
        h['Access-Control-Max-Age'] = "10"

        # We also keep current headers
        if headers is not None:
            h['Access-Control-Allow-Headers'] = headers

        return resp


@app.after_request
def set_allow_origin(resp):
    """ Set origin for GET, POST, PUT, DELETE requests """

    h = resp.headers

    # Allow crossdomain for other HTTP Verbs
    if request.method != 'OPTIONS' and 'Origin' in request.headers:
        h['Access-Control-Allow-Origin'] = request.headers['Origin']
    return resp


configGetParser = reqparse.RequestParser()
configGetParser.add_argument('key', type=str, required=True)

configPostParser = reqparse.RequestParser()
configPostParser.add_argument('key', type=str, required=True)
configPostParser.add_argument('config', type=str, required=True)
class Config(Resource):
    def get(self):
        args = configGetParser.parse_args()
        key = args.get('key')
        return MI.getConfig(key)

    def post(self):
        args = configPostParser.parse_args()

        key = args.get('key')
        config = json.loads(args.get('config'))

        return MI.postConfig(key, config)
api.add_resource(Config, '/api/config')


dataGetParser = reqparse.RequestParser()
dataGetParser.add_argument('key', type=str, required=True)

dataPostParser = reqparse.RequestParser()
dataPostParser.add_argument('key', type=str, required=True)
dataPostParser.add_argument('nodes', type=str, required=True)
dataPostParser.add_argument('connections', type=str, required=True)
class Data(Resource):
    def get(self):
        args = dataGetParser.parse_args()
        key = args.get('key')
        return MI.getData(key)

    def post(self):
        args = dataPostParser.parse_args()

        key = args.get('key')
        nodes = json.loads(args.get('nodes'))
        connections = json.loads(args.get('connections'))

        return MI.postData(key, nodes, connections)
api.add_resource(Data, '/api/data')


if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=PORT)
