// graphql.js
const { ApolloServer } = require('apollo-server-lambda');

// Construct a schema, using GraphQL schema language
const poll = require('./poll')

const server = new ApolloServer({
    ...poll,
});


exports.graphqlHandler = server.createHandler({
    cors: {
        origin: '*',
    },
});