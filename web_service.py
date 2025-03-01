from flask import Flask, request, jsonify
import pickle

C = 1.0
input_file = f"model_C-{C}.bin"

with open(input_file, "rb") as f_in:
    dv, model = pickle.load(f_in)


app = Flask("ping")


@app.route("/predict", methods=["POST"])
def predict():
    customer = request.get_json()
    X = dv.transform(customer)
    y_pred = model.predict_proba(X)[0, 1]
    churn = y_pred > 0.5
    result = {"churn": bool(churn), "churn_probability": float(y_pred)}
    return jsonify(result)  # JSON RESPONSE


if __name__ == "__main__":
    app.run(
        debug=True, host="0.0.0.0", port=9696
    )  # DEBUG MODE REFRESHES THE SERVER AUTOMATICALLY WITH NEW CHANGE -> gunicorn --bind 0.0.0.0:9696 web_service:app
