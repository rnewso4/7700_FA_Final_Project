import csv
from flask import Flask, jsonify
from main import *

app = Flask(__name__)

model, stats = preprocessing()

# This method is to get the data from the frontend, call the generate model, and return the target value 
# @returns: daily revenue dollar amount
@app.route('/api/data/<d1>/<d2>/<d3>/<d4>/<d5>/<d6>/', methods=['GET'])
def get_data(d1, d2, d3, d4, d5, d6):
    data1 = [float(d1), float(d2), float(d3), float(d4), float(d5), float(d6)]
    data = generate(model, data1, stats[0], stats[1], stats[2], stats[3])
    return jsonify(data)

# The X values as well as the generated y value is saved in the CSV file for further training
# Future implementation will have it so that only actual data with the real revenue score inputted from the user will save
@app.route('/api/postdata/<d1>/<d2>/<d3>/<d4>/<d5>/<d6>/<d7>', methods=['POST'])
def post_data(d1, d2, d3, d4, d5, d6, d7):
    with open('coffee_shop_revenue.csv', 'a') as f:
        data2 = [float(d1), float(d2), float(d3), float(d4), float(d5), float(d6), float(d7)]
        writer = csv.writer(f)
        writer.writerow(data2)
    return jsonify({"message": "Data saved successfully!"})

if __name__ == '__main__':
    app.run(debug=True)