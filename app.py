from flask import Flask 
import os

app = Flask(__name__)

# Get dyn port as 'MY_FLASK_PORT', default is '8080'
port = int(os.environ.get('MY_FLASK_PORT', '8080'))

@app.route("/")
def index():
  return "Hello World!"


if __name__ == "__main__":
  app.run(port=port, host='0.0.0.0')
