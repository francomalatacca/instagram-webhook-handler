import os
import json

VERIFY_TOKEN = os.environ.get("VERIFY_TOKEN")

def lambda_handler(event, context):
    method = event.get('httpMethod', '')

    if method == 'GET':
        query = event.get('queryStringParameters') or {}
        if query.get('hub.verify_token') == VERIFY_TOKEN:
            return {
                'statusCode': 200,
                'body': query.get('hub.challenge', '')
            }
        return {
            'statusCode': 403,
            'body': 'Invalid verification token'
        }

    elif method == 'POST':
        # Handle Instagram comment webhook events here
        try:
            body = json.loads(event.get('body', '{}'))
            print("📥 Instagram Webhook Event:")
            print(json.dumps(body, indent=2))
        except Exception as e:
            print("⚠️ Error parsing event body:", str(e))

        return {
            'statusCode': 200,
            'body': 'OK'
        }

    return {
        'statusCode': 405,
        'body': 'Method Not Allowed'
    }
