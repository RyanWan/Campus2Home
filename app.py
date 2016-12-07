from flask import Flask, request, jsonify
import math
from test_db import *
import signal, sys


app = Flask(__name__)

DEFAULT_START = ["Mallinckrodt Center", [38.6469085,-90.3111762]]

@app.route('/')
def hello_world():
    return "Hello, world!"

@app.route('/shutdown')
def shut_server():
    con, meta = connect()
    drop_table(con, meta)

@app.route('/submit/<time>/<address>/<geocode>', methods=['GET'])
def submit(time, address, geocode):
    con, meta = connect()
    address = " ".join(address.split('+'))
    insert_address(con, meta, time, address, geocode)
    test = {1: 'me', 2: 'you'}
    return jsonify(test)


@app.route('/receive/<time>/<action>', methods=['GET'])
def receive(time, action):
    con, meta = connect()
    ret = select_time(con, meta, time)
    if action == "update":
        address = [x[0] for x in ret]
        json = {"address": address}
        print(json)
        return jsonify(json)
    elif action == "route":
        ret = plan_route(ret)
        all_dict = []
        for item in ret:
            temp = {}
            temp['address'] = item[0]
            temp['x'] = item[1][0]
            temp['y'] = item[1][1]
            all_dict.append(temp)
        json = {"route": all_dict}
        return jsonify(json)

    test = {1: 'me', 2: 'you'}
    test[3] = [time]
    return jsonify(test)


def sig_handler(signal, frame):
    print("SIGINT detected")
    print("Deleting database")
    con, meta = connect()
    drop_table(con, meta)
    sys.exit(0)

def plan_route(locations):
    # list = [['a', '-1,-1'], ['b', '1,-1'], ['c', '1, 1'], ['d', '-1, 1']]
    geocode = []
    for address, code in locations:
        x, y = map(float, code.split(','))
        geocode.append([address,[x,y]])

    geocode.append(DEFAULT_START)
    print(geocode)
    ave_x = sum(geo[1][0] for geo in geocode) / len(geocode)
    ave_y = sum(geo[1][1] for geo in geocode) / len(geocode)
    print(ave_x, ave_y)
    for i in range(len(geocode)):
        x = geocode[i]
        #print((x[1][1] - ave_y ),(x[1][0] - ave_x))
        print(math.atan2( (x[1][0] - ave_x),(x[1][1] - ave_y )  ) )
    geocode = sorted(geocode, key=lambda x: math.atan2( (x[1][0] - ave_x),(x[1][1] - ave_y )  ) )
    #sorted(geocode, key=lambda x: x[0])
    for i in range(len(geocode)):
        x = geocode[i]
        #print((x[1][1] - ave_y ),(x[1][0] - ave_x))
        print(math.atan2( (x[1][0] - ave_x),(x[1][1] - ave_y )  ) )
    for i in range(len(geocode)):
        if geocode[i][0] == "Mallinckrodt Center":
            index = i
            break
    print(geocode)
    geocode = geocode[i:] + geocode[:i]
    geocode.append(DEFAULT_START)
    print(geocode)
    return geocode

if __name__ == '__main__':
    con, meta = connect()
    create_table(con, meta)
    print("TABLE created")
    original_sigint = signal.getsignal(signal.SIGINT)
    signal.signal(signal.SIGINT, sig_handler)
    app.run(debug=True, host='localhost')
