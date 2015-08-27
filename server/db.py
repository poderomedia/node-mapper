import pymongo
from bson.objectid import ObjectId


def formatObjectIDs(collectionName, results):
    for result in results: # For each result is passed, convert the _id to the proper mID, cID, etc.
        result[collectionName[0]+'ID'] = str(result.pop('_id')) # Note the .pop removes the _id from the dict
    return results


class mongoInstance(object):

    def getConfig(self, key):
        result = MongoInstance.client['NodeMapper'].config.find_one({'key': key})
        config = result['config']
        return { 'Config': config }

    def postConfig(self, key, config):
        doc = {
            'config': config
        }
        print MongoInstance.client['NodeMapper'].config.find_and_modify({'key': key}, {'$set': doc}, upsert=True, new=True)
        return { 'result': 'inserted' }

    def getData(self, key):
        result = MongoInstance.client['NodeMapper'].data.find_one({'key': key})

        nodes = result['nodes']
        connections = result['connections']

        return { 'Nodes': nodes, 'Connections': connections }

    def postData(self, key, nodes, connections):
    	doc = {
        	'nodes': nodes,
        	'connections': connections
    	}
    	print MongoInstance.client['NodeMapper'].data.find_and_modify({'key': key}, {'$set': doc}, upsert=True, new=True)
        return { 'result': 'inserted' }

    # Client corresponding to a single connection
    @property
    def client(self):
        if not hasattr(self, '_client'):
            self._client = pymongo.MongoClient(host='localhost:27017')
        return self._client

# A Singleton Object
MongoInstance = mongoInstance()
