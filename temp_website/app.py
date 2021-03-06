from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os
import database.db_connector as db

# CONFIGURATION
app = Flask(__name__)
db_connection = db.connect_to_database()

app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_behringr'
app.config['MYSQL_PASSWORD'] = '1834'
app.config['MYSQL_DB'] = 'cs340_behringr'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)

people_from_app_py = [
{
    "name": "Thomas",
    "age": 33,
    "location": "New Mexico",
    "favorite_color": "Blue"
},
{
    "name": "Gregory",
    "age": 41,
    "location": "Texas",
    "favorite_color": "Red"
},
{
    "name": "Vincent",
    "age": 27,
    "location": "Ohio",
    "favorite_color": "Green"
},
{
    "name": "Alexander",
    "age": 29,
    "location": "Florida",
    "favorite_color": "Orange"
}
]

# ROUTES
@app.route('/')
def home():
    return redirect("/index")

@app.route('/index')
def index():
    return render_template("index.jinja2")

@app.route('/users', methods=["POST", "GET"])
def user():
    if request.method == "GET":
        query = "SELECT Users.userID AS 'User ID', firstName AS 'First Name', lastName AS 'Last Name', address AS Address, specialization AS Specialization, bio AS Biography FROM Users"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        usersQuery = "SELECT CONCAT(firstName, ' ', lastName) FROM Users"
        cur = mysql.connection.cursor()
        cur.execute(usersQuery)
        users = cur.fetchall()

        return render_template("users.jinja2", data=data, users=users)


@app.route('/rocks', methods=["POST", "GET"])
def rock():
    if request.method == "GET":
        query = "SELECT Rocks.rockID AS 'Rock Number', Rocks.name AS 'Rock Name', CONCAT(Users.firstName, ' ', Users.lastName) AS Owner, Rocks.geoOrigin AS 'Place of Origin', Rocks.type AS 'Rock Type', Rocks.description AS 'Description', Rocks.chemicalComp AS 'Chemical Composition' FROM Rocks INNER JOIN Users ON Rocks.userID = Users.userID"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        usersQuery = "SELECT CONCAT(firstName, ' ', lastName) FROM Users"
        cur = mysql.connection.cursor()
        cur.execute(usersQuery)
        users = cur.fetchall()

        return render_template("rocks.jinja2", data=data, users=users)

@app.route('/reviews', methods=["POST", "GET"])
def review():
    if request.method == "GET":
        # query = "SELECT Reviews.reviewID AS 'Review Number', title AS Title, body AS Body, rating AS 'Review Rating' FROM Reviews"
        query = "SELECT Reviews.reviewID, CONCAT(Users.firstName, ' ', Users.lastName) AS Reviewer, Rocks.name AS Rock, Reviews.title AS Title, Reviews.body AS Review, Reviews.rating AS Rating FROM Reviews INNER JOIN Users ON Reviews.userID = Users.userID INNER JOIN Rocks ON Reviews.rockID = Rocks.rockID"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        usersQuery = "SELECT CONCAT(firstName, ' ', lastName) FROM Users"
        cur = mysql.connection.cursor()
        cur.execute(usersQuery)
        users = cur.fetchall()

        rocksQuery = "SELECT name FROM Rocks"
        cur = mysql.connection.cursor()
        cur.execute(rocksQuery)
        rocks = cur.fetchall()

        return render_template("reviews.jinja2", data=data, rocks=rocks, users=users)

@app.route('/shipments', methods=["POST", "GET"])
def shipment():
    if request.method == "GET":
        shipmentsQuery = "SELECT Shipments.shipmentID AS 'Shipping Number', CONCAT(Users.firstName, ' ', Users.lastName) AS 'Associated User', Shipments.shipOrigin AS 'Origin', Shipments.shipDest as 'Destination', Shipments.shipDate AS 'Date Shipped', Shipments.miscNote AS Notes FROM Shipments INNER JOIN Users ON Shipments.userID = Users.userID"
        cur = mysql.connection.cursor()
        cur.execute(shipmentsQuery)
        data = cur.fetchall()

        rocksQuery = "SELECT name FROM Rocks"
        cur = mysql.connection.cursor()
        cur.execute(rocksQuery)
        rocks = cur.fetchall()

        usersQuery = "SELECT CONCAT(firstName, ' ', lastName) FROM Users"
        cur = mysql.connection.cursor()
        cur.execute(usersQuery)
        users = cur.fetchall()

        return render_template("shipments.jinja2", data=data, rocks=rocks, users=users)

@app.route('/edit_shipment', methods=["POST", "GET"])
def shipment_has_rocks():
    
    if request.method == "GET":
        shipment_has_rocksQuery = "SELECT Rocks.name AS Rock, Shipments.shipOrigin AS 'Shipment Origin', Shipments.shipDest AS 'Shipment Destination', Shipments.shipDate AS 'Shipment Date' FROM Shipments_has_Rocks INNER JOIN Rocks ON Shipments_has_Rocks.rockID = Rocks.rockID INNER JOIN Shipments ON Shipments.shipmentID = Shipments_has_Rocks.shipmentID"
        cur = mysql.connection.cursor()
        cur.execute(shipment_has_rocksQuery)
        shipment_details = cur.fetchall()

        shipmentsQuery = "SELECT Shipments.shipmentID AS 'Shipping Number' , shipOrigin AS 'Origin', shipDest as 'Destination', shipDate AS 'Date Shipped' FROM Shipments"
        cur = mysql.connection.cursor()
        cur.execute(shipmentsQuery)
        shipments = cur.fetchall()

        rocksQuery = "SELECT name FROM Rocks"
        cur = mysql.connection.cursor()
        cur.execute(rocksQuery)
        rocks = cur.fetchall()

        return render_template("shipments_has_rocks.jinja2", rocks=rocks, shipment_details=shipment_details, shipments=shipments)

###########################################

# LISTENER
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 41992))

    app.run(port=port, debug=True)
