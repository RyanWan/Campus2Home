from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello, world!"

@app.route('/submit', methods=['POST'])
def submit():
    assert request.form['address'] is not None


@app.route('/receive', methods=['GET'])
def receive():
    test = {1: 'me', 2: 'you'}

    return jsonify(test)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
