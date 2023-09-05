import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'enquete.dart';

class NovaEnquete extends StatefulWidget {
  const NovaEnquete({Key? key}) : super(key: key);

  @override
  State<NovaEnquete> createState() => _NovaEnqueteState();
}

class _NovaEnqueteState extends State<NovaEnquete> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController perguntasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar enquete'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título da Enquete'),
            ),
            TextField(
              controller: perguntasController,
              decoration: InputDecoration(
                  labelText: 'Perguntas (separadas por vírgula)'),
            ),
            ElevatedButton(
              onPressed: _criarEnquete,
              child: Text('Criar Enquete'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Future<void> _criarEnquete() async {
    final titulo = tituloController.text;
    final perguntas =
        perguntasController.text.split(',').map((e) => e.trim()).toList();

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        'http://localhost:3000/graphql',
      ),
    );

    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql('''
          mutation CriarEnquete(\$titulo: String!, \$opcoes: [String]!) {
            criarEnquete(titulo: \$titulo, opcoes: \$opcoes)
          }
        '''),
        variables: <String, dynamic>{
          'titulo': titulo,
          'opcoes': perguntas,
        },
      ),
    );

    if (result.hasException) {
      print('Erro ao criar enquete: ${result.exception.toString()}');
      return;
    }

    final String enqueteId = result.data!['criarEnquete'] as String;
    print('Enquete criada com sucesso. ID: $enqueteId');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Enquete(
          id: enqueteId,
        ),
      ),
    );
  }
}
