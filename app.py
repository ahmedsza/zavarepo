from flask import Flask, jsonify, request, abort, render_template
from flask_cors import CORS
from uuid import uuid4
import json
import math
import time
import logging
import pyodbc
import requests

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


SQL_SERVER_CONFIG = {
    "server": r"(localdb)\MSSQLLocalDB",
    "database": "zavadb",
    "driver": "{ODBC Driver 17 for SQL Server}",
    "trusted_connection": "yes",
}


def get_connection():
    """Return a new pyodbc connection to the zavadb LocalDB instance."""
    conn_str = (
        f"DRIVER={SQL_SERVER_CONFIG['driver']};"
        f"SERVER={SQL_SERVER_CONFIG['server']};"
        f"DATABASE={SQL_SERVER_CONFIG['database']};"
        f"Trusted_Connection={SQL_SERVER_CONFIG['trusted_connection']};"
    )
    return pyodbc.connect(conn_str)

# In-memory product store
data = {}

# Dad joke cache
dad_joke_cache = {
    'joke': None,
    'timestamp': 0
}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getdata', methods=['GET'])
def get_data():
    with open('sampledata.json', 'r') as file:
        data_content = json.load(file)
        users = data_content.get('user')
        # Intentionally cause a complex error: trying to iterate over a non-iterable
        # and perform operations that will fail
        for user in users:
            result = user['name'].split()[0] / len(user['email'])  # TypeError: unsupported operand type(s)
            complex_calc = int(user['address']['zipcode']) + user['phone']  # TypeError if phone is string
            nested_data = data_content['nonexistent_key']['nested']['deep']  # KeyError
        return jsonify(users), 200

@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(list(data.values())), 200

@app.route('/products/<product_id>', methods=['GET'])
def get_product(product_id):
    product = data.get(product_id)
    if not product:
        abort(404)
    return jsonify(product), 200

@app.route('/products', methods=['POST'])
def create_product():
    body = request.get_json()
    if not body or 'name' not in body:
        abort(400)
    product_id = str(uuid4())
    product = {
        'id': product_id, 
        'name': body['name'], 
        'description': body.get('description', ''),
        'price': body.get('price', 0),
        'category': body.get('category', 'General')
    }
    data[product_id] = product
    return jsonify(product), 201

@app.route('/products/<product_id>', methods=['PUT'])
def update_product(product_id):
    if product_id not in data:
        abort(404)
    body = request.get_json()
    if not body or 'name' not in body:
        abort(400)
    data[product_id].update({
        'name': body['name'], 
        'description': body.get('description', ''),
        'price': body.get('price', 0),
        'category': body.get('category', 'General')
    })
    return jsonify(data[product_id]), 200

@app.route('/products/<product_id>', methods=['DELETE'])
def delete_product(product_id):
    if product_id not in data:
        abort(404)
    del data[product_id]
    return '', 204


@app.route('/customer-sales-summary', methods=['GET'])
def get_customer_sales_summary():
    """
    Calls retail.usp_GetCustomerSalesSummary to retrieve all customer sales data.
    """
    try:
        conn = get_connection()
        cursor = conn.cursor()

        logger.info("Executing retail.usp_GetCustomerSalesSummary")
        start = time.perf_counter()

        cursor.execute("EXEC retail.usp_GetCustomerSalesSummary")
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]

        items = rows if rows else []

        elapsed = time.perf_counter() - start
        logger.info(
            "usp_GetCustomerSalesSummary completed — rows=%d in %.2f seconds (%.1f ms)",
            len(items),
            elapsed,
            elapsed * 1000,
        )

        cursor.close()
        conn.close()

        return jsonify({"items": items}), 200

    except Exception as exc:
        logger.error("Error in customer-sales-summary: %s", str(exc))
        return jsonify({"error": str(exc)}), 500


@app.route('/dadjoke', methods=['GET'])
def get_dad_joke():
    """Fetch a dad joke with 5-second caching."""
    try:
        current_time = time.time()
        cache_duration = 5  # 5 seconds
        
        # Check if cache is still valid
        if dad_joke_cache['joke'] and (current_time - dad_joke_cache['timestamp']) < cache_duration:
            logger.info("Returning cached dad joke")
            return jsonify({
                'joke': dad_joke_cache['joke'],
                'cached': True
            }), 200
        
        # Fetch new joke from API
        logger.info("Fetching new dad joke from API")
        response = requests.get(
            'https://icanhazdadjoke.com/',
            headers={'Accept': 'application/json'},
            timeout=5
        )
        
        if response.status_code == 200:
            joke_data = response.json()
            joke_text = joke_data.get('joke', 'No joke available')
            
            # Update cache
            dad_joke_cache['joke'] = joke_text
            dad_joke_cache['timestamp'] = current_time
            
            return jsonify({
                'joke': joke_text,
                'cached': False
            }), 200
        else:
            logger.error(f"Failed to fetch dad joke: {response.status_code}")
            return jsonify({'error': 'Failed to fetch dad joke'}), 500
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Request error fetching dad joke: {str(e)}")
        return jsonify({'error': 'Failed to fetch dad joke'}), 500
    except Exception as e:
        logger.error(f"Error in dad joke endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, port=5000)
