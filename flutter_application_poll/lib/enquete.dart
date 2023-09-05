import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'enquete_model.dart';

class Enquete extends StatefulWidget {
  final String? id;
  const Enquete({Key? key, this.id}) : super(key: key);

  @override
  State<Enquete> createState() => _EnqueteState();
}

class _EnqueteState extends State<Enquete> {
  final TextEditingController _idController = TextEditingController();
  EnqueteModel? enqueteData;
  late IO.Socket socket;

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(
      'http://localhost:3000/graphql',
    ),
  );

  @override
  void initState() {
    super.initState();

    socket = IO.io('http://localhost:8080', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('novoVoto', (data) {
      setState(() {
        EnqueteModel novaEnqueteData = EnqueteModel.fromJson(data as Map<String, dynamic>);
        if(novaEnqueteData.id == enqueteData?.id) {
          enqueteData = EnqueteModel.fromJson(data as Map<String, dynamic>);
        }
      });
    });

    if (widget.id != null) {
      _idController.text = widget.id!;
      _buscarEnquete();
    }
  }

  void votar(String opcao) {
    socket.emit('votar', {
      'enqueteId': enqueteData!.id,
      'opcao': opcao,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquete App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Buscar Enquete',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID da Enquete'),
            ),
            ElevatedButton(
              onPressed: () {
                _buscarEnquete();
              },
              child: Text('Buscar Enquete'),
            ),
            SizedBox(height: 20),
            Text(
              'Detalhes da Enquete:',
              style: TextStyle(fontSize: 16),
            ),
            enqueteData != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: enqueteData!.opcoes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String opcao = enqueteData!.opcoes[index];
                      final int totalVotos = enqueteData!.votos[index];

                      return ListTile(
                        onTap: () => votar(opcao),
                        title: Text(opcao),
                        subtitle: Text('Total de Votos: $totalVotos'),
                      );
                    },
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Future<void> _buscarEnquete() async {
    final String id = _idController.text;

    final QueryResult result = await client.query(
      QueryOptions(
        document: gql('''
          query BuscarEnquete(\$id: String) {
            enquete(id: \$id) {
              id
              titulo
              opcoes
              votos
            }
          }
        '''),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    if (result.hasException) {
      print('Erro ao buscar enquete: ${result.exception.toString()}');
      return;
    }

    final enquete =
        EnqueteModel.fromJson(result.data!['enquete'] as Map<String, dynamic>);

    setState(() {
      enqueteData = enquete;
    });
  }
}
