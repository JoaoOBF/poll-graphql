const AWS = require('aws-sdk')

const setupDynamoDB = require('./setupDynamoDB')
const dynamoDB = setupDynamoDB()

async function create(titulo, opcoes) {
    const id = generateAccessCode()
    const params = {
        TableName: process.env.ENQUETE_TABLE,
        Item: {
            id,
            titulo,
            opcoes,
            votos: Array.from({ length: opcoes.length }, () => 0)
        }
    }
    await execute(() => dynamoDB.put(params).promise())

    return id
}

async function get(id) {
    const params = {
        TableName: process.env.ENQUETE_TABLE,
        KeyConditionExpression: 'id = :valorDaChavePrimaria',
        ExpressionAttributeValues: {
            ':valorDaChavePrimaria': id,
        },
        Limit: 1,
    };

    const data = await dynamoDB.query(params).promise();
    if (data.Items.length > 0) {
        const itemEncontrado = data.Items[0];
        return itemEncontrado
    }
    return null
}

function generateAccessCode() {
    const codeLength = 6;
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    let accessCode = "";
    for (let i = 0; i < codeLength; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        accessCode += characters[randomIndex];
    }

    return accessCode;
}

async function execute(fn) {
    try {
        await fn()
    } catch (error) {
        if (error.code === 'ResourceNotFoundException') {
            const host = process.env.LOCALSTACK_HOST
            const port = process.env.DYNAMODB_PORT

            const db = new AWS.DynamoDB({
                region: 'localhost',
                accessKeyId: "DEFAULT_ACCESS_KEY",
                secretAccessKey: "DEFAULT_SECRET",
                endpoint: new AWS.Endpoint(`http://${host}:${port}`)
            });
            const params = {
                TableName: process.env.ENQUETE_TABLE,
                AttributeDefinitions: [
                    {
                        AttributeName: 'id',
                        AttributeType: 'S',
                    },
                ],
                KeySchema: [
                    {
                        AttributeName: 'id',
                        KeyType: 'HASH',
                    },
                ],
                ProvisionedThroughput: {
                    ReadCapacityUnits: 1,
                    WriteCapacityUnits: 1,
                },
            };
            await db.createTable(params).promise();
        }
        throw error;
    }
}

async function vote(enqueteId, opcao) {
    const item = await get(enqueteId)
    const posicaoOpcao = item.opcoes.indexOf(opcao);
    item.votos[posicaoOpcao]++;
    const params = {
        TableName: process.env.ENQUETE_TABLE,
        Key: {
            id: enqueteId,
        },
        UpdateExpression: 'SET votos = :novoValor',
        ExpressionAttributeValues: {
            ':novoValor': item.votos,
        },
        ReturnValues: 'UPDATED_NEW',
    };

    await execute(() => dynamoDB.update(params).promise())

    return item
}


module.exports = {
    create,
    get,
    vote,
}