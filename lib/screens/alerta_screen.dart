import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alerta_provider.dart';

class AlertasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Alertas'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                () =>
                    Provider.of<AlertaProvider>(
                      context,
                      listen: false,
                    ).limpiarAlertas(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'simular_humedad':
                  Provider.of<AlertaProvider>(
                    context,
                    listen: false,
                  ).simularAlertaHumedad();
                  break;
                case 'simular_plaga':
                  Provider.of<AlertaProvider>(
                    context,
                    listen: false,
                  ).simularAlertaPlaga();
                  break;
                // Puedes agregar más casos aquí para otras simulaciones
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'simular_humedad',
                  child: Text('Simular Humedad Crítica'),
                ),
                PopupMenuItem<String>(
                  value: 'simular_plaga',
                  child: Text('Simular Alerta de Plaga'),
                ),
                // Agrega más opciones aquí si es necesario
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSimuladores(
            context,
          ), // Puedes eliminar esta línea si no necesitas los botones en la parte superior
          Expanded(child: _buildListaAlertas(context)),
        ],
      ),
    );
  }

  Widget _buildSimuladores(BuildContext context) {
    // Puedes eliminar este método si decides usar solo el PopupMenuButton
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Simular Humedad Crítica'),
            onPressed:
                () =>
                    Provider.of<AlertaProvider>(
                      context,
                      listen: false,
                    ).simularAlertaHumedad(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Simular Alerta de Plaga'),
            onPressed:
                () =>
                    Provider.of<AlertaProvider>(
                      context,
                      listen: false,
                    ).simularAlertaPlaga(),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAlertas(BuildContext context) {
    final alertas = Provider.of<AlertaProvider>(context).alertas;

    if (alertas.isEmpty) {
      return Center(child: Text('No hay alertas recientes'));
    }

    return ListView.builder(
      itemCount: alertas.length,
      itemBuilder:
          (ctx, index) => Card(
            color: alertas[index].critica ? Colors.red[100] : Colors.blue[50],
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(
                alertas[index].tipo == "humedad"
                    ? Icons.opacity
                    : Icons.bug_report,
                color: alertas[index].critica ? Colors.red : Colors.green,
              ),
              title: Text(alertas[index].mensaje),
              subtitle: Text(
                '${alertas[index].fecha.hour}:${alertas[index].fecha.minute}',
              ),
              trailing:
                  alertas[index].critica
                      ? Icon(Icons.warning, color: Colors.red)
                      : null,
            ),
          ),
    );
  }
}
