const { gql } = require('apollo-server-lambda');

const typeDefs = gql`
  type Query {
    enquete(
        id: String
    ): Enquete
  }

  type Mutation {
    criarEnquete(titulo: String!, opcoes: [String]!): String
    votar(enqueteId: String!,opcao: String!): Enquete
  }

  type Enquete {
    id: String!
    titulo: String!
    opcoes: [String!]!
    votos: [Int!]!
  }
`;

module.exports = typeDefs;

