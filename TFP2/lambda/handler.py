import json
import boto3
import uuid
import logging

# Configure CloudWatch logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource("dynamodb")
table_name = "tfp2-table"  # or use os.environ["DYNAMODB_TABLE"] if set
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    logger.info("Event received: %s", json.dumps(event))
    method = event.get("requestContext", {}).get("http", {}).get("method")
    path_params = event.get("pathParameters") or {}
    body = event.get("body")

    if body:
        try:
            body = json.loads(body)
        except Exception:
            body = {}

    # CREATE
    if method == "POST":
        item_id = str(uuid.uuid4())
        item = {"id": item_id, **body}
        table.put_item(Item=item)
        return response(201, {"message": "Item created", "item": item})

    # READ
    if method == "GET":
        item_id = path_params.get("id")
        if not item_id:
            items = table.scan().get("Items", [])
            return response(200, items)
        result = table.get_item(Key={"id": item_id})
        item = result.get("Item")
        if not item:
            return response(404, {"error": "Item not found"})
        return response(200, item)

    # UPDATE
    if method == "PUT":
        item_id = path_params.get("id")
        if not item_id:
            return response(400, {"error": "Missing id"})
        update_expr = []
        expr_attr_vals = {}
        for k, v in body.items():
            update_expr.append(f"{k} = :{k}")
            expr_attr_vals[f":{k}"] = v
        table.update_item(
            Key={"id": item_id},
            UpdateExpression="SET " + ", ".join(update_expr),
            ExpressionAttributeValues=expr_attr_vals
        )
        return response(200, {"message": "Item updated", "id": item_id})

    # DELETE
    if method == "DELETE":
        item_id = path_params.get("id")
        if not item_id:
            return response(400, {"error": "Missing id"})
        table.delete_item(Key={"id": item_id})
        return response(200, {"message": "Item deleted", "id": item_id})

    return response(400, {"error": "Unsupported method"})

def response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body)
    }
