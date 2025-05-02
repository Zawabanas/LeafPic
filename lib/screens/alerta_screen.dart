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
        ],
      ),
      body: _buildListaAlertas(context),
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
                    : Icons.thermostat, // o .bug_report si tienes otros tipos
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
