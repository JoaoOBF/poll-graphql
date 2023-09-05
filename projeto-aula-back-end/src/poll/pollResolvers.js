const db = require('../dynamo/enqueteDb')

const resolvers = {
    Query: {
        enquete: async (root, { id }, context, info) => {
            const items = await db.get(id)
            return items
        }
    },
    Mutation: {
        criarEnquete: async (_, { titulo, opcoes }) => {
            const id = await db.create(titulo, opcoes)
            return id;
        },
        votar: async (_, { enqueteId, opcao }) => {
            const id = await db.vote(enqueteId, opcao)
            return id;
        },
    },
};

module.exports = resolvers;