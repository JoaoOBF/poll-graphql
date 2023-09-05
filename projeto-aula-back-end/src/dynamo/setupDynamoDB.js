const AWS = require('aws-sdk')

function setupDynamoDBClient() {
    const host = process.env.LOCALSTACK_HOST
    const port = process.env.DYNAMODB_PORT
    console.log('running dynamodb locally!', host, port)

    return new AWS.DynamoDB.DocumentClient({
        region: 'localhost',
        accessKeyId: "DEFAULT_ACCESS_KEY",
        secretAccessKey: "DEFAULT_SECRET",
        endpoint: new AWS.Endpoint(`http://${host}:${port}`)
    })
}

module.exports = setupDynamoDBClient