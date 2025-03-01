Build the Docker Image: 
    - docker build -t churn_predictor .

Run the Docker Image with Port Mapping:
    - docker run -p 9696:9696 -td churn_predictor