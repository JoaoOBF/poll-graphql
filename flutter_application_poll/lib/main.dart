// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late IO.Socket socket;
//   TextEditingController tituloController = TextEditingController();
//   TextEditingController perguntasController = TextEditingController();
//   List<Map<String, dynamic>> enquetes = [];

//   @override
//   void initState() {
//     super.initState();

//     // Conectar ao servidor Node.js via WebSocket
//     socket = IO.io('http://localhost:8080', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     // Lidar com eventos recebidos do servidor
//     socket.on('enqueteCriada', (data) {
//       print(data);
//     });
//   }

//   void criarEnquete() {
//     final titulo = tituloController.text;
//     final perguntas =
//         perguntasController.text.split(',').map((e) => e.trim()).toList();

//     // Emitir um evento para criar a enquete
//     socket.emit('criarEnquete', {
//       'titulo': titulo,
//       'perguntas': perguntas,
//     });

//     // Limpar campos do formulário
//     tituloController.clear();
//     perguntasController.clear();
//     setState(() {
//       enquetes.add({
//         'titulo': titulo,
//         'perguntas': perguntas,
//       });
//     });
//   }

//   void votar(int index, int id) {
//     socket.emit('votar', {
//       'id': id,
//       'pergunta': index,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enquetes em Tempo Real'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             TextField(
//               controller: tituloController,
//               decoration: InputDecoration(labelText: 'Título da Enquete'),
//             ),
//             TextField(
//               controller: perguntasController,
//               decoration: InputDecoration(
//                   labelText: 'Perguntas (separadas por vírgula)'),
//             ),
//             ElevatedButton(
//               onPressed: criarEnquete,
//               child: Text('Criar Enquete'),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: enquetes.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(enquetes[index]['titulo']),
//                     subtitle: GestureDetector(
//                       onTap: () {},
//                       child: Text(
//                         enquetes[index]['perguntas'].join(', '),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_poll/enquete.dart';
import 'package:flutter_application_poll/nova_enquete.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enquete App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            ElevatedButton(
              onPressed: () {
                _criarEnquete();
              },
              child: Text('Criar Enquete'),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                _buscarEnquete();
              },
              child: Text('Buscar Enquete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _criarEnquete() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NovaEnquete(),
      ),
    );
  }

  Future<void> _buscarEnquete() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Enquete(),
      ),
    );
  }
}
